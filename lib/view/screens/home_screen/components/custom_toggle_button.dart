import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/home_screen_provider.dart';
import 'package:caroogle/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/images.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_sizedbox.dart';

class CustomToggleButton extends StatelessWidget {
  const CustomToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Consumer<HomeScreenProvider>(builder: (context, controller, child) {
        return Container(
            height: displayHeight(context, 0.05),
            width: displayWidth(context, 0.7),
            decoration: BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: lightBlue)),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () {
                      controller.setToggle(0);
                      controller.clearFilter();
                      controller.clearOffset();
                      controller.getRecommended(
                          context, 0, RouterHelper.homeScreen);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.toggleIndex == 0
                            ? primaryBlue
                            : primaryWhite,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageIcon(
                              const AssetImage(
                                Images.iconRecommended,
                              ),
                              color: controller.toggleIndex == 0
                                  ? primaryWhite
                                  : lightBlue,
                              size: 15,
                            ),
                            WidthSizedBox(context, 0.01),
                            Text(
                              recommended,
                              style: textStyle(
                                  fontSize: 12,
                                  color: controller.toggleIndex == 0
                                      ? primaryWhite
                                      : lightBlue,
                                  fontFamily: latoRegular),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () {
                      controller.setToggle(1);
                      controller.clearOffset();
                      controller.clearFilter();
                      controller.getAllMatches(
                          context, 0, RouterHelper.homeScreen);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.toggleIndex == 1
                            ? primaryBlue
                            : primaryWhite,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageIcon(
                              const AssetImage(
                                Images.iconCar,
                              ),
                              color: controller.toggleIndex == 1
                                  ? primaryWhite
                                  : lightBlue,
                              size: 15,
                            ),
                            WidthSizedBox(context, 0.01),
                            Text(
                              allMatches,
                              style: textStyle(
                                  fontSize: 12,
                                  color: controller.toggleIndex == 1
                                      ? primaryWhite
                                      : lightBlue,
                                  fontFamily: latoRegular),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      }),
    );
  }
}
