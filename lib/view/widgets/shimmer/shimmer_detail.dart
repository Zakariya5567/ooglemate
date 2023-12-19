import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerDetail extends StatelessWidget {
  const ShimmerDetail({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: veryLightGrey,
        highlightColor: cardGreyColor,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: displayHeight(context, 0.01)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: displayHeight(context, 0.25),
                  width: displayWidth(context, 1),
                  decoration: BoxDecoration(
                    color: primaryWhite,
                    borderRadius: BorderRadius.circular(8),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: displayHeight(context, 0.04),
                width: displayWidth(context, 0.8),
                color: cardGreyColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: displayHeight(context, 0.04),
                width: displayWidth(context, 0.8),
                color: cardGreyColor,
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Container(
                        height: displayHeight(context, 0.06),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: veryLightGrey),
                            color: cardGreyColor),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: displayHeight(context, 0.022),
                                width: displayWidth(context, 0.4),
                                color: primaryWhite,
                              ),
                              Container(
                                height: displayHeight(context, 0.022),
                                width: displayWidth(context, 0.4),
                                color: primaryWhite,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
