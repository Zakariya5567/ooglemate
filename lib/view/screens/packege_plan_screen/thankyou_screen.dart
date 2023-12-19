import 'dart:io';

import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/utils/style.dart';
import 'package:caroogle/view/widgets/authentication_textField.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/images.dart';
import '../../widgets/custom_button.dart';

class ThankYouScreen extends StatelessWidget {
  ThankYouScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: SafeArea(
        bottom: Platform.isAndroid ? true : false,
        top: Platform.isAndroid ? true : false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: primaryWhite,
            appBar: AppBar(
              backgroundColor: primaryWhite,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    Images.logoBlue,
                    height: displayWidth(context, 0.20),
                    width: displayWidth(context, 0.25),
                  ),
                  HeightSizedBox(context, 0.10),
                  Image.asset(
                    Images.subscribed,
                    height: displayWidth(context, 0.35),
                    width: displayWidth(context, 0.35),
                  ),
                  HeightSizedBox(context, 0.06),
                  Text(
                    thankYouForJoiningUs,
                    style: textStyle(
                        fontSize: 24,
                        color: primaryBlack,
                        fontFamily: latoBold),
                  ),
                  HeightSizedBox(context, 0.01),
                  Text(
                    thankYouMessage,
                    textAlign: TextAlign.center,
                    style: textStyle(
                        fontSize: 15, color: primaryGrey, fontFamily: latoBold),
                  ),
                  HeightSizedBox(context, 0.14),
                  CustomButton(
                      buttonName: btnContinue,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RouterHelper.homeScreen);
                      },
                      buttonGradient: gradientBlue,
                      buttonTextColor: primaryWhite,
                      padding: 0)
                ],
              ),
            ))),
      ),
    );
  }
}
