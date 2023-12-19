import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/dropdown_provider.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_simple_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/preferences_add_data_provider.dart';
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

class AddManually extends StatefulWidget {
  AddManually({Key? key}) : super(key: key);

  @override
  State<AddManually> createState() => _AddManuallyState();
}

class _AddManuallyState extends State<AddManually> {
  @override
  void initState() {
    super.initState();
    callingApi();
  }

  callingApi() {
    Future.delayed(Duration.zero, () {
      final provider =
          Provider.of<PreferencesAddDataProvider>(context, listen: false);
      final dropdownProvider =
          Provider.of<DropdownProvider>(context, listen: false);
      provider.clearDropdown();

      if (dropdownProvider.makeModel.data == null) {
        Future.delayed(Duration.zero, () async {
          await dropdownProvider.getMake(
              context, RouterHelper.inventoryAddNewScreen);
        });
      }

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesAddDataProvider>(
        builder: (context, controller, child) {
      return Consumer<DropdownProvider>(builder: (context, provider, child) {
        return provider.isLoading == true ||
                controller.isLoading == true ||
                provider.makeModel.data == null ||
                // provider.carModel.data == null ||
                provider.bodyModel.data == null ||
                provider.fuelTypeModel.data == null ||
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
                              context: context,
                              provider: controller,
                              id: 1,
                              title: carMake,
                              hintText: "Enter car make",
                              items: provider.makeModel.data!.rows,
                              textController: controller.carMakeController,
                              isPopulate: false),
                          provider.isModelLoading == true
                              ? const ShimmerModel()
                              : provider.carModel.data == null ||
                                      controller.makeIdList.isEmpty
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
                        controller.isHide == true &&
                                controller.makeIdList.isEmpty
                            ? ValidationMessage(
                                text: "Please select car Make",
                              )
                            : const SizedBox(),
                        controller.isHide == true &&
                                controller.modelIdList.isEmpty &&
                                controller.isMakeSelected == true &&
                                controller.makeIdList.isEmpty
                            ? ValidationMessage(
                                text: "Please select make first",
                              )
                            : controller.isHide == true &&
                                    controller.modelIdList.isEmpty
                                ? ValidationMessage(
                                    text: "Please select car Model",
                                  )
                                : controller.isMakeSelected == true &&
                                        controller.makeIdList.isEmpty
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
                            controller: controller.carBadgeController,
                            title: carBadge,
                            hintText: hintEnterCarBadge,
                            isNumber: 0,
                            width: displayWidth(context, 0.40),
                            fieldType: 4,
                          ),
                          CustomTextField(
                            provider: controller,
                            controller: controller.makeYearController,
                            title: makeYear,
                            hintText: hintMakeYear,
                            isNumber: 1,
                            width: displayWidth(context, 0.40),
                            fieldType: 5,
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        controller.isHide == true &&
                                controller.yearValidation == null
                            ? ValidationMessage(
                                text: "Please enter car year",
                              )
                            : controller.isHide == true &&
                                    int.parse(controller
                                            .makeYearController.text) >
                                        DateTime.now().year.toInt()
                                ? ValidationMessage(
                                    text: "Enter valid year",
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
                              id: 3,
                              title: transmission,
                              hintText: "Enter car transmission",
                              items: provider.transmissionModel.data!.rows,
                              textController: controller.transmissionController,
                              isPopulate: false),
                          CustomDropdownAutoComplete(
                              context: context,
                              provider: controller,
                              id: 4,
                              title: fuelType,
                              hintText: "Enter fuel type",
                              items: provider.fuelTypeModel.data!.rows,
                              textController: controller.fuelController,
                              isPopulate: false),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomDropdownAutoComplete(
                              context: context,
                              provider: controller,
                              id: 5,
                              title: bodyType,
                              hintText: "Enter body type",
                              items: provider.bodyModel.data!.rows!,
                              textController: controller.bodyController,
                              isPopulate: false),
                          CustomTextField(
                            provider: controller,
                            controller: controller.purchasePriceController,
                            title: prefPurchase,
                            hintText: hintEnterPrice,
                            isNumber: 1,
                            width: displayWidth(context, 0.40),
                            fieldType: 1,
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: CustomTextField(
                          provider: controller,
                          controller: controller.sellPriceController,
                          title: prefSell,
                          hintText: hintEnterPrice,
                          isNumber: 1,
                          width: displayWidth(context, 1),
                          fieldType: 2,
                        )),
                    HeightSizedBox(context, 0.03),
                    CustomButton(
                        buttonName: btnSubmit,
                        onPressed: () {
                          if (controller.makeIdList.isEmpty ||
                              controller.modelIdList.isEmpty ||
                              int.parse(controller.makeYearController.text) >
                                  DateTime.now().year.toInt() ||
                              controller.yearValidation == null) {
                            controller.setHide(true);
                          } else {
                            controller.setCarBadge();
                            controller
                                .addNewPreferences(context,
                                    RouterHelper.preferencesAddDataScreen)
                                .then((value) {
                              if (controller.addNewPreferencesModel.error ==
                                  false) {
                                Navigator.of(context).pushReplacementNamed(
                                    RouterHelper.preferencesScreen);
                                controller.clearDropdown();
                                controller.setHide(false);
                              }
                            });
                          }
                        },
                        buttonGradient: gradientBlue,
                        buttonTextColor: primaryWhite,
                        padding: 20),
                  ],
                ),
              );
      });
      //
    });
  }
}
