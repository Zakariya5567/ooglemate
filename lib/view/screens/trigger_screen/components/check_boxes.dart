import 'package:caroogle/providers/set_trigger_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_sizedbox.dart';

class CheckBoxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SetTriggerProvider>(builder: (context, controller, child) {
      return Container(
        height: displayHeight(context, 0.10),
        width: displayWidth(context, 1),
        color: primaryWhite,
        child: GridView(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 0,
              childAspectRatio: 10 / 2),
          children: controller.checkValues.keys.map((String key) {
            return InkWell(
                onTap: () {
                  controller.setCheckBoxValue(key);
                },
                child: Row(
                  children: [
                    Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: controller.checkValues[key] == true
                                ? primaryBlue
                                : primaryWhite,
                            border: Border.all(
                                width: 1.5,
                                color: controller.checkValues[key] == true
                                    ? primaryBlue
                                    : primaryGrey)),
                        child: controller.checkValues[key] == true
                            ? const Icon(
                                Icons.check,
                                size: 15.0,
                                color: primaryWhite,
                              )
                            : Container()),
                    WidthSizedBox(context, 0.01),
                    Text(
                      key == 'all'
                          ? "All"
                          : key == 'low'
                              ? "Low Price"
                              : key == 'average'
                                  ? "Average Price"
                                  : "Good Price",
                      style: textStyle(
                        fontSize: 14,
                        color: primaryGrey,
                        fontFamily: latoRegular,
                      ),
                    )
                  ],
                ));
          }).toList(),
        ),
      );
    });
  }
}
