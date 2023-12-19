import 'package:caroogle/helper/provider_helper.dart';
import 'package:caroogle/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';

class EditProfileList extends StatelessWidget {
  EditProfileList(
      {required this.title,
      required this.controller,
      required this.text,
      required this.isDob});
  String title;
  TextEditingController controller;
  String text;
  bool isDob;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: displayHeight(context, 0.062),
          width: displayWidth(context, 0.26),
          decoration: BoxDecoration(
            //color: Colors.red,
            border: Border(
                bottom: BorderSide(
                    color: title == profileDob
                        ? Colors.transparent
                        : veryLightGrey,
                    width: 1)),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: textStyle(
                  fontSize: 14, color: primaryGrey, fontFamily: latoRegular),
            ),
          ),
        ),
        Container(
          height: displayHeight(context, 0.062),
          width: displayWidth(context, 0.55),
          decoration: BoxDecoration(
            //color: Colors.green,
            border: Border(
                bottom: BorderSide(
                    color: title == profileDob
                        ? Colors.transparent
                        : veryLightGrey,
                    width: 1)),
          ),
          child: isDob == true
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Provider.of<ProfileProvider>(context).dobText == null
                      ? Text(
                          text,
                          style: textStyle(
                              fontSize: 15,
                              color: veryLightGrey,
                              fontFamily: latoRegular),
                        )
                      : Text(
                          Provider.of<ProfileProvider>(context).dobText!,
                          style: textStyle(
                              fontSize: 14,
                              color: primaryBlack,
                              fontFamily: latoRegular),
                        ))
              : TextFormField(
                  autofocus: false,
                  controller: controller,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(fontSize: 14),
                  obscureText: false,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.text,
                  validator: (value) {},
                  onTap: () {},
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(fontSize: 12),
                    fillColor: primaryWhite,
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: text,
                    hintStyle: textStyle(
                        fontSize: 15,
                        color: veryLightGrey,
                        fontFamily: latoRegular),
                    contentPadding: EdgeInsets.zero,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
        )
      ],
    );
  }
}
