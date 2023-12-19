import 'dart:io';
import 'package:caroogle/providers/dropdown_provider.dart';
import 'package:caroogle/providers/set_trigger_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/screens/trigger_screen/components/check_boxes.dart';
import 'package:caroogle/view/screens/trigger_screen/components/info_dialog.dart';
import 'package:caroogle/view/screens/trigger_screen/components/range_slider_section.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/custom_text_field.dart';
import 'package:caroogle/view/widgets/named_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../helper/routes_helper.dart';
import '../../../utils/dimension.dart';
import '../../../utils/images.dart';
import '../../../utils/style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/error_text.dart';
import '../../widgets/shimmer/shimmer_model.dart';
import '../../widgets/shimmer/shimmer_simple_list.dart';

class SetTriggerScreen extends StatefulWidget {
  const SetTriggerScreen({Key? key}) : super(key: key);

  @override
  State<SetTriggerScreen> createState() => _SetTriggerScreenState();
}

class _SetTriggerScreenState extends State<SetTriggerScreen> {
  @override
  void initState() {
    callingApi();
    super.initState();
  }

  callingApi() {
    Future.delayed(Duration.zero, () {
      final provider = Provider.of<SetTriggerProvider>(context, listen: false);
      final dropdownProvider =
          Provider.of<DropdownProvider>(context, listen: false);
      provider.clearDropdown();

      if (dropdownProvider.makeModel.data == null ||
          dropdownProvider.bodyModel.data == null ||
          dropdownProvider.fuelTypeModel.data == null ||
          dropdownProvider.transmissionModel.data == null ||
          dropdownProvider.bodyModel.data == null) {
        if (dropdownProvider.makeModel.data == null) {
          Future.delayed(Duration.zero, () async {
            await dropdownProvider.getMake(
                context, RouterHelper.inventoryAddNewScreen);
            if (provider.perPopulate == 1) {
              provider.setTriggerProPopulateData(context);
            }
          });
        }
        if (dropdownProvider.bodyModel.data == null) {
          Future.delayed(Duration.zero, () async {
            await dropdownProvider.getBodyType(
                context, RouterHelper.inventoryAddNewScreen);
            if (provider.perPopulate == 1) {
              provider.setTriggerProPopulateData(context);
            }
          });
        }
        if (dropdownProvider.fuelTypeModel.data == null) {
          Future.delayed(Duration.zero, () async {
            await dropdownProvider.getFuelType(
                context, RouterHelper.inventoryAddNewScreen);
            if (provider.perPopulate == 1) {
              provider.setTriggerProPopulateData(context);
            }
          });
        }
        if (dropdownProvider.transmissionModel.data == null) {
          Future.delayed(Duration.zero, () async {
            await dropdownProvider.getTransmission(
                context, RouterHelper.inventoryAddNewScreen);
            if (provider.perPopulate == 1) {
              provider.setTriggerProPopulateData(context);
            }
          });
        }
      } else {
        if (provider.perPopulate == 1) {
          Future.delayed(Duration.zero, () async {
            provider.setTriggerProPopulateData(context);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: SafeArea(
        bottom: Platform.isAndroid ? true : false,
        top: Platform.isAndroid ? true : false,
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: namedAppBar(
            context: context,
            title: setTrigger,
            color: primaryWhite,
          ),
          backgroundColor: primaryWhite,
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Consumer<SetTriggerProvider>(
                builder: (context, controller, child) {
              return Consumer<DropdownProvider>(
                  builder: (context, provider, child) {
                return provider.isLoading == true ||
                        controller.isLoading == true ||
                        provider.makeModel.data == null ||
                        //   provider.carModel.data == null ||
                        provider.bodyModel.data == null ||
                        provider.fuelTypeModel.data == null ||
                        provider.transmissionModel.data == null
                    ? ShimmerSimpleList(pagination: 0)
                    : GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeightSizedBox(context, 0.02),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        priceTag,
                                        textAlign: TextAlign.center,
                                        style: textStyle(
                                            fontSize: 16,
                                            color: primaryBlack,
                                            fontFamily: latoBold),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          InfoDialog(context);
                                        },
                                        child: Image.asset(
                                          Images.iconInfo,
                                          scale: 22,
                                          color: primaryBlack,
                                        ),
                                      ),
                                    ],
                                  ),

                                  //Check list

                                  HeightSizedBox(context, 0.02),
                                  CheckBoxes(),

                                  controller.isHide == true &&
                                          controller.checkList.isEmpty
                                      ? ValidationMessage(
                                          text: "Please select price Tag",
                                        )
                                      : const SizedBox(),

                                  // Car make and Car model

                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomDropdownAutoComplete(
                                            provider: controller,
                                            context: context,
                                            id: 1,
                                            title: carMake,
                                            hintText: "Enter car make",
                                            items:
                                                provider.makeModel.data!.rows,
                                            textController:
                                                controller.carMakeController,
                                            isPopulate:
                                                controller.perPopulate == 1
                                                    ? true
                                                    : false),
                                        provider.isModelLoading == true
                                            ? const ShimmerModel()
                                            : provider.carModel.data == null ||
                                                    controller
                                                        .makeIdList.isEmpty
                                                ? InkWell(
                                                    onTap: () {
                                                      controller
                                                          .setMakeSelected(
                                                              true);
                                                    },
                                                    child: Container(
                                                        height: 70,
                                                        width: displayWidth(
                                                            context, 0.40),
                                                        decoration: BoxDecoration(
                                                            color: primaryWhite,
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    color: lightGrey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    width: 1))),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                carModel,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: textStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color:
                                                                        primaryBlack,
                                                                    fontFamily:
                                                                        latoBold),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                          Text(
                                                                    "Enter car model",
                                                                    style: textStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            lightGrey,
                                                                        fontFamily:
                                                                            latoRegular),
                                                                  )),
                                                                  const ImageIcon(
                                                                    AssetImage(
                                                                        Images
                                                                            .iconDropdown),
                                                                    size: 15,
                                                                    color:
                                                                        primaryBlack,
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
                                                    items: provider
                                                        .carModel.data!.rows!,
                                                    textController: controller
                                                        .carModelController,
                                                    isPopulate: controller
                                                                .perPopulate ==
                                                            1
                                                        ? true
                                                        : false),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      controller.isHide == true &&
                                              controller.makeIdList.isEmpty
                                          ? ValidationMessage(
                                              text: "Please select car Make",
                                            )
                                          : const SizedBox(),
                                      controller.isHide == true &&
                                              controller.modelIdList.isEmpty &&
                                              controller.isMakeSelected ==
                                                  true &&
                                              controller.makeIdList.isEmpty
                                          ? ValidationMessage(
                                              text: "Please select make first",
                                            )
                                          : controller.isHide == true &&
                                                  controller.modelIdList.isEmpty
                                              ? ValidationMessage(
                                                  text:
                                                      "Please select car Model",
                                                )
                                              : controller.isMakeSelected ==
                                                          true &&
                                                      controller
                                                          .makeIdList.isEmpty
                                                  ? ValidationMessage(
                                                      text:
                                                          "Please select make first",
                                                    )
                                                  : const SizedBox(),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 25.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomDropdownAutoComplete(
                                            context: context,
                                            provider: controller,
                                            id: 3,
                                            title: transmission,
                                            hintText: "Enter car transmission",
                                            items: provider
                                                .transmissionModel.data!.rows,
                                            textController: controller
                                                .transmissionController,
                                            isPopulate:
                                                controller.perPopulate == 1
                                                    ? true
                                                    : false),
                                        CustomDropdownAutoComplete(
                                            context: context,
                                            provider: controller,
                                            id: 4,
                                            title: fuelType,
                                            hintText: "Enter fuel type",
                                            items: provider
                                                .fuelTypeModel.data!.rows,
                                            textController:
                                                controller.fuelController,
                                            isPopulate:
                                                controller.perPopulate == 1
                                                    ? true
                                                    : false),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomDropdownAutoComplete(
                                            context: context,
                                            provider: controller,
                                            id: 5,
                                            title: bodyType,
                                            hintText: "Enter body type",
                                            items:
                                                provider.bodyModel.data!.rows!,
                                            textController:
                                                controller.bodyController,
                                            isPopulate:
                                                controller.perPopulate == 1
                                                    ? true
                                                    : false),
                                        CustomTextField(
                                          provider: controller,
                                          controller:
                                              controller.carBadgeController,
                                          title: carBadge,
                                          hintText: hintEnterCarBadge,
                                          isNumber: 0,
                                          width: displayWidth(context, 0.40),
                                          fieldType: 4,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                    child: RangeSliderSection(),
                                  ),

                                  HeightSizedBox(context, 0.04),
                                  CustomButton(
                                      buttonName: btnAddTrigger,
                                      onPressed: () {
                                        if (controller.checkList.isEmpty ||
                                            controller.makeIdList.isEmpty ||
                                            controller.modelIdList.isEmpty) {
                                          controller.setHide(true);
                                        } else {
                                          controller.setCarBadge();
                                          controller.setPriceTag();
                                          controller.getMaxMinRange();
                                          controller
                                              .addTrigger(context,
                                                  RouterHelper.setTriggerScreen)
                                              .then((value) {
                                            if (controller
                                                    .newTriggerModel.error ==
                                                false) {
                                              Navigator.of(context).pushNamed(
                                                  RouterHelper.triggerScreen);
                                              controller.clearDropdown();
                                              controller.clearCheckBox();
                                              controller.setHide(false);
                                            }
                                          });
                                        }
                                      },
                                      buttonGradient: gradientBlue,
                                      buttonTextColor: primaryWhite,
                                      padding: 20),
                                  HeightSizedBox(context, 0.09)
                                ],
                              ),
                            )
                          ],
                        ),
                      );
              });
            }),
          ),
        ),
      ),
    );
  }
}
