import 'package:caroogle/helper/date_format.dart';
import 'package:caroogle/providers/car_detail_provider.dart';
import 'package:caroogle/view/widgets/custom_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CarDetailProvider>(builder: (context, controller, child) {
      final data = controller.carDetailModel.data!;
      return Container(
          alignment: Alignment.center,
          height: displayHeight(context, 0.30),
          width: displayWidth(context, 1),
          color: primaryGrey,
          child: Stack(
            children: [
              SizedBox(
                height: displayHeight(context, 0.30),
                width: displayWidth(context, 1),
                child: Image.network(
                  data.image!,
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      Images.errorCar,
                      height: double.infinity,
                      width: double.infinity,
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                right: 20,
                child: Consumer<CarDetailProvider>(
                  builder: (context, controller, child) {
                    return InkWell(
                      onTap: () {
                        // set validation false
                        controller.setHide(false);

                        // to set mark is purchased model response clear
                        controller.markAsPurchasedModel.error = null;

                        // To check the car is already purchased or not "1 for purchased , 0 for not"
                        // if the car is already purchased then we will not show dialog box
                        if (controller.carDetailModel.data!.isPurchase == 0) {
                          customDialog(
                              context: context,
                              adId: data.adId,
                              screenID: 2,
                              title: purchasePrice,
                              index: controller.carIndex);
                        }
                      },
                      child: Container(
                        height: 36,
                        //  width: data.isPurchase == 0 ? 150 : 120,
                        decoration: BoxDecoration(
                          gradient: gradientBlue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Center(
                              child: data.isPurchase == 0
                                  ? Text(
                                      btnMarkAsPurchased,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: textStyle(
                                          fontSize: 14,
                                          color: primaryWhite,
                                          fontFamily: latoRegular),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          btnPurchased,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyle(
                                              fontSize: 14,
                                              color: primaryWhite,
                                              fontFamily: latoRegular),
                                        )
                                      ],
                                    )),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 45,
                  width: displayWidth(context, 1),
                  color: lightGrey,
                  child: Center(
                    child: Text(
                      "$adDate ${dateFormatSlash(data.dateTime!)}",
                      textAlign: TextAlign.center,
                      style: textStyle(
                          fontSize: 14,
                          color: primaryWhite,
                          fontFamily: latoRegular),
                    ),
                  ),
                ),
              )
            ],
          ));
    });
  }
}
