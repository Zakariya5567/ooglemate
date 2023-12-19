import 'package:caroogle/providers/inventory_add_new_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helper/routes_helper.dart';
import '../../../../providers/dropdown_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_sizedbox.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/error_text.dart';
import '../../../widgets/shimmer/shimmer_model.dart';
import '../../../widgets/shimmer/shimmer_simple_list.dart';

class InventoryAddManually extends StatefulWidget {
  const InventoryAddManually({Key? key}) : super(key: key);

  @override
  State<InventoryAddManually> createState() => _InventoryAddManuallyState();
}

class _InventoryAddManuallyState extends State<InventoryAddManually> {
  @override
  void initState() {
    callingApi();
    super.initState();
  }

  callingApi() {
    Future.delayed(Duration.zero, () {
      final provider =
          Provider.of<InventoryAddNewProvider>(context, listen: false);
      final dropdownProvider =
          Provider.of<DropdownProvider>(context, listen: false);
      provider.clearDropdown();

      if (dropdownProvider.makeModel.data == null) {
        Future.delayed(Duration.zero, () async {
          await dropdownProvider.getMake(
              context, RouterHelper.inventoryAddNewScreen);
        });
      }

      // if (dropdownProvider.carModel.data == null) {
      //   Future.delayed(Duration.zero, () async {
      //     await dropdownProvider.getModel(
      //         context, RouterHelper.inventoryAddNewScreen);
      //   });
      // }

      if (dropdownProvider.bodyModel.data == null) {
        Future.delayed(Duration.zero, () async {
          await dropdownProvider.getBodyType(
              context, RouterHelper.inventoryAddNewScreen);
        });
      }

      if (dropdownProvider.fuelTypeModel.data == null) {
        Future.delayed(Duration.zero, () async {
          await dropdownProvider.getFuelType(
              context, RouterHelper.inventoryAddNewScreen);
        });
      }

      if (dropdownProvider.transmissionModel.data == null) {
        Future.delayed(Duration.zero, () async {
          await dropdownProvider.getTransmission(
              context, RouterHelper.inventoryAddNewScreen);
        });
      }

      if (dropdownProvider.colorModel.data == null) {
        Future.delayed(Duration.zero, () async {
          await dropdownProvider.getColor(
              context, RouterHelper.inventoryAddNewScreen);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryAddNewProvider>(
        builder: (context, controller, child) {
      return Consumer<DropdownProvider>(builder: (context, provider, child) {
        return provider.isLoading == true ||
                controller.isLoading == true ||
                provider.makeModel.data == null ||
                // provider.carModel.data == null ||
                provider.bodyModel.data == null ||
                provider.fuelTypeModel.data == null ||
                provider.colorModel.data == null ||
                provider.transmissionModel.data == null
            ? ShimmerSimpleList(pagination: 0)
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomDropdownAutoComplete(
                              provider: controller,
                              context: context,
                              id: 1,
                              title: carMake,
                              hintText: "Enter car make",
                              items: provider.makeModel.data!.rows,
                              textController: controller.carMakeController,
                              isPopulate: false),
                          provider.isModelLoading == true
                              ? const ShimmerModel()
                              : provider.carModel.data == null ||
                                      controller.makeId == null
                                  ? InkWell(
                                      onTap: () {
                                        controller.setMakeSelected(true);
                                      },
                                      child: Container(
                                          height: 70,
                                          width: displayWidth(context, 0.40),
                                          decoration: BoxDecoration(
                                              color: primaryWhite,
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: lightGrey
                                                          .withOpacity(0.2),
                                                      width: 1))),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  carModel,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: textStyle(
                                                      fontSize: 16,
                                                      color: primaryBlack,
                                                      fontFamily: latoBold),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      "Enter car model",
                                                      style: textStyle(
                                                          fontSize: 12,
                                                          color: lightGrey,
                                                          fontFamily:
                                                              latoRegular),
                                                    )),
                                                    const ImageIcon(
                                                      AssetImage(
                                                          Images.iconDropdown),
                                                      size: 15,
                                                      color: primaryBlack,
                                                    )
                                                  ],
                                                ),
                                                const SizedBox()
                                              ])),
                                    )
                                  : CustomDropdownAutoComplete(
                                      context: context,
                                      provider: controller,
                                      id: 2,
                                      title: carModel,
                                      hintText: "Enter car model",
                                      items: provider.carModel.data!.rows!,
                                      textController:
                                          controller.carModelController,
                                      isPopulate: false),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        controller.isHide == true && controller.makeId == null
                            ? ValidationMessage(
                                text: "Please select car Make",
                              )
                            : const SizedBox(),
                        controller.isHide == true &&
                                controller.modelId == null &&
                                controller.isMakeSelected == true &&
                                controller.makeId == null
                            ? ValidationMessage(
                                text: "Please select make first",
                              )
                            : controller.isHide == true &&
                                    controller.modelId == null
                                ? ValidationMessage(
                                    text: "Please select car Model",
                                  )
                                : controller.isMakeSelected == true &&
                                        controller.makeId == null
                                    ? ValidationMessage(
                                        text: "Please select make first",
                                      )
                                    : const SizedBox(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextField(
                            provider: controller,
                            controller: controller.keyWordsController,
                            title: keyWords,
                            hintText: hintKeyWords,
                            isNumber: 0,
                            width: displayWidth(context, 0.40),
                            fieldType: 3,
                          ),
                          CustomDropdownAutoComplete(
                              context: context,
                              provider: controller,
                              id: 6,
                              title: colours,
                              hintText: "Enter car color",
                              items: provider.colorModel.data!.rows,
                              textController: controller.colorController,
                              isPopulate: false),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        controller.isHide == true &&
                                controller.keywordValidation == null
                            ? ValidationMessage(
                                text: "Please enter keyword",
                              )
                            : const SizedBox(),
                        controller.isHide == true && controller.colorId == null
                            ? ValidationMessage(
                                text: "Please select color",
                              )
                            : const SizedBox(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomDropdownAutoComplete(
                              context: context,
                              provider: controller,
                              id: 4,
                              title: fuelType,
                              hintText: "Enter car fuel type",
                              items: provider.fuelTypeModel.data!.rows,
                              textController: controller.fuelController,
                              isPopulate: false),
                          CustomTextField(
                            provider: controller,
                            controller: controller.carBadgeController,
                            title: carBadge,
                            hintText: hintEnterCarBadge,
                            isNumber: 0,
                            width: displayWidth(context, 0.40),
                            fieldType: 4,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        controller.isHide == true && controller.fuelId == null
                            ? ValidationMessage(
                                text: "Please select fuel type",
                              )
                            : const SizedBox(),
                        controller.isHide == true &&
                                controller.badgeValidation == null
                            ? ValidationMessage(
                                text: "Please enter badge",
                              )
                            : const SizedBox(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: CustomTextField(
                        provider: controller,
                        controller: controller.kmController,
                        title: km,
                        hintText: hintEnterKm,
                        isNumber: 1,
                        width: displayWidth(context, 1),
                        fieldType: 6,
                      ),
                    ),
                    controller.isHide == true && controller.kmValidation == null
                        ? ValidationMessage(
                            text: "Please enter Kilometers",
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomDropdownAutoComplete(
                              context: context,
                              provider: controller,
                              id: 3,
                              title: transmission,
                              hintText: "Enter car transmission",
                              items: provider.transmissionModel.data!.rows,
                              textController: controller.transmissionController,
                              isPopulate: false),
                          CustomDropdownAutoComplete(
                              context: context,
                              provider: controller,
                              id: 5,
                              title: bodyType,
                              hintText: "Enter car body",
                              items: provider.bodyModel.data!.rows,
                              textController: controller.bodyController,
                              isPopulate: false),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        controller.isHide == true &&
                                controller.transmissionId == null
                            ? ValidationMessage(
                                text: "Please select transmission",
                              )
                            : const SizedBox(),
                        controller.isHide == true && controller.bodyId == null
                            ? ValidationMessage(
                                text: "Please select body",
                              )
                            : const SizedBox(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: CustomTextField(
                        provider: controller,
                        controller: controller.makeYearController,
                        title: makeYear,
                        hintText: hintEnterPrice,
                        isNumber: 1,
                        width: displayWidth(context, 1),
                        fieldType: 5,
                      ),
                    ),
                    controller.isHide == true &&
                            controller.yearValidation == null
                        ? ValidationMessage(
                            text: "Please enter make year",
                          )
                        : controller.isHide == true &&
                                int.parse(controller.makeYearController.text) >
                                    DateTime.now().year.toInt()
                            ? ValidationMessage(
                                text: "Enter valid year",
                              )
                            : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: CustomTextField(
                        provider: controller,
                        controller: controller.purchasePriceController,
                        title: purchasePrice,
                        hintText: hintEnterPrice,
                        isNumber: 1,
                        width: displayWidth(context, 1),
                        fieldType: 1,
                      ),
                    ),
                    controller.isHide == true &&
                            controller.purchaseValidation == null
                        ? ValidationMessage(
                            text: "Please enter purchase price",
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: CustomTextField(
                        provider: controller,
                        controller: controller.sellPriceController,
                        title: sellingPrice,
                        hintText: hintEnterPrice,
                        isNumber: 1,
                        width: displayWidth(context, 1),
                        fieldType: 2,
                      ),
                    ),
                    controller.isHide == true &&
                            controller.sellValidation == null
                        ? ValidationMessage(
                            text: "Please enter sell price",
                          )
                        : const SizedBox(),
                    HeightSizedBox(context, 0.04),
                    CustomButton(
                        buttonName: btnSubmit,
                        onPressed: () {
                          if (controller.makeId == null ||
                              controller.modelId == null ||
                              controller.transmissionId == null ||
                              controller.fuelId == null ||
                              controller.colorId == null ||
                              controller.bodyId == null ||
                              controller.badgeValidation == null ||
                              controller.purchaseValidation == null ||
                              controller.sellValidation == null ||
                              controller.yearValidation == null ||
                              int.parse(controller.makeYearController.text) >
                                  DateTime.now().year.toInt() ||
                              controller.kmValidation == null ||
                              controller.keywordValidation == null) {
                            controller.setHide(true);
                          } else {
                            controller
                                .addNewInventory(
                                    context, RouterHelper.inventoryAddNewScreen)
                                .then((value) {
                              if (controller.addNewInventoryModel.error ==
                                  false) {
                                Navigator.of(context).pushReplacementNamed(
                                    RouterHelper.inventoryScreen);
                                controller.clearDropdown();
                                controller.setHide(false);
                              }
                            });
                          }
                        },
                        buttonGradient: gradientBlue,
                        buttonTextColor: primaryWhite,
                        padding: 20)
                  ],
                ));
      });
    });
  }
}
