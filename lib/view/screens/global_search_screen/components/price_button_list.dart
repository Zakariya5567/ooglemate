import 'package:caroogle/providers/global_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helper/routes_helper.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_sizedbox.dart';

class PriceButtonList extends StatelessWidget {
  const PriceButtonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer<GlobalScreenProvider>(builder: (context, controller, child) {
          return Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(60),
                onTap: () {
                  controller.setToggleIndex(0);
                  controller.clearOffset();
                  controller.getGlobalSearchData(
                      context, 0, RouterHelper.globalSearchScreen);
                },
                child: Container(
                  height: displayHeight(context, 0.047),
                  width: displayWidth(context, 0.29),
                  decoration: BoxDecoration(
                      color: controller.toggleIndex == 0
                          ? primaryBlue
                          : primaryWhite,
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: primaryBlue,
                      )),
                  child: Center(
                    child: Text(
                      "Low",
                      style: textStyle(
                          fontSize: 12,
                          color: controller.toggleIndex == 0
                              ? primaryWhite
                              : primaryBlue,
                          fontFamily: latoRegular),
                    ),
                  ),
                ),
              ),
              WidthSizedBox(context, 0.01),
              InkWell(
                borderRadius: BorderRadius.circular(60),
                onTap: () {
                  controller.setToggleIndex(1);
                  controller.clearOffset();
                  controller.getGlobalSearchData(
                      context, 0, RouterHelper.globalSearchScreen);
                },
                child: Container(
                  height: displayHeight(context, 0.047),
                  width: displayWidth(context, 0.29),
                  decoration: BoxDecoration(
                      color: controller.toggleIndex == 1
                          ? primaryBlue
                          : primaryWhite,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: primaryBlue,
                      )),
                  child: Center(
                    child: Text(
                      "Good",
                      style: textStyle(
                          fontSize: 12,
                          color: controller.toggleIndex == 1
                              ? primaryWhite
                              : primaryBlue,
                          fontFamily: latoRegular),
                    ),
                  ),
                ),
              ),
              WidthSizedBox(context, 0.01),
              InkWell(
                borderRadius: BorderRadius.circular(60),
                onTap: () {
                  controller.setToggleIndex(2);
                  controller.clearOffset();
                  controller.getGlobalSearchData(
                      context, 0, RouterHelper.globalSearchScreen);
                },
                child: Container(
                  height: displayHeight(context, 0.047),
                  width: displayWidth(context, 0.29),
                  decoration: BoxDecoration(
                      color: controller.toggleIndex == 2
                          ? primaryBlue
                          : primaryWhite,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: primaryBlue,
                      )),
                  child: Center(
                    child: Text(
                      "Best",
                      style: textStyle(
                          fontSize: 12,
                          color: controller.toggleIndex == 2
                              ? primaryWhite
                              : primaryBlue,
                          fontFamily: latoRegular),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
