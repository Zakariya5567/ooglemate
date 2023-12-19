import 'package:flutter/material.dart';

Widget HeightSizedBox(BuildContext context, double height) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * height,
  );
}

Widget WidthSizedBox(BuildContext context, double width) {
  return SizedBox(
    width: MediaQuery.of(context).size.height * width,
  );
}
