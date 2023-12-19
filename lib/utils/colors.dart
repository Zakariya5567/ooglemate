import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//primary swatch
const Map<int, Color> primaryColor = {
  50: Color.fromRGBO(66, 79, 159, 0.1),
  100: Color.fromRGBO(66, 79, 159, 0.2),
  200: Color.fromRGBO(66, 79, 159, 0.3),
  300: Color.fromRGBO(66, 79, 159, 0.4),
  400: Color.fromRGBO(66, 79, 159, 0.5),
  500: Color.fromRGBO(66, 79, 159, 0.6),
  600: Color.fromRGBO(66, 79, 159, 0.7),
  700: Color.fromRGBO(66, 79, 159, 0.8),
  800: Color.fromRGBO(66, 79, 159, 0.9),
  900: Color.fromRGBO(66, 79, 159, 1),
};

// blue
const primaryBlue = Color.fromRGBO(66, 79, 159, 1);
const darkBlue = Color.fromRGBO(33, 40, 80, 1);
const lightBlue = Color.fromRGBO(66, 79, 159, 0.50);

// white
const primaryWhite = Color.fromRGBO(255, 255, 255, 1);

//black
const primaryBlack = Color.fromRGBO(51, 51, 51, 1);
const darkBlack = Color.fromRGBO(39, 20, 23, 1);
const lightBlack = Color.fromRGBO(72, 70, 70, 1);

//veryLightGrey

const primaryGrey = Color.fromRGBO(130, 130, 130, 1);
const darkGrey = Color.fromRGBO(91, 90, 90, 1);
const lightGrey = Color.fromRGBO(39, 20, 23, 0.50);
const veryLightGrey = Color.fromRGBO(112, 112, 112, 0.21);

// yellow
const primaryYellow = Color.fromRGBO(255, 191, 0, 1);

// red color
const primaryRed = Color.fromRGBO(235, 57, 57, 1);

//card color
const cardLightColor = Color.fromRGBO(247, 247, 247, 1);
const cardGreyColor = Color.fromRGBO(243, 243, 243, 0.66);

// statusBar

whiteStatusBar() {
  return const SystemUiOverlayStyle(
      statusBarColor: primaryWhite,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: primaryWhite,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: cardLightColor);
}

greyStatusStatusBar() {
  return const SystemUiOverlayStyle(
      statusBarColor: cardLightColor,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: cardLightColor,
      systemNavigationBarDividerColor: cardLightColor);
}

blueStatusBar() {
  return SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: primaryBlue,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: primaryBlue,
      systemNavigationBarDividerColor: primaryBlue,
      systemNavigationBarIconBrightness: Brightness.light));
}

// gradient

Gradient gradientBlue = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryBlue, darkBlue]);

Gradient greyGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightGrey, darkGrey]);

Gradient gradientWhite = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryWhite, primaryWhite]);
