import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:flutter/material.dart';

class CustomSocialButton extends StatelessWidget {
  CustomSocialButton({
    required this.image,
    required this.onPressed,
  });

  String image;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onPressed,
        child: Container(
          height: displayWidth(context, 0.17),
          width: displayWidth(context, 0.17),
          decoration: BoxDecoration(
              color: primaryWhite,
              shape: BoxShape.circle,
              border: Border.all(color: veryLightGrey)),
          child: Center(
              child: Image.asset(
            image,
            height: displayWidth(context, 0.06),
            width: displayWidth(context, 0.06),
          )),
        ));
  }
}
