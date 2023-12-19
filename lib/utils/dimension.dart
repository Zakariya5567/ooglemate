import 'package:flutter/material.dart';

Size displaySize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context, pixel) {
  return MediaQuery.of(context).size.height * pixel;
}

double displayWidth(BuildContext context, pixel) {
  return MediaQuery.of(context).size.width * pixel;
}
