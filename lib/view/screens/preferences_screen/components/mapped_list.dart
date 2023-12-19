import 'package:caroogle/providers/preferences_add_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_sizedbox.dart';

class MappedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Consumer<PreferencesAddDataProvider>(
          builder: (context, controller, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kindlyConfirm,
              textAlign: TextAlign.start,
              style: textStyle(
                  fontSize: 16, color: primaryBlack, fontFamily: latoBold),
            ),
            HeightSizedBox(context, 0.01),
            SizedBox(
              height: displayHeight(context, 0.50),
              child: ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.csvMap.length,
                  itemBuilder: (context, index) {
                    String key = controller.csvMap.keys.elementAt(index);
                    String values = controller.csvMap.values.elementAt(index);
                    return SizedBox(
                        width: displayWidth(context, 1),
                        height: displayHeight(context, 0.055),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: displayWidth(context, 0.30),
                              child: Text(
                                key,
                                textAlign: TextAlign.start,
                                style: textStyle(
                                    fontSize: 16,
                                    color: primaryBlue,
                                    fontFamily: latoBold),
                              ),
                            ),
                            WidthSizedBox(context, 0.01),
                            SizedBox(
                              width: displayWidth(context, 0.14),
                              child: Text(
                                "---->",
                                textAlign: TextAlign.start,
                                style: textStyle(
                                    fontSize: 22,
                                    color: primaryBlue,
                                    fontFamily: latoBold),
                              ),
                            ),
                            WidthSizedBox(context, 0.02),
                            SizedBox(
                              width: displayWidth(context, 0.37),
                              child: Text(
                                values,
                                textAlign: TextAlign.start,
                                style: textStyle(
                                    fontSize: 16,
                                    color: primaryBlue,
                                    fontFamily: latoRegular),
                              ),
                            ),
                          ],
                        ));
                  }),
            ),
          ],
        );
      }),
    );
  }
}
