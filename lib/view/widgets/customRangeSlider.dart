import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import '../../utils/string.dart';
import '../../utils/style.dart';
import 'custom_sizedbox.dart';

class CustomRangeSlider extends StatelessWidget {
  CustomRangeSlider({
    required this.provider,
    required this.title,
    required this.rangeStart,
    required this.rangeEnd,
  });

  String title;
  int rangeStart;
  int rangeEnd;
  var provider;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: displayWidth(context, 1),
        color: primaryWhite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textStyle(
                  fontSize: 16, color: primaryBlack, fontFamily: latoBold),
            ),
            HeightSizedBox(context, 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title == "Price Range"
                      ? "AU\$ " + rangeStart.toString()
                      : " " + rangeStart.toString(),
                  style: textStyle(
                      fontSize: 14,
                      color: primaryBlack,
                      fontFamily: latoRegular),
                ),
                Text(
                  to,
                  style: textStyle(
                      fontSize: 14, color: primaryGrey, fontFamily: latoBold),
                ),
                Text(
                  title == "Price Range"
                      ? "AU\$ " + rangeEnd.toString()
                      : " " + rangeEnd.toString(),
                  style: textStyle(
                      fontSize: 14,
                      color: primaryBlack,
                      fontFamily: latoRegular),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
              child: SliderTheme(
                data: SliderThemeData(
                  overlayShape: SliderComponentShape.noThumb,
                  thumbColor: primaryBlue,
                  inactiveTrackColor: primaryGrey,
                  activeTrackColor: primaryBlue,
                  trackHeight: 3.0,
                  rangeThumbShape: const RoundRangeSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                ),
                child: RangeSlider(
                    min: title == km
                        ? provider.minimumKm
                        : title == priceRange
                            ? provider.minimumPrice
                            : provider.minimumYear,
                    max: title == km
                        ? provider.maximumKm
                        : title == priceRange
                            ? provider.maximumPrice
                            : provider.maximumYear,
                    values: title == km
                        ? provider.kmValues
                        : title == priceRange
                            ? provider.priceValues
                            : provider.makeYearValues,
                    onChanged: (newValues) {
                      provider.setRangeValues(
                          rangeTitle: title, rangeValues: newValues);
                    }),
              ),
            )
          ],
        ));
  }
}
