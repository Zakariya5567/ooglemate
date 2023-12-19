import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton(
      {required this.icon,
      required this.onTap,
      //required this.scale,
      required this.height,
      required this.width,
      required this.color});

  String icon;
  VoidCallback onTap;
  // double scale;
  Color color;
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        icon,
        color: color,
        height: height,
        width: width,
      ),
    );
  }
}
