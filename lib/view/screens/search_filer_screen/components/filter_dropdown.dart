import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';

import '../../../../utils/dimension.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';

class FilterDropdown extends StatelessWidget {
  FilterDropdown({required this.controller});
  var controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     CustomDropdown(
        //       provider: controller,
        //       title: carMake,
        //       items: ['make1', 'make2', 'make3', 'make4'],
        //     ),
        //     CustomDropdown(
        //       provider: controller,
        //       title: carModel,
        //       items: ['model1', 'model2', 'model3', 'model4'],
        //     ),
        //   ],
        // ),
        // HeightSizedBox(context, 0.01),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Container(
        //         height: displayHeight(context, 0.10),
        //         width: displayWidth(context, 0.40),
        //         color: primaryWhite,
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               keyWords,
        //               style: textStyle(
        //                   fontSize: 16,
        //                   color: primaryBlack,
        //                   fontFamily: latoBold),
        //             ),
        //             CustomTextField(
        //               controller: controller.keyWordsController,
        //               hintText: hintKeyWords,
        //               height: 40,
        //             )
        //           ],
        //         )),
        //     CustomDropdown(
        //       provider: controller,
        //       title: colours,
        //       items: const ['model1', 'model2', 'model3', 'model4'],
        //     ),
        //   ],
        // ),
        // HeightSizedBox(context, 0.01),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     CustomDropdown(
        //       provider: controller,
        //       title: fuelType,
        //       items: const ['fuel1', 'fuel2', 'fuel3', 'fuel4'],
        //     ),
        //     Container(
        //         height: 70,
        //         width: displayWidth(context, 0.40),
        //         color: primaryWhite,
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               carBadge,
        //               style: textStyle(
        //                   fontSize: 16,
        //                   color: primaryBlack,
        //                   fontFamily: latoBold),
        //             ),
        //             CustomTextField(
        //               controller: controller.carBadgeController,
        //               hintText: hintEnterCarBadge,
        //               height: 40,
        //             )
        //           ],
        //         )),
        //     // CustomDropdown(
        //     //   provider: controller,
        //     //   title: carBadge,
        //     //   items: const ['badge1', 'badge2', 'badge3', 'badge4'],
        //     // ),
        //   ],
        // )
      ],
    );
  }
}
