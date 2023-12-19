import 'dart:async';

import 'package:caroogle/data/models/authentication/login_model.dart';
import 'package:caroogle/providers/subscription_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caroogle/utils/app_constant.dart';
import '../../../helper/notification_service.dart';
import '../../../helper/routes_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    handleNotification();
    routes();
  }

  // Calling notification for listen the app is in which state (foreground,background,terminated)
  handleNotification() async {
    await NotificationService().handleNotification(context);
  }

  // Function to set routing
  void routes() async {
    Future.delayed(Duration.zero, () async {
      // instance of subscription provider class
      final subscriptionProvider =
          Provider.of<SubscriptionProvider>(context, listen: false);

      // instance of shared preferences
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // get the login status

      bool? isLogin = sharedPreferences.getBool(AppConstant.isLogin);

      // get subscription status
      String? subscription =
          sharedPreferences.getString(AppConstant.subscription);

      Future.delayed(Duration.zero, () async {
        //  Calling api to check for is subscription method is available or not "0,1"
        await subscriptionProvider
            .getSubscriptionSetting(context, RouterHelper.initial)
            .then((value) {
          // check for user login status
          if (isLogin == true) {
            // check for subscription availability
            // 1 for available 0 for not
            // if the subscription method available then we will check for user  is subscribe or not "get any plan or not"
            if (subscriptionProvider
                    .subscriptionSettingModel.data!.subscriptionEnabled ==
                1) {
              // checking for user hava already get any plan or not
              // "NoSubscription" mean no package plan is selected
              if (subscription == 'NoSubscription') {
                Navigator.of(context)
                    .pushReplacementNamed(RouterHelper.choosePlanScreen);
              } else {
                Navigator.of(context)
                    .pushReplacementNamed(RouterHelper.homeScreen);
              }
            } else {
              Navigator.of(context)
                  .pushReplacementNamed(RouterHelper.homeScreen);
            }
          } else {
            Navigator.of(context)
                .pushReplacementNamed(RouterHelper.signInScreen);
          }
        });
      });
    });

    // Timer(const Duration(seconds: 3), () {
    //   if (isLogin == true) {
    //     //Here to set subscription is on or off
    //
    //     if (subscriptionProvider
    //             .subscriptionSettingModel.data!.subscriptionEnabled ==
    //         1) {
    //       if (subscription == 'NoSubscription') {
    //         Navigator.of(context)
    //             .pushReplacementNamed(RouterHelper.choosePlanScreen);
    //       } else {
    //         Navigator.of(context).pushReplacementNamed(RouterHelper.homeScreen);
    //       }
    //     } else {
    //       Navigator.of(context).pushReplacementNamed(RouterHelper.homeScreen);
    //     }
    //   } else {
    //     Navigator.of(context).pushReplacementNamed(RouterHelper.signInScreen);
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
  }

  @override
  Widget build(BuildContext context) {
    blueStatusBar();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
    return Stack(
      children: [
        Scaffold(
            backgroundColor: primaryBlue,
            body: Container(
              height: displayHeight(context, 1),
              width: displayWidth(context, 1),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(Images.splashBackground))),
              child: Center(
                child: Image.asset(
                  Images.logo,
                  scale: displayWidth(context, 0.012),
                ),
              ),
            )),
      ],
    );
  }
}
