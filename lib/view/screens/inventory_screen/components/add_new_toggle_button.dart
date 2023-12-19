import 'package:caroogle/providers/inventory_add_new_provider.dart';
import 'package:caroogle/providers/preferences_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../../providers/inventory_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_sizedbox.dart';

class AddNewToggleButton extends StatelessWidget {
  const AddNewToggleButton({Key? key}) : super(key: key);
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
                  controller.setAddNewToggleValue(0);
                  Provider.of<InventoryAddNewProvider>(context).setHide(false);
                },
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      color: controller.addNewToggleValue == 0
                          ? primaryBlue
                          : primaryWhite,
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: controller.addNewToggleValue == 0
                            ? primaryBlue
                            : lightBlue,
                      )),
                  child: Center(
                    child: Text(
                      btnAddManually,
                      style: textStyle(
                          fontSize: 12,
                          color: controller.addNewToggleValue == 0
                              ? primaryWhite
                              : lightBlue,
                          fontFamily: latoRegular),
                    ),
                  ),
                ),
              ),
              WidthSizedBox(context, 0.02),
              InkWell(
                borderRadius: BorderRadius.circular(60),
                onTap: () {
                  controller.setAddNewToggleValue(1);
                },
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      color: controller.addNewToggleValue == 1
                          ? primaryBlue
                          : primaryWhite,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: controller.addNewToggleValue == 1
                            ? primaryBlue
                            : lightBlue,
                      )),
                  child: Center(
                    child: Text(
                      btnUploadCsv,
                      style: textStyle(
                          fontSize: 12,
                          color: controller.addNewToggleValue == 1
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
