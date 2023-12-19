import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/inventory_add_new_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_sizedbox.dart';

class InventoryMappingRadioList extends StatelessWidget {
  InventoryMappingRadioList({required this.radioList});

  List radioList;

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryAddNewProvider>(
        builder: (context, controller, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "${controller.mapIndex + 1}: ${controller.mapTitle[controller.mapIndex]}",
              textAlign: TextAlign.start,
              style: textStyle(
                  fontSize: 16, color: primaryBlue, fontFamily: latoBold),
            ),
          ),
          HeightSizedBox(context, 0.01),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: SizedBox(
              height: displayHeight(context, 0.42),
              child: ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: radioList.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: displayWidth(context, 1),
                      height: displayHeight(context, 0.06),
                      child: RadioListTile<String>(
                          toggleable: true,
                          selected: true,
                          activeColor: primaryBlue,
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            radioList[index],
                            textAlign: TextAlign.start,
                            style: textStyle(
                                fontSize: 16,
                                color: primaryBlue,
                                fontFamily: latoRegular),
                          ),
                          value: controller.value,
                          groupValue: radioList[index],
                          onChanged: (String? newValue) {
                            controller.setCsvMap(
                                controller.mapTitle[controller.mapIndex],
                                radioList[index]);
                            controller.value = radioList[index];
                          }),
                    );
                  }),
            ),
          )
        ],
      );
    });
  }
}
