import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/car_detail_provider.dart';
import 'package:caroogle/providers/david_recommendataion_screen_provider.dart';
import 'package:caroogle/providers/global_search_provider.dart';
import 'package:caroogle/providers/home_screen_provider.dart';
import 'package:caroogle/providers/inventory_car_detail_provider.dart';
import 'package:caroogle/utils/images.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/widgets/custom_button.dart';
import 'package:caroogle/view/widgets/custom_icon_button.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/inventory_provider.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import '../../utils/style.dart';
import 'custom_snackbar.dart';

Future customDialog({
  required BuildContext context,
  required int? adId,
  required int screenID,
  required String title,
  required int? index,
}) {
  // screenID 1 for home screen
  // screenID 2 for car detail screen
  // screenId 3 for inventory screen
  // screenId 4 for david screen
  // screenId 5 for global search

  // selectedScreen 1 HOME SCREEN
  // selectedScreen 2 DAVID SCREEN
  // selectedScreen 3 INVENTORY SIMILAR SCREEN
  // selectedScreen 4 TRACKED SCREEN
  // selectedScreen 5 TRIGGER COUNT SCREEN
  // selectedScreen 6 NOTIFICATION SCREEN
  // selectedScreen 7 GLOBAL SEARCH SCREEN

  final detailProvider = Provider.of<CarDetailProvider>(context, listen: false);

  final homeProvider = Provider.of<HomeScreenProvider>(context, listen: false);

  final davidProvider =
      Provider.of<DavidRecommendationScreenProvider>(context, listen: false);
  final globalSearchProvider =
      Provider.of<GlobalScreenProvider>(context, listen: false);

  final sellProvider =
      Provider.of<InventoryCarDetailProvider>(context, listen: false);

  TextEditingController priceController = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            insetPadding: const EdgeInsets.all(20),
            contentPadding: const EdgeInsets.all(15),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Container(
              color: primaryWhite,
              width: displayWidth(context, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomIconButton(
                        icon: Images.iconCross,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        height: displayWidth(context, 0.055),
                        width: displayWidth(context, 0.055),
                        color: primaryGrey),
                  ),
                  Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: textStyle(
                          fontSize: 16,
                          color: primaryBlack,
                          fontFamily: rubikRegular),
                    ),
                  ),
                  HeightSizedBox(context, 0.03),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomTextField(
                        controller: priceController,
                        title: title,
                        hintText: hintEnterPrice,
                        isNumber: 1,
                        width: displayWidth(context, 1),
                        provider: screenID == 1
                            ? homeProvider
                            : screenID == 2
                                ? detailProvider
                                : screenID == 3
                                    ? sellProvider
                                    : screenID == 4
                                        ? davidProvider
                                        : globalSearchProvider,
                        fieldType: 1,
                      )),
                  Consumer<CarDetailProvider>(
                      builder: (context, hideController, child) {
                    return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: hideController.isHide == true
                            ? Text(
                                "Please enter price",
                                style: textStyle(
                                    fontSize: 12,
                                    color: primaryRed,
                                    fontFamily: latoRegular),
                              )
                            : const SizedBox());
                  }),
                  HeightSizedBox(context, 0.05),
                  CustomButton(
                      buttonName: btnDone,
                      onPressed: () {
                        debugPrint("screen id $screenID");
                        if (priceController.text.trim().isNotEmpty) {
                          if (title == purchasePrice) {
                            Navigator.of(context).pop();
                            if (screenID == 1) {
                              homeProvider
                                  .markAsPurchased(
                                      context,
                                      adId!,
                                      priceController.text,
                                      RouterHelper.homeScreen)
                                  .then((value) {
                                if (homeProvider.markAsPurchasedModel.error ==
                                    false) {
                                  homeProvider.setPurchase(index!);
                                }
                              });
                            } else if (screenID == 2) {
                              detailProvider
                                  .markAsPurchased(
                                      context,
                                      adId!,
                                      priceController.text,
                                      RouterHelper.carDetailScreen)
                                  .then((value) {
                                detailProvider.setPurchase();
                                if (detailProvider.markAsPurchasedModel.error ==
                                    false) {
                                  if (detailProvider.selectedScreen == 1) {
                                    homeProvider.setPurchase(index!);
                                  }
                                  if (detailProvider.selectedScreen == 2) {
                                    davidProvider.setPurchase(index!);
                                  }
                                  if (detailProvider.selectedScreen == 7) {
                                    globalSearchProvider.setPurchase(index!);
                                  }
                                }
                              });
                            } else if (screenID == 4) {
                              davidProvider
                                  .markAsPurchased(
                                      context,
                                      adId!,
                                      priceController.text,
                                      RouterHelper.davidRecommendationScreen)
                                  .then((value) {
                                if (davidProvider.markAsPurchasedModel.error ==
                                    false) {
                                  davidProvider.setPurchase(index!);
                                }
                              });
                            } else if (screenID == 5) {
                              globalSearchProvider
                                  .markAsPurchased(
                                      context,
                                      adId!,
                                      priceController.text,
                                      RouterHelper.davidRecommendationScreen)
                                  .then((value) {
                                if (globalSearchProvider
                                        .markAsPurchasedModel.error ==
                                    false) {
                                  globalSearchProvider.setPurchase(index!);
                                }
                              });
                            }
                          } else if (title == sellingPrice) {
                            Navigator.of(context).pop();
                            if (screenID == 3) {
                              sellProvider
                                  .markAsSold(
                                      context,
                                      sellProvider.inventoryId!,
                                      priceController.text,
                                      RouterHelper.inventoryCarDetailScreen)
                                  .then((value) {
                                if (sellProvider.markAsSoldModel.error ==
                                    false) {
                                  sellProvider.setSold();
                                }
                              });
                            }
                          }
                        } else {
                          detailProvider.setHide(true);
                        }
                      },
                      buttonGradient: gradientBlue,
                      buttonTextColor: primaryWhite,
                      padding: 5),
                  HeightSizedBox(context, 0.02),
                  HeightSizedBox(context, 0.02),
                ],
              ),
            ));
      });
}
