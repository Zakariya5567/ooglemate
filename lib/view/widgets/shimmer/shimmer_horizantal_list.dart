import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHorizantalList extends StatelessWidget {
  ShimmerHorizantalList({this.pagination});
  int? pagination;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: displayHeight(context, 0.3),
      width: displayWidth(context, 1),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const ScrollPhysics(),
          itemCount: pagination == 0 ? 10 : 2,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: displayHeight(context, 0.005)),
                child: Container(
                  height: displayHeight(context, 0.20),
                  width: displayWidth(context, 0.46),
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
                              height: displayHeight(context, 0.16),
                              width: displayWidth(context, 0.46),
                              decoration: BoxDecoration(
                                color: primaryWhite,
                                borderRadius: BorderRadius.circular(8),
                              )),
                          HeightSizedBox(context, 0.02),
                          Container(
                            height: displayHeight(context, 0.018),
                            width: displayWidth(context, 0.3),
                            color: primaryWhite,
                          ),
                          HeightSizedBox(context, 0.01),
                          Container(
                            height: displayHeight(context, 0.014),
                            width: displayWidth(context, 0.4),
                            color: primaryWhite,
                          ),
                          HeightSizedBox(context, 0.01),
                          Container(
                            height: displayHeight(context, 0.018),
                            width: displayWidth(context, 0.4),
                            color: primaryWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          }),
    );
  }
}
