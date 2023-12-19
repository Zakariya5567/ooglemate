import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGridPagination extends StatelessWidget {
  const ShimmerGridPagination({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: primaryWhite),
              color: cardGreyColor),
          child: Shimmer.fromColors(
            baseColor: veryLightGrey,
            highlightColor: cardGreyColor,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: displayHeight(context, 0.18),
                      decoration: BoxDecoration(
                        color: primaryWhite,
                        borderRadius: BorderRadius.circular(8),
                      )),
                  HeightSizedBox(context, 0.01),
                  Container(
                    height: displayHeight(context, 0.018),
                    width: displayWidth(context, 0.3),
                    color: primaryWhite,
                  ),
                  HeightSizedBox(context, 0.01),
                  Container(
                    height: displayHeight(context, 0.012),
                    width: displayWidth(context, 0.4),
                    color: primaryWhite,
                  ),
                  HeightSizedBox(context, 0.01),
                  Container(
                    height: displayHeight(context, 0.016),
                    width: displayWidth(context, 0.4),
                    color: primaryWhite,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
