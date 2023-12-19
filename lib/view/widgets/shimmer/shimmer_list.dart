import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  ShimmerList({required this.pagination});
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
                  horizontal: pagination == 0 ? 10 : 0, vertical: 5),
              child: Container(
                height: displayHeight(context, 0.15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    //  border: Border.all(color: veryLightGrey),
                    color: cardGreyColor),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 15, vertical: displayHeight(context, 0.008)),
                  child: Shimmer.fromColors(
                    baseColor: veryLightGrey,
                    highlightColor: cardGreyColor,
                    child: Row(
                      children: [
                        Container(
                            height: displayHeight(context, 0.22),
                            width: displayWidth(context, 0.25),
                            decoration: BoxDecoration(
                              color: primaryWhite,
                              borderRadius: BorderRadius.circular(8),
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: displayHeight(context, 0.005)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: displayHeight(context, 0.022),
                                width: displayWidth(context, 0.5),
                                color: primaryWhite,
                              ),
                              HeightSizedBox(context, 0.01),
                              Container(
                                height: displayHeight(context, 0.018),
                                width: displayWidth(context, 0.4),
                                color: primaryWhite,
                              ),
                              HeightSizedBox(context, 0.01),
                              Container(
                                height: displayHeight(context, 0.018),
                                width: displayWidth(context, 0.4),
                                color: primaryWhite,
                              ),
                              HeightSizedBox(context, 0.01),
                              Container(
                                height: displayHeight(context, 0.015),
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
