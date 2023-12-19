import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPlan extends StatelessWidget {
  const ShimmerPlan({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeightSizedBox(context, 0.08),
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: displayHeight(context, 0.01)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: displayHeight(context, 0.04),
                    width: displayWidth(context, 0.50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: cardGreyColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10.0),
                      child: Shimmer.fromColors(
                        baseColor: veryLightGrey,
                        highlightColor: cardGreyColor,
                        child: Container(
                          height: displayHeight(context, 0.01),
                          width: displayWidth(context, 0.03),
                          color: primaryWhite,
                        ),
                      ),
                    )),
                Container(
                    height: displayHeight(context, 0.04),
                    width: displayWidth(context, 1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        //  border: Border.all(color: veryLightGrey),
                        color: cardGreyColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10.0),
                      child: Shimmer.fromColors(
                        baseColor: veryLightGrey,
                        highlightColor: cardGreyColor,
                        child: Container(
                          height: displayHeight(context, 0.01),
                          width: displayWidth(context, 1),
                          color: primaryWhite,
                        ),
                      ),
                    )),
              ],
            )),
        ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                      height: displayHeight(context, 0.25),
                      width: displayWidth(context, 1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: veryLightGrey),
                          color: cardGreyColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 15.0),
                        child: Shimmer.fromColors(
                          baseColor: veryLightGrey,
                          highlightColor: cardGreyColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeightSizedBox(context, 0.02),
                              Container(
                                height: displayHeight(context, 0.022),
                                width: displayWidth(context, 0.5),
                                color: primaryWhite,
                              ),
                              HeightSizedBox(context, 0.02),
                              Container(
                                height: displayHeight(context, 0.018),
                                width: displayWidth(context, 0.6),
                                color: primaryWhite,
                              ),
                              HeightSizedBox(context, 0.02),
                              Container(
                                height: displayHeight(context, 0.015),
                                width: displayWidth(context, 0.7),
                                color: primaryWhite,
                              ),
                              HeightSizedBox(context, 0.02),
                              Container(
                                height: displayHeight(context, 0.015),
                                width: displayWidth(context, 0.65),
                                color: primaryWhite,
                              ),
                            ],
                          ),
                        ),
                      )));
            }),
      ],
    );
  }
}
