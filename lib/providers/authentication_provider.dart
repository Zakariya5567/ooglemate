import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:caroogle/data/models/authentication/forgot_password_model.dart';
import 'package:caroogle/data/models/authentication/logout_model.dart';
import 'package:caroogle/utils/api_url.dart';
import 'package:caroogle/utils/app_constant.dart';
import 'package:caroogle/view/widgets/custom_snackbar.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../data/models/authentication/login_model.dart';
import '../data/models/authentication/signup_model.dart';
import '../data/models/authentication/social_login_model.dart';
import '../data/repository/api_repo.dart';
import '../helper/connection_checker.dart';
import '../utils/colors.dart';
import '../view/widgets/circular_progress.dart';
import '../view/widgets/loader_dialog.dart';

//import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  // isLoading variable is declared for loading state of the API
  // When we call Api we are setting loader or shimmer
  // isLoading == true its means we will show loader
  // if loading false we will finish loader and show UI
  bool? isLoading;

  // Text Editing controller is the controller of Text field
  // We have three Authentication screen  and every screen have Text field

  // Text field controller of SignInScreen
  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();

  // Text field controller of SignUpScreen
  TextEditingController signUpNameController = TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();

  // Text field controller of Forger ForgetScreenScreen
  TextEditingController forgetEmailController = TextEditingController();

  //Instance Model classes
  SignupModel signupModel = SignupModel();
  LoginModel loginModel = LoginModel();
  SocialLoginModel socialLoginModel = SocialLoginModel();
  ForgotPasswordModel forgotPasswordModel = ForgotPasswordModel();
  LogOutModel logOutModel = LogOutModel();

  // Repository class instance
  // In Repository class i have define all Methods of APIs
  ApiRepo apiRepo = ApiRepo();

  //===========================================================================
  // VALIDATION SECTION

  // Name text field validation
  nameValidation(value) {
    if (value.isEmpty) {
      return "Enter Your Name";
    }
  }

  // Email text field validation
  emailValidation(value) {
    if (value.isEmpty) {
      return "Enter Your Email";
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Please enter valid email";
    }

    return null;
  }

  // Phone text field validation
  phoneValidation(value) {
    String pattern = r'^(?:[+0][1-9])?[0-9]{11}$';
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      return "Enter Your Phone Number";
    } else if (!regExp.hasMatch(value)) {
      return "Enter Valid Phone Number";
    }
  }

  // Password text field validation
  passwordValidation(value) {
    if (value.isEmpty) {
      return "Enter Your Password";
    } else if (value.length < 6) {
      return "Password At least 6 Characters";
    }
  }

//=================================================================================

  //To clear textField data , i have created this methods
  clearTextField() {
    signInEmailController.clear();
    signInPasswordController.clear();
    signUpNameController.clear();
    signUpEmailController.clear();
    signUpPasswordController.clear();
    forgetEmailController.clear();
    notifyListeners();
  }

  // Methods to set the state of loading
  // Assigning values to isLoading variable

  setLoading(BuildContext context, bool value) {
    isLoading = value;
    if (value == true) {
      loaderDialog(context);
    } else {
      Navigator.of(context).pop();
    }
    notifyListeners();
  }

