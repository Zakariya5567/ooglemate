import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import '../../utils/style.dart';

class ValidationMessage extends StatelessWidget {
  ValidationMessage({required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5),
      child: SizedBox(
        width: displayWidth(context, 0.4),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: textStyle(
              fontSize: 12, color: primaryRed, fontFamily: latoRegular),
        ),
      ),
    );
  }
}
