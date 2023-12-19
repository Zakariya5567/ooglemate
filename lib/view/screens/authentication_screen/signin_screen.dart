import 'dart:io';
import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/authentication_provider.dart';
import 'package:caroogle/utils/app_constant.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/utils/images.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/utils/style.dart';
import 'package:caroogle/view/widgets/authentication_textField.dart';
import 'package:caroogle/view/widgets/circular_progress.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/subscription_provider.dart';
import '../../widgets/connection.dart';
import '../../widgets/custom_button.dart';
import 'components/custom_socail_button.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: SafeArea(
        bottom: Platform.isAndroid ? true : false,
        top: Platform.isAndroid ? true : false,
        child: Scaffold(
          //  resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: primaryWhite,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: primaryWhite,
          body: Consumer<AuthProvider>(builder: (context, controller, child) {
            return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            welcome,
                            style: textStyle(
                                fontSize: 24,
                                color: primaryBlack,
                                fontFamily: latoBold),
                          ),
                          HeightSizedBox(context, 0.01),
                          Text(
                            signInToContinue,
                            style: textStyle(
                                fontSize: 16,
                                color: primaryGrey,
                                fontFamily: latoBold),
                          ),
                          HeightSizedBox(context, 0.09),
                          AuthenticationTextField(
                            controller: controller.signInEmailController,
                            hintText: hintEmail,
                            labelText: emailId,
                          ),
                          HeightSizedBox(context, 0.03),
                          AuthenticationTextField(
                            controller: controller.signInPasswordController,
                            hintText: hintPassword,
                            labelText: password,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () async {
                                  controller.clearTextField();
                                  Navigator.pushNamed(context,
                                      RouterHelper.forgetPasswordScreen);
                                },
                                child: Text(
                                  btnForgetPassword,
                                  style: textStyle(
                                      fontSize: 12,
                                      color: primaryBlack,
                                      fontFamily: latoMedium),
                                ),
                              )),
                          HeightSizedBox(context, 0.06),
                          CustomButton(
                              buttonName: btnLogin,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  // check for text field is empty or not
                                  // if text field is not empty then we will call api
                                  if (controller.signInEmailController.text
                                          .isNotEmpty &&
                                      controller.signInPasswordController.text
                                          .isNotEmpty) {
                                    //calling api
                                    await controller.login(
                                        context, RouterHelper.signInScreen);
                                  }

                                  // after api calling we will check for api response
                                  // "false" mean api response is OK

                                  if (controller.loginModel.error == false) {
                                    // instance of shared preferences
                                    SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();

                                    // get user subscription
                                    String? subscription = sharedPreferences
                                        .getString(AppConstant.subscription);

                                    debugPrint("Subscription: $subscription");
                                    //Here to set subscription is on or off

                                    // if subscription is available  "1 available , 0 not"
                                    if (subscriptionProvider
                                            .subscriptionSettingModel
                                            .data!
                                            .subscriptionEnabled ==
                                        1) {
                                      // it user have not get any package plan
                                      if (subscription == 'NoSubscription') {
                                        Future.delayed(Duration.zero, () {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  RouterHelper.choosePlanScreen,
                                                  (route) => false);
                                          controller.clearTextField();
                                        });
                                      } else {
                                        Future.delayed(Duration.zero, () {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  RouterHelper.homeScreen,
                                                  (route) => false);
                                          controller.clearTextField();
                                        });
                                      }
                                    } else {
                                      Future.delayed(Duration.zero, () {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                RouterHelper.homeScreen,
                                                (route) => false);
                                        controller.clearTextField();
                                      });
                                    }
                                  }
                                  debugPrint("text field is empty");
                                }
                              },
                              buttonGradient: gradientBlue,
                              buttonTextColor: primaryWhite,
                              padding: 0),
                          HeightSizedBox(context, 0.05),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              orContinueWith,
                              style: textStyle(
                                  fontSize: 12,
                                  color: primaryBlack,
                                  fontFamily: latoMedium),
                            ),
                          ),
                          HeightSizedBox(context, 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomSocialButton(
                                  image: Images.google,
                                  onPressed: () async {
                                    debugPrint("google");

                                    //calling api
                                    await controller
                                        .socialSignup(context, "google",
                                            RouterHelper.signInScreen)
                                        .then((value) async {
                                      // after api calling we will check for api response
                                      // "false" mean api response is OK

                                      if (controller.socialLoginModel.error ==
                                          false) {
                                        // instance of shared preferences

                                        SharedPreferences sharedPreferences =
                                            await SharedPreferences
                                                .getInstance();

                                        // get user subscription
                                        String? subscription =
                                            sharedPreferences.getString(
                                                AppConstant.subscription);

                                        //Here to set subscription is on or off
                                        debugPrint(
                                            "Subscription: $subscription");

                                        // if subscription is available  "1 available , 0 not"

                                        if (subscriptionProvider
                                                .subscriptionSettingModel
                                                .data!
                                                .subscriptionEnabled ==
                                            1) {
                                          // it user have not get any package plan
                                          if (subscription ==
                                              'NoSubscription') {
                                            Future.delayed(Duration.zero, () {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  RouterHelper.choosePlanScreen,
                                                  (route) => false);
                                            });
                                          } else {
                                            Future.delayed(Duration.zero, () {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  RouterHelper.homeScreen,
                                                  (route) => false);
                                            });
                                          }
                                        } else {
                                          Future.delayed(Duration.zero, () {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                RouterHelper.homeScreen,
                                                (route) => false);
                                          });
                                        }
                                      }
                                    });
                                  }),
                              WidthSizedBox(context, 0.05),
                              CustomSocialButton(
                                  image: Images.apple,
                                  onPressed: () async {
                                    debugPrint("apple");

                                    //calling api
                                    await controller
                                        .socialSignup(context, "apple",
                                            RouterHelper.signInScreen)
                                        .then((value) async {
                                      // after api calling we will check for api response
                                      // "false" mean api response is OK

                                      if (controller.socialLoginModel.error ==
                                          false) {
                                        // instance of shared preferences
                                        SharedPreferences sharedPreferences =
                                            await SharedPreferences
                                                .getInstance();

                                        // get user subscription
                                        String? subscription =
                                            sharedPreferences.getString(
                                                AppConstant.subscription);
                                        //Here to set subscription is on or off
                                        debugPrint(
                                            "Subscription: $subscription");
                                        // if subscription is available  "1 available , 0 not"

                                        if (subscriptionProvider
                                                .subscriptionSettingModel
                                                .data!
                                                .subscriptionEnabled ==
                                            1) {
                                          if (subscription ==
                                              'NoSubscription') {
                                            Future.delayed(Duration.zero, () {
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      RouterHelper
                                                          .choosePlanScreen,
                                                      (route) => false);
                                            });
                                          } else {
                                            Future.delayed(Duration.zero, () {
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      RouterHelper.homeScreen,
                                                      (route) => false);
                                            });
                                          }
                                        } else {
                                          Future.delayed(Duration.zero, () {
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    RouterHelper.homeScreen,
                                                    (route) => false);
                                          });
                                        }
                                      }
                                    });
                                  }),
                            ],
                          ),
                          HeightSizedBox(context, 0.06),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dontHaveAccount,
                                style: textStyle(
                                    fontSize: 12,
                                    color: primaryBlack,
                                    fontFamily: latoMedium),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(RouterHelper.signUpScreen);
                                },
                                child: Text(
                                  signUp,
                                  style: textStyle(
                                      fontSize: 13,
                                      color: primaryBlue,
                                      fontFamily: latoBold),
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                ));
          }),
        ),
      ),
    );
  }
}
