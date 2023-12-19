import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/style.dart';

class ProfileAppBar extends StatelessWidget {
  ProfileAppBar({required this.title, required this.color});

  String title;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: primaryBlack,
                  size: 20,
                )),
            WidthSizedBox(context, 0.01),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textStyle(
                  fontSize: 16, color: primaryBlack, fontFamily: rubikRegular),
            ),
          ],
        ),
      ),
    );
  }
}
