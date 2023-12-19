import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/profile/app_notification_model.dart';
import '../data/models/profile/get_profile_model.dart';
import '../data/models/profile/update_profile_model.dart';
import '../data/repository/api_repo.dart';
import '../helper/connection_checker.dart';
import '../utils/api_url.dart';
import '../utils/app_constant.dart';
import '../view/widgets/custom_snackbar.dart';

class ProfileProvider extends ChangeNotifier {
  bool switchValue = false;
  int? option;
  bool? isLoading;
  String? dobText;
  bool? isNotify;

  setNotificationStatus(bool value) async {
    print("set Notification");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(AppConstant.isNotify, value);
    isNotify = sharedPreferences.getBool(AppConstant.isNotify);
    print("isNotify : $isNotify");
    notifyListeners();
  }

  setSwitchValue(bool newBool) {
    switchValue = !switchValue;

    if (switchValue == true) {
      option = 1;
    } else {
      option = 0;
    }
    print(option);
    notifyListeners();
  }

  setDobText(String value) {
    dobText = value;
    print("Value $value");
    print("Date OF BIRTH : ==============.>>>>>>>>> $dobText");
    notifyListeners();
  }

  // edit profile screen
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  // TextEditingController dobController = TextEditingController();

  File? image;

  GetProfileModel getProfileModel = GetProfileModel();
  UpdateProfileModel updateProfileModel = UpdateProfileModel();
  AppNotificationModel appNotificationModel = AppNotificationModel();

  ApiRepo apiRepo = ApiRepo();

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setImage(File newImage) {
    image = newImage;
    notifyListeners();
  }

  clearTextField() {
    userNameController.clear();
    emailController.clear();
    phoneController.clear();
    genderController.clear();
    dobText = null;
    notifyListeners();
  }
  //
  // nameValidation(value) {
  //   if (value.isEmpty) {
  //     return "Enter Your Name";
  //   }
  // }
  //
  // emailValidation(value) {
  //   if (value.isEmpty) {
  //     return "Enter Your Email";
  //   } else if (!RegExp(
  //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //       .hasMatch(value)) {
  //     return "please enter valid email";
  //   }
  //
  //   return null;
  // }
  //
  // phoneValidation(value) {
  //   String pattern = r'^(?:[+0][1-9])?[0-9]{11}$';
  //   RegExp regExp = RegExp(pattern);
  //
  //   if (value.isEmpty) {
  //     return "Enter Your Phone Number";
  //   } else if (!regExp.hasMatch(value)) {
  //     return "Enter Valid Phone Number";
  //   }
  // }
  //
  // genderValidation(value) {
  //   if (value.isEmpty) {
  //     return "Enter Your Gender";
  //   } else if (value != 'male' ||
  //       value != 'Male' ||
  //       value != 'female' ||
  //       value != 'Female') {
  //     return "Please Enter a valid gender";
  //   }
  // }
  //
  // dobValidation(value) {
  //   if (value.isEmpty) {
  //     return "Enter Your date of birth";
  //   } else if (!RegExp(r"^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$")
  //       .hasMatch(value)) {
  //     return "please enter valid date format e.g 2020-23-05";
  //   }
  // }

  //=================================================================================
  //Api

  // GET PROFILE
  getProfile(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint(" get plan  ==========================>>>");

        try {
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.getProfileUrl, {});
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          getProfileModel = GetProfileModel.fromJson(responseBody);
          if (getProfileModel.error == false) {
            clearTextField();
            if (getProfileModel.data!.name != null) {
              userNameController.text = getProfileModel.data!.name!;
            }
            if (getProfileModel.data!.email != null) {
              emailController.text = getProfileModel.data!.email!;
            }
            if (getProfileModel.data!.phone != null) {
              phoneController.text = getProfileModel.data!.phone!;
            }
            if (getProfileModel.data!.gender != null) {
              genderController.text = getProfileModel.data!.gender!;
            }
            if (getProfileModel.data!.gender != null) {
              genderController.text = getProfileModel.data!.gender!;
            }
            if (getProfileModel.data!.dob != null) {
              dobText = getProfileModel.data!.dob!;
            }
          }
          setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  //UPDATE PROFILE
  updateProfile(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint("update profile ==========================>>>");

        String? mimeType;
        String? mimee;
        String? type;

        if (image != null) {
          mimeType = mime(image!.path);
          mimee = mimeType?.split('/')[0];
          type = mimeType?.split('/')[1];
        }

        try {
          Response response = await apiRepo
              .postMultipartData(context, screen, ApiUrl.updateProfileUrl, {
            'photo': image == null
                ? null
                : await MultipartFile.fromFile(image!.path,
                    filename: image!.path,
                    contentType: MediaType(mimee!, type!)),
            "name": userNameController.text,
            "email": emailController.text,
            "phone": phoneController.text,
            "dob": dobText,
            "gender": genderController.text,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          updateProfileModel = UpdateProfileModel.fromJson(responseBody);

          if (updateProfileModel.error == true) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                context, updateProfileModel.message.toString(), 1));
          }

          // setLoading(false);
        } catch (e) {
          image = null;
          setLoading(false);
          print("Error: $e");

          notifyListeners();
        }

        notifyListeners();
      }
    });
  }

  //NOTIFICATION ENABLE DISABLE

  //All ENABLE DISABLE
  notificationEnableDisable(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        // setLoading(true);

        debugPrint("all enable disable ==========================>>>");
        try {
          Response response = await apiRepo
              .putData(context, screen, ApiUrl.enableDisableAllPreferencesUrl, {
            "option": option,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          appNotificationModel = AppNotificationModel.fromJson(responseBody);
          //  setLoading(false);
        } catch (e) {
          // setLoading(false);
        }

        notifyListeners();
      }
    });
  }
}
