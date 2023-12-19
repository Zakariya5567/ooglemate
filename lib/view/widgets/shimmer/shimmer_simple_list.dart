import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSimpleList extends StatelessWidget {
  ShimmerSimpleList({required this.pagination});
  int pagination;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: pagination == 0 ? 10 : 2,
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: pagination == 0 ? 10 : 1,
                  vertical: displayHeight(context, 0.004)),
              child: Container(
                height: displayHeight(context, 0.12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // border: Border.all(color: veryLightGrey),
                    color: cardGreyColor),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 15, vertical: displayHeight(context, 0.02)),
                  child: Shimmer.fromColors(
                    baseColor: veryLightGrey,
                    highlightColor: cardGreyColor,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: displayHeight(context, 0.014),
                                width: displayWidth(context, 0.5),
                                color: primaryWhite,
                              ),
                              HeightSizedBox(context, 0.01),
                              Container(
                                height: displayHeight(context, 0.010),
                                width: displayWidth(context, 0.4),
                                color: primaryWhite,
                              ),
                              HeightSizedBox(context, 0.01),
                              Container(
                                height: displayHeight(context, 0.012),
                                width: displayWidth(context, 0.6),
                                color: primaryWhite,
                              ),
                              HeightSizedBox(context, 0.01),
                              Container(
                                height: displayHeight(context, 0.010),
                                width: displayWidth(context, 0.5),
                                color: primaryWhite,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
