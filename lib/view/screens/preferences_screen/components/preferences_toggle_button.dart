import 'package:caroogle/providers/preferences_add_data_provider.dart';
import 'package:caroogle/providers/preferences_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_sizedbox.dart';

class PreferencesToggleButton extends StatelessWidget {
  const PreferencesToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer<PreferencesProvider>(builder: (context, controller, child) {
          return Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(60),
                onTap: () {
                  controller.setToggleValue(0);
                  Provider.of<PreferencesAddDataProvider>(context)
                      .setHide(false);
                },
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      color: controller.toggleValue == 0
                          ? primaryBlue
                          : primaryWhite,
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: controller.toggleValue == 0
                            ? primaryBlue
                            : lightBlue,
                      )),
                  child: Center(
                    child: Text(
                      btnAddManually,
                      style: textStyle(
                          fontSize: 12,
                          color: controller.toggleValue == 0
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
                  controller.setToggleValue(1);
                },
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      color: controller.toggleValue == 1
                          ? primaryBlue
                          : primaryWhite,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: controller.toggleValue == 1
                            ? primaryBlue
                            : lightBlue,
                      )),
                  child: Center(
                    child: Text(
                      btnUploadCsv,
                      style: textStyle(
                          fontSize: 12,
                          color: controller.toggleValue == 1
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
