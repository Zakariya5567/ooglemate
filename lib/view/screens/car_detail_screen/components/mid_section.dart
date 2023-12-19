import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/car_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../../widgets/custom_sizedbox.dart';

class MidSection extends StatelessWidget {
  const MidSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CarDetailProvider>(builder: (context, controller, child) {
      final data = controller.carDetailModel.data!;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Container(
              height: 50,
              width: displayWidth(context, 1),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: primaryBlue)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      btnRatePrediction,
                      style: textStyle(
                          fontSize: 15,
                          color: primaryBlue,
                          fontFamily: latoRegular),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        CustomIconButton(
                            icon: Images.iconSmile,
                            onTap: () {
                              // calling rate predict api
                              controller.ratePredict(
                                  context,
                                  controller.dataId!,
                                  1,
                                  RouterHelper.carDetailScreen);
                            },
                            height: displayWidth(context, 0.065),
                            width: displayWidth(context, 0.065),
                            color: primaryBlue),
                        WidthSizedBox(context, 0.03),
                        CustomIconButton(
                            icon: Images.iconSad,
                            onTap: () {
                              // calling rate predict api
                              controller.ratePredict(
                                  context,
                                  controller.dataId!,
                                  0,
                                  RouterHelper.carDetailScreen);
                            },
                            height: displayWidth(context, 0.065),
                            width: displayWidth(context, 0.065),
                            color: primaryBlue),
                        WidthSizedBox(context, 0.01),
                      ],
                    ),
                  )
                ],
              ),
            ),
            HeightSizedBox(context, 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: displayWidth(context, 0.65),
                  child: Text(
                    "${data.make!} ${data.model!}",
                    overflow: TextOverflow.ellipsis,
                    style: textStyle(
                        fontSize: 18, color: primaryBlue, fontFamily: latoBold),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // calling track api
                    // To set car track or un tracked
                    controller
                        .setTrackCar(context, controller.adId!,
                            RouterHelper.carDetailScreen)
                        .then((value) {
                      data.isTracked == 0
                          ? data.isTracked = 1
                          : data.isTracked = 0;
                    });
                  },
                  child: Container(
                      height: 32,
                      width: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: primaryBlue),
                        color: data.isTracked == 0 ? primaryWhite : primaryBlue,
                      ),
                      child: data.isTracked == 0
                          ? Center(
                              child: Text(
                                btnTrack,
                                style: textStyle(
                                    fontSize: 15,
                                    color: primaryBlue,
                                    fontFamily: latoRegular),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  btnTrack,
                                  style: textStyle(
                                      fontSize: 15,
                                      color: primaryWhite,
                                      fontFamily: latoRegular),
                                ),
                                const Icon(
                                  Icons.done,
                                  color: primaryWhite,
                                  size: 18,
                                )
                              ],
                            )),
                ),
              ],
            ),
            HeightSizedBox(context, 0.02),
          ],
        ),
      );
    });
  }
}
