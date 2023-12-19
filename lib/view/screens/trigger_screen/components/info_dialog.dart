import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/style.dart';

Future InfoDialog(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    barrierLabel: 'Label',
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 15, vertical: displayHeight(context, 0.16)),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              decoration: BoxDecoration(
                  color: primaryWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: veryLightGrey, width: 1),
                  boxShadow: const [
                    BoxShadow(
                        color: veryLightGrey,
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(2, 2))
                  ]),
              width: displayWidth(context, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    aboutPriceTag,
                    style: textStyle(
                        fontSize: 16, color: darkGrey, fontFamily: latoRegular),
                  ),
                  HeightSizedBox(context, 0.01),
                  infoText(
                    context,
                    lowPrice,
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
                  ),
                  HeightSizedBox(context, 0.01),
                  infoText(
                    context,
                    lowPrice,
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
                  ),
                  HeightSizedBox(context, 0.01),
                  infoText(
                    context,
                    lowPrice,
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget infoText(BuildContext context, String title, String description) {
  return SizedBox(
    width: displayWidth(context, 1),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: textStyle(
              fontSize: 15, color: lightBlack, fontFamily: latoSemiBold),
        ),
        HeightSizedBox(context, 0.005),
        Text(
          description,
          style:
              textStyle(fontSize: 14, color: darkGrey, fontFamily: latoRegular),
        ),
      ],
    ),
  );
}
