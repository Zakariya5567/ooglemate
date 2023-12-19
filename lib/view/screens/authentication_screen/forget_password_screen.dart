import 'dart:io';
import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/authentication_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/utils/style.dart';
import 'package:caroogle/view/widgets/authentication_textField.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_button.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: primaryBlack,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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
                            forgetPassword,
                            style: textStyle(
                                fontSize: 24,
                                color: primaryBlack,
                                fontFamily: latoBold),
                          ),
                          HeightSizedBox(context, 0.02),
                          Text(
                            forgetDescription,
                            style: textStyle(
                                fontSize: 16,
                                color: primaryGrey,
                                fontFamily: latoBold),
                          ),
                          HeightSizedBox(context, 0.09),
                          AuthenticationTextField(
                            controller: controller.forgetEmailController,
                            hintText: hintEmail,
                            labelText: emailId,
                          ),
                          HeightSizedBox(context, 0.12),
                          CustomButton(
                              buttonName: btnResetPassword,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  Future.delayed(Duration.zero, () async {
                                    // calling api
                                    await controller.forgotPassword(
                                        context, RouterHelper.signInScreen);
                                  });
                                }

                                debugPrint("user not logged in");
                              },
                              buttonGradient: gradientBlue,
                              buttonTextColor: primaryWhite,
                              padding: 0),
                        ],
                      )),
                ));
          }),
        ),
      ),
    );
  }
}
