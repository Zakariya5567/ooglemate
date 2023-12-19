import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/style.dart';

class ProfileItemList extends StatelessWidget {
  ProfileItemList(
      {required this.title, required this.button, required this.onTap});

  String title;
  Widget button;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textStyle(
                  fontSize: 16, color: darkGrey, fontFamily: latoSemiBold),
            ),
            button
          ],
        ),
      ),
    );
  }
}
