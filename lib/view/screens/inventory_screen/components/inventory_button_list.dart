import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/inventory_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_sizedbox.dart';

class InventoryButtonList extends StatelessWidget {
  const InventoryButtonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer<InventoryProvider>(builder: (context, controller, child) {
          return Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(60),
                onTap: () {
                  controller.setToggleIndex(0);
                  controller.clearOffset();
                  controller.getAllInventories(
                      context, 0, RouterHelper.inventoryScreen);
                },
                child: Container(
                  height: 40,
                  width: displayWidth(context, 0.28),
                  decoration: BoxDecoration(
                      color: controller.toggleIndex == 0
                          ? primaryBlue
                          : primaryWhite,
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: controller.toggleIndex == 0
                            ? primaryBlue
                            : lightBlue,
                      )),
                  child: Center(
                    child: Text(
                      all,
                      style: textStyle(
                          fontSize: 12,
                          color: controller.toggleIndex == 0
                              ? primaryWhite
                              : lightBlue,
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
                  controller.getAllInventories(
                      context, 0, RouterHelper.inventoryScreen);
                },
                child: Container(
                  height: 40,
                  width: displayWidth(context, 0.28),
                  decoration: BoxDecoration(
                      color: controller.toggleIndex == 1
                          ? primaryBlue
                          : primaryWhite,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: controller.toggleIndex == 1
                            ? primaryBlue
                            : lightBlue,
                      )),
                  child: Center(
                    child: Text(
                      btnPurchased,
                      style: textStyle(
                          fontSize: 12,
                          color: controller.toggleIndex == 1
                              ? primaryWhite
                              : lightBlue,
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
                  controller.getAllInventories(
                      context, 0, RouterHelper.inventoryScreen);
                },
                child: Container(
                  height: 40,
                  width: displayWidth(context, 0.28),
                  decoration: BoxDecoration(
                      color: controller.toggleIndex == 2
                          ? primaryBlue
                          : primaryWhite,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: controller.toggleIndex == 2
                            ? primaryBlue
                            : lightBlue,
                      )),
                  child: Center(
                    child: Text(
                      btnSold,
                      style: textStyle(
                          fontSize: 12,
                          color: controller.toggleIndex == 2
                              ? primaryWhite
                              : lightBlue,
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
