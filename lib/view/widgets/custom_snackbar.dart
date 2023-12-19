import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/style.dart';
import 'package:flutter/material.dart';

SnackBar customSnackBar(BuildContext context, String message, int isError) {
  return SnackBar(
    duration: const Duration(seconds: 5),
    dismissDirection: DismissDirection.up,
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.zero,
    content: Container(
      height: 100,
      decoration: BoxDecoration(
          color: isError == 0 ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(-4, 4),
            ),
          ]),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            textAlign: TextAlign.start,
            style: textStyle(
                fontSize: 14, color: primaryWhite, fontFamily: latoRegular),
          ),
        ),
      ),
    ),
  );
}
