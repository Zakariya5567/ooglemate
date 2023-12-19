import 'package:flutter/material.dart';

// fontFamily

const String latoLight = "Lato-Light";
const String latoRegular = "Lato-Regular";
const String latoMedium = "Lato-Medium";
const String latoSemiBold = "Lato-Semibold";
const String latoBold = "Lato-Bold";

const String rubikLight = "Rubik-Light";
const String rubikRegular = "Rubik-Regular";
const String rubikMedium = "Rubik-Medium";
const String rubikBold = "Rubik-Bold";

const String sfProText = "SFProText";

TextStyle textStyle(
    {required double fontSize,
    required Color color,
    required String fontFamily}) {
  return TextStyle(fontSize: fontSize, color: color, fontFamily: fontFamily);
}
