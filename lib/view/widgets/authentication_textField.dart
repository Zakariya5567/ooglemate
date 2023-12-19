import 'package:caroogle/providers/authentication_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationTextField extends StatelessWidget {
  //This text field widget we are using in all Authentication screen
  // Receiving  three parameters
  //  1 Controller => which is the text Editing controller of the text field
  //  2 Hint text =>  the hint of the text field
  //  3 label text => the label of the text field

  AuthenticationTextField({
    required this.controller,
    required this.hintText,
    required this.labelText,
  });
  TextEditingController controller = TextEditingController();
  String hintText;
  String labelText;

  @override
  Widget build(BuildContext context) {
    // instance of the auth provider class
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return SizedBox(
      child: TextFormField(
        autofocus: false,
        controller: controller,

        // if the text field is empty the validation will be always true
        // if the user start typing then the validation will be in user interaction

        autovalidateMode: controller.text.isNotEmpty
            ? AutovalidateMode.always
            : AutovalidateMode.onUserInteraction,
        style: const TextStyle(fontSize: 14),

        // Set obscure if text field is password
        obscureText: controller == authProvider.signInPasswordController ||
                controller == authProvider.signUpPasswordController
            ? true
            : false,

        // Key board type when controller of the text field is related to email then the text type well be email type otherwise the type will be text

        keyboardType: controller == authProvider.signInEmailController ||
                controller == authProvider.signUpEmailController
            ? TextInputType.emailAddress
            : TextInputType.text,
        validator: (value) {
          // checking for validation
          // for every field i have created a validation function inside  auth provider class

          if (controller == authProvider.signUpNameController) {
            return authProvider.nameValidation(value);
          } else if (controller == authProvider.signInEmailController ||
              controller == authProvider.signUpEmailController ||
              controller == authProvider.forgetEmailController) {
            return authProvider.emailValidation(value);
          } else if (controller == authProvider.signInPasswordController ||
              controller == authProvider.signUpPasswordController) {
            return authProvider.passwordValidation(value);
          }
        },

        // Action button of the keyboard =>  controller of the text field is related to password then the button will be  done  be otherwise the type will be

        // checking for text input action
        textInputAction: controller == authProvider.signInPasswordController ||
                controller == authProvider.signUpPasswordController
            ? TextInputAction.done
            : TextInputAction.next,
        decoration: InputDecoration(
          errorStyle: textStyle(
              fontSize: 12, color: primaryRed, fontFamily: latoRegular),
          fillColor: primaryWhite,
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: labelText,
          labelStyle: textStyle(
              fontSize: 14, color: primaryGrey, fontFamily: latoMedium),
          hintText: hintText,
          hintStyle: textStyle(
              fontSize: 12, color: lightGrey, fontFamily: latoRegular),
          // Content padding is the inside padding of the text field
          contentPadding: EdgeInsets.symmetric(
              vertical: displayHeight(context, 0.022), horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: veryLightGrey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryRed, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: veryLightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryBlue),
          ),
        ),
      ),
    );
  }
}
