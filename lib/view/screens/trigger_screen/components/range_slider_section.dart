import 'package:caroogle/providers/set_trigger_provider.dart';
import 'package:caroogle/providers/trigger_provider.dart';
import 'package:caroogle/view/widgets/customRangeSlider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/string.dart';

class RangeSliderSection extends StatelessWidget {
  const RangeSliderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SetTriggerProvider>(builder: (context, controller, child) {
      return Column(
        children: [
          CustomRangeSlider(
            provider: controller,
            title: km,
            rangeStart: controller.kmValues.start.toInt(),
            rangeEnd: controller.kmValues.end.toInt(),
          ),
          CustomRangeSlider(
            provider: controller,
            title: priceRange,
            rangeStart: controller.priceValues.start.toInt(),
            rangeEnd: controller.priceValues.end.toInt(),
          ),
          CustomRangeSlider(
            provider: controller,
            title: makeYear,
            rangeStart: controller.makeYearValues.start.toInt(),
            rangeEnd: controller.makeYearValues.end.toInt(),
          ),
        ],
      );
    });
  }
}