//===============================================================================
  // APIs calling section

  // SIGNUP
  signUp(BuildContext context, String screen) async {
    // Check for internet connection
    return checkInternet(context, screen).then((value) async {
      //connection true then call api otherwise navigate to Error screen
      if (value == true) {
        //Getting firebase fcm token
        await FirebaseMessaging.instance.getToken().then((token) async {
          debugPrint("fcm_token: $token");
          String? fcmToken = token;
          if (fcmToken != null) {
            // Store token in Shared preferences to get if required after
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            // Set token
            await sharedPreferences.setString(AppConstant.fcmToken, fcmToken);

            // ignore: use_build_context_synchronously
            setLoading(context, true);

            // Get token of fcm
            String? token = sharedPreferences.getString(AppConstant.fcmToken);
            debugPrint(" signup ==========================>>>");
            debugPrint(" fcm_token ==========================>>> $token");

            try {
              // To call repository api methods and then store in response
              Response response =
                  // ignore: use_build_context_synchronously
                  await apiRepo.postData(context, screen, ApiUrl.signUpUrl, {
                "name": signUpNameController.text,
                "email": signUpEmailController.text,
                "password": signUpPasswordController.text,
                "fcm_token": token
              });
              final responseBody = response.data;
              debugPrint("response body ===============>>> $responseBody");

              // Assign and parse api response data in model class
              signupModel = SignupModel.fromJson(responseBody);

              // If response have no error
              if (signupModel.error == false) {
                // Set user id in shared preferences
                sharedPreferences.setString(
                    AppConstant.userId, signupModel.data!.id.toString());
                // Set user email in shared preferences
                sharedPreferences.setString(
                    AppConstant.userEmail, signupModel.data!.email.toString());
                // Set bearer in shared preferences
                sharedPreferences.setString(AppConstant.bearerToken,
                    signupModel.data!.token.toString());
                // Set login state in shared preferences
                sharedPreferences.setBool(AppConstant.isLogin, true);
                // Set stripe id (user already get any package) in shared preferences
                if (signupModel.data!.stripeCustomerId != null) {
                  sharedPreferences.setString(AppConstant.subscription,
                      signupModel.data!.stripeCustomerId!);
                } else {
                  sharedPreferences.setString(
                      AppConstant.subscription, "NoSubscription");
                }
              } else {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                    // ignore: use_build_context_synchronously
                    customSnackBar(context, signupModel.message.toString(), 1));
              }

              // ignore: use_build_context_synchronously
              setLoading(context, false);
            } catch (e) {
              // ignore: use_build_context_synchronously
              setLoading(context, false);
            }

            notifyListeners();
          }
        });
      }
    });
  }

  // LOGIN
  // Login and signup apis calling having codes style
  login(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        await FirebaseMessaging.instance.getToken().then((token) async {
          debugPrint("fcm_token: $token");
          String? fcmToken = token;
          if (fcmToken != null) {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            await sharedPreferences.setString(AppConstant.fcmToken, fcmToken);

            // ignore: use_build_context_synchronously
            setLoading(context, true);

            String? token = sharedPreferences.getString(AppConstant.fcmToken);
            debugPrint(" login ==========================>>>");
            debugPrint(" fcm_token ==========================>>> $token");

            try {
              // ignore: use_build_context_synchronously
              Response response =
                  // ignore: use_build_context_synchronously
                  await apiRepo.postData(context, screen, ApiUrl.loginInUrl, {
                "email": signInEmailController.text,
                "password": signInPasswordController.text,
                "fcm_token": token
              });
              final responseBody = response.data;
              debugPrint("response body ===============>>> $responseBody");
              loginModel = LoginModel.fromJson(responseBody);

              if (loginModel.error == false) {
                // store user id
                sharedPreferences.setString(
                    AppConstant.userId, loginModel.data!.id.toString());

                // store user email
                sharedPreferences.setString(
                    AppConstant.userEmail, loginModel.data!.email.toString());

                // store bearer token
                sharedPreferences.setString(
                    AppConstant.bearerToken, loginModel.data!.token.toString());

                // store login status
                sharedPreferences.setBool(AppConstant.isLogin, true);

                if (loginModel.data!.stripeCustomerId != null) {
                  // store user subscription
                  sharedPreferences.setString(AppConstant.subscription,
                      loginModel.data!.stripeCustomerId!);
                } else {
                  // store user "NoSubscription" if user have not selected any package plan

                  sharedPreferences.setString(
                      AppConstant.subscription, "NoSubscription");
                }
              } else {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                    // ignore: use_build_context_synchronously
                    customSnackBar(context, loginModel.message.toString(), 1));
              }
              // ignore: use_build_context_synchronously
              setLoading(context, false);
            } catch (e) {
              // ignore: use_build_context_synchronously
              setLoading(context, false);
            }

            notifyListeners();
          }
        });
      }
    });
  }

  // LOGOUT
  logOut(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        // ignore: use_build_context_synchronously
        setLoading(context, true);

        //Getting user token
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String? token = sharedPreferences.getString(AppConstant.fcmToken);
        debugPrint(" logout ==========================>>>");
        debugPrint(" fcm_token ==========================>>> $token");

        try {
          Response response =
              // ignore: use_build_context_synchronously
              await apiRepo.putData(context, screen, ApiUrl.loginOutUrl, {});
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          logOutModel = LogOutModel.fromJson(responseBody);

          if (logOutModel.error == false) {
            //Set the login state to false
            sharedPreferences.setBool(AppConstant.isLogin, false);
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
                // ignore: use_build_context_synchronously
                customSnackBar(context, logOutModel.message.toString(), 1));
          }

          // ignore: use_build_context_synchronously
          setLoading(context, false);
        } catch (e) {
          // ignore: use_build_context_synchronously
          setLoading(context, false);
        }

        notifyListeners();
      }
    });
  }

  //FORGOT PASSWORD
  forgotPassword(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        // ignore: use_build_context_synchronously
        setLoading(context, true);

        debugPrint(" forgotPassword ==========================>>>");

        try {
          // ignore: use_build_context_synchronously
          Response response = await apiRepo
              .postData(context, screen, ApiUrl.forgetPasswordUrl, {
            "email": forgetEmailController.text,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          forgotPasswordModel = ForgotPasswordModel.fromJson(responseBody);

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
              // ignore: use_build_context_synchronously
              customSnackBar(
                  context,
                  forgotPasswordModel.error == false
                      ? "${forgotPasswordModel.message.toString()} \n Please check your email"
                      : forgotPasswordModel.message.toString(),
                  forgotPasswordModel.error == false ? 0 : 1));

          // ignore: use_build_context_synchronously
          setLoading(context, false);
        } catch (e) {
          // ignore: use_build_context_synchronously
          setLoading(context, false);
        }

        notifyListeners();
      }
    });
  }

  //SOCIAL SIGNUP
  socialSignup(BuildContext context, String name, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        //Getting firebase fcm token
        await FirebaseMessaging.instance.getToken().then((token) async {
          debugPrint("fcm_token: $token");
          String? fcmToken = token;

          // checking for fcm token
          if (fcmToken != null) {
            // instance of shared preferences
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();

            // store fcm token
            await sharedPreferences.setString(AppConstant.fcmToken, fcmToken);

            // get the fcm token
            String? token = sharedPreferences.getString(AppConstant.fcmToken);
            debugPrint("social signup ==========================>>>");
            debugPrint(" fcm_token ==========================>>> $token");

            //calling methods of social login to Get Social login data
            Map<String, dynamic>? data = await getSocialData(name);

            try {
              // ignore: use_build_context_synchronously
              setLoading(context, true);
              // ignore: use_build_context_synchronously
              Response response = await apiRepo.postData(
                  context, screen, ApiUrl.socialLoginUrl, data);
              final responseBody = response.data;
              debugPrint("response body ===============>>> $responseBody");
              socialLoginModel = SocialLoginModel.fromJson(responseBody);

              if (socialLoginModel.error == false) {
                // store user id
                sharedPreferences.setString(
                    AppConstant.userId, socialLoginModel.data!.id.toString());

                // store user email
                sharedPreferences.setString(AppConstant.userEmail,
                    socialLoginModel.data!.email.toString());

                // store bearer token
                sharedPreferences.setString(AppConstant.bearerToken,
                    socialLoginModel.data!.token.toString());

                // store login status
                sharedPreferences.setBool(AppConstant.isLogin, true);

                if (socialLoginModel.data!.stripeCustomerId != null) {
                  // store user subscription
                  sharedPreferences.setString(AppConstant.subscription,
                      socialLoginModel.data!.stripeCustomerId!);
                } else {
                  // store user "NoSubscription" if user have not selected any package plan
                  sharedPreferences.setString(
                      AppConstant.subscription, "NoSubscription");
                }
              } else {
                // ignore: use_build_context_synchronously
                setLoading(context, false);
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                    context, socialLoginModel.message.toString(), 1));
                GoogleSignIn().signOut();
              }
            } catch (e) {
              // ignore: use_build_context_synchronously
              setLoading(context, false);
              debugPrint("Error : $e");
            }
            //}

            notifyListeners();
          }
        });
      }
    });
  }

