import 'package:flutter/cupertino.dart';

class MyBehavior extends ScrollBehavior {
  // Setting of scroll behaviour to remove blue glow
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
