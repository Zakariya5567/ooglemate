import 'package:caroogle/utils/images.dart';
import 'package:caroogle/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../utils/colors.dart';
import '../../../utils/dimension.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {required this.buttonName,
      required this.onPressed,
      required this.buttonGradient,
      required this.buttonTextColor,
      required this.padding});

  String buttonName;
  VoidCallback onPressed;
  Gradient buttonGradient;
  Color buttonTextColor;
  double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Container(
          height: displayHeight(context, 0.060),
          width: displayWidth(context, 1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryBlue),
              gradient: buttonGradient),
          child: Center(
            child: Text(buttonName,
                style: textStyle(
                    fontSize: 14,
                    color: buttonTextColor,
                    fontFamily: sfProText)),
          ),
        ),
      ),
    );
  }
}
