import 'dart:ui';

import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/style.dart';

class DetailList extends StatelessWidget {
  DetailList({required this.title, required this.description});

  String title;
  String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeightSizedBox(context, 0.005),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.start,
              style: textStyle(
                  fontSize: 16, color: primaryBlack, fontFamily: latoSemiBold),
            ),
            WidthSizedBox(context, 0.02),
            Flexible(
              flex: 1,
              child: title == "Ad URL"
                  ? InkWell(
                      onTap: () {},
                      child: Text(
                        description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        style: textStyle(
                            fontSize: 16,
                            color: primaryBlue,
                            fontFamily: latoRegular),
                      ),
                    )
                  : Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.end,
                      style: textStyle(
                          fontSize: 16,
                          color: lightGrey,
                          fontFamily: latoRegular),
                    ),
            ),
          ],
        ),
        HeightSizedBox(context, 0.005),
        const Divider(
          color: lightGrey,
        )
      ],
    );
  }
}