//===============================================================================
// social signIn

  // instance of the firebase authentication
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getSocialData(String name) async {
    // instance of shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // get fcm token
    String? token = sharedPreferences.getString(AppConstant.fcmToken);
    debugPrint("Login with $name");

    Map<String, dynamic>? data;
    // if user call for google signIn
    if (name == "google") {
      GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      // sending data to api
      data = {
        "name": "${googleUser!.displayName}",
        "email": googleUser.email,
        "social_media_token": googleUser.id,
        "social_media_platform": "google",
        "fcm_token": token,
      };
    }

    // if user call for Apple signIn
    else if (name == "apple") {
      // We will user redirect url and client id,  if the device is android
      // We are generating url from glitch website, for more detail see the sign_in_with_apple package documents
      var redirectURL =
          "https://robust-giant-grenadilla.glitch.me/callbacks/sign_in_with_apple";
      var clientID = "com.OogleMate.appservices";

      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
            clientId: clientID, redirectUri: Uri.parse(redirectURL)),
      );
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );
      // sending data to api
      data = {
        "name": appleIdCredential.givenName == null &&
                appleIdCredential.familyName == null
            ? null
            : "${appleIdCredential.givenName} ${appleIdCredential.familyName}",
        "email": appleIdCredential.email.toString() == 'null'
            ? null
            : appleIdCredential.email.toString(),
        "social_media_token": "${appleIdCredential.identityToken}",
        "social_media_platform": "apple",
        "fcm_token": token,
        "os_type": Platform.isAndroid ? "android" : "ios",
      };

      print("data is : $data");
    }

    return data!;
  }
}
