import 'dart:io';

import 'package:caroogle/providers/david_recommendataion_screen_provider.dart';
import 'package:caroogle/providers/home_screen_provider.dart';
import 'package:caroogle/providers/preferences_provider.dart';
import 'package:caroogle/providers/search_filter_provider.dart';
import 'package:caroogle/providers/tracked_provider.dart';
import 'package:caroogle/providers/trigger_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/widgets/customRangeSlider.dart';
import 'package:caroogle/view/widgets/custom_dropdown.dart';
import 'package:caroogle/view/widgets/custom_button.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/custom_text_field.dart';
import 'package:caroogle/view/widgets/named_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../helper/routes_helper.dart';
import '../../../providers/dropdown_provider.dart';
import '../../../providers/global_search_provider.dart';
import '../../../providers/inventory_provider.dart';
import '../../../utils/dimension.dart';
import '../../../utils/images.dart';
import '../../../utils/style.dart';
import '../../widgets/error_text.dart';
import '../../widgets/shimmer/shimmer_model.dart';
import '../../widgets/shimmer/shimmer_simple_list.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({Key? key}) : super(key: key);

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  @override
  void initState() {
    // to call api when user navigate to the screen
    callingApi();
    super.initState();
  }

  callingApi() {
    Future.delayed(Duration.zero, () {
      // instance of the SearchFilterProvider
      final searchFilterProvider =
          Provider.of<SearchFilterProvider>(context, listen: false);

      // fist we will set isMakeSelected true
      searchFilterProvider.setMakeSelected(true);

      // instance of the DropdownProvider
      final dropdownProvider =
          Provider.of<DropdownProvider>(context, listen: false);

      // To check the dropdown list is empty or not
      // if the drop list is empty then we will call api

      if (dropdownProvider.makeModel.data == null) {
        // dropdown list of car make
        Future.delayed(Duration.zero, () async {
          await dropdownProvider.getMake(
              context, RouterHelper.searchFilterScreen);
        });
      }
      if (dropdownProvider.bodyModel.data == null) {
        // dropdown list of car body
        Future.delayed(Duration.zero, () async {
          await dropdownProvider.getBodyType(
              context, RouterHelper.searchFilterScreen);
        });
      }
      if (dropdownProvider.fuelTypeModel.data == null) {
        // dropdown list of fuel type
        Future.delayed(Duration.zero, () async {
          await dropdownProvider.getFuelType(
              context, RouterHelper.searchFilterScreen);
        });
      }
      if (dropdownProvider.transmissionModel.data == null) {
        // dropdown list of transmission
        Future.delayed(Duration.zero, () async {
          await dropdownProvider.getTransmission(
              context, RouterHelper.searchFilterScreen);
        });
      }
      if (dropdownProvider.colorModel.data == null) {
        // dropdown list of color
        Future.delayed(Duration.zero, () async {
          await dropdownProvider.getColor(
              context, RouterHelper.searchFilterScreen);
        });
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
            title: searchFilter,
            color: primaryWhite,
          ),
          backgroundColor: primaryWhite,
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Consumer2<SearchFilterProvider, DropdownProvider>(
                builder: (context, controller, provider, child) {
              // first check if the drop down list is empty or loading true the we will show shimmer

              return provider.isLoading == true ||
                      controller.isLoading == true ||
                      provider.makeModel.data == null ||
                      provider.bodyModel.data == null ||
                      provider.fuelTypeModel.data == null ||
                      provider.colorModel.data == null ||
                      provider.transmissionModel.data == null
                  ? ShimmerSimpleList(pagination: 0)
                  : GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                          items: provider.makeModel.data!.rows,
                                          textController:
                                              controller.carMakeController,
                                          isPopulate: false),

                                      // when the user click on the item and we will call api and show shimmer
                                      provider.isModelLoading == true
                                          ? const ShimmerModel()
                                          : provider.carModel.data == null ||
                                                  controller.makeId == null
                                              ? InkWell(
                                                  onTap: () {
                                                    // set isMakeSelected false
                                                    controller
                                                        .setMakeSelected(false);
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
                                                                  fontSize: 16,
                                                                  color:
                                                                      primaryBlack,
                                                                  fontFamily:
                                                                      latoBold),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Text(
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
                                                                  AssetImage(Images
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
                                                  isPopulate: false),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    // check for validation , make and model is selected or not and
                                    controller.makeId == null &&
                                            controller.isMakeSelected ==
                                                false &&
                                            controller.modelId == null
                                        ? ValidationMessage(
                                            text: "Please select make first",
                                          )
                                        : controller.isMakeSelected == false &&
                                                controller.modelId == null
                                            ? ValidationMessage(
                                                text: "Please select car Model",
                                              )
                                            : controller.isMakeSelected ==
                                                        false &&
                                                    controller.makeId == null
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
                                          id: 4,
                                          title: fuelType,
                                          hintText: "Enter car fuel type",
                                          items:
                                              provider.fuelTypeModel.data!.rows,
                                          textController:
                                              controller.fuelController,
                                          isPopulate: false),
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
                                HeightSizedBox(context, 0.01),
                                CustomRangeSlider(
                                  provider: controller,
                                  title: km,
                                  rangeStart: controller.kmValues.start.toInt(),
                                  rangeEnd: controller.kmValues.end.toInt(),
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
                                          textController:
                                              controller.transmissionController,
                                          isPopulate: false),
                                      CustomDropdownAutoComplete(
                                          context: context,
                                          provider: controller,
                                          id: 5,
                                          title: bodyType,
                                          hintText: "Enter car body",
                                          items: provider.bodyModel.data!.rows,
                                          textController:
                                              controller.bodyController,
                                          isPopulate: false),
                                    ],
                                  ),
                                ),
                                HeightSizedBox(context, 0.01),
                                CustomRangeSlider(
                                  provider: controller,
                                  title: priceRange,
                                  rangeStart:
                                      controller.priceValues.start.toInt(),
                                  rangeEnd: controller.priceValues.end.toInt(),
                                ),
                                HeightSizedBox(context, 0.01),
                                CustomRangeSlider(
                                  provider: controller,
                                  title: makeYear,
                                  rangeStart:
                                      controller.makeYearValues.start.toInt(),
                                  rangeEnd:
                                      controller.makeYearValues.end.toInt(),
                                ),
                                HeightSizedBox(context, 0.05),
                                CustomButton(
                                    buttonName: btnApply,
                                    onPressed: () async {
                                      // to set the value of the text-field
                                      await controller.setTextField();

                                      // to set the range of the slider
                                      await controller.setMaxMinRange(1);

                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () async {
                                        // calling search filter method
                                        await controller.getSearchFilter(
                                            context,
                                            controller.searchPage!,
                                            RouterHelper.searchFilterScreen,
                                            false);
                                      }).then((value) {
                                        // SearchPage and  Screen id is Same is to identify the user come from which screen

                                        // SearchPage 1 for home screen
                                        if (controller.searchPage == 1) {
                                          // initialized the instance of home provider
                                          final homeProvider =
                                              Provider.of<HomeScreenProvider>(
                                                  context,
                                                  listen: false);

                                          // check the state of the recommended api
                                          // toggle index  0 is recommended

                                          if (homeProvider.recommendationModel
                                                      .error ==
                                                  false &&
                                              homeProvider.toggleIndex == 0) {
                                            // clear the filter data
                                            controller.clearDropdown(0);

                                            // navigate to the screen
                                            Navigator.pushNamed(context,
                                                RouterHelper.homeScreen);
                                          }

                                          // check the state of the all matches api
                                          // toggle index  1 is all matches

                                          if (homeProvider
                                                      .allMatchesModel.error ==
                                                  false &&
                                              homeProvider.toggleIndex == 1) {
                                            // clear the filter data
                                            controller.clearDropdown(0);

                                            // navigate to the screen
                                            Navigator.pushNamed(context,
                                                RouterHelper.homeScreen);
                                          }
                                        }

                                        //searchPage 2 for preferences screen

                                        if (controller.searchPage == 2) {
                                          // initialized the instance of home provider
                                          final prefProvider =
                                              Provider.of<PreferencesProvider>(
                                                  context,
                                                  listen: false);

                                          // check the state of the  API

                                          if (prefProvider
                                                  .allPreferencesModel.error ==
                                              false) {
                                            // clear the filter data
                                            controller.clearDropdown(0);

                                            // navigate to the screen
                                            Navigator.pushNamed(context,
                                                RouterHelper.preferencesScreen);
                                          }
                                        }

                                        // 3 for inventory screen
                                        if (controller.searchPage == 3) {
                                          // initialized the instance of home provider
                                          final inventoryProvider =
                                              Provider.of<InventoryProvider>(
                                                  context,
                                                  listen: false);

                                          // check the state of the  API

                                          if (inventoryProvider
                                                  .inventoryModel.error ==
                                              false) {
                                            // clear the filter data
                                            controller.clearDropdown(0);

                                            // navigate to the screen
                                            Navigator.pushNamed(context,
                                                RouterHelper.inventoryScreen);
                                          }
                                        }

                                        //SearchPage 4 for track screen

                                        if (controller.searchPage == 4) {
                                          // initialized the instance of home provider
                                          final trackedProvider =
                                              Provider.of<TrackedProvider>(
                                                  context,
                                                  listen: false);

                                          // check the state of the  API
                                          if (trackedProvider
                                                  .allTrackedCarModel.error ==
                                              false) {
                                            // clear the filter data
                                            controller.clearDropdown(0);

                                            // navigate to the screen
                                            Navigator.pushNamed(context,
                                                RouterHelper.trackedCarScreen);
                                          }
                                        }

                                        //SearchPage 5 for trigger screen
                                        if (controller.searchPage == 5) {
                                          // initialized the instance of home provider
                                          final triggerProvider =
                                              Provider.of<TriggerProvider>(
                                                  context,
                                                  listen: false);

                                          // check the state of the  API
                                          if (triggerProvider
                                                  .allTriggerModel.error ==
                                              false) {
                                            // clear the filter data
                                            controller.clearDropdown(0);

                                            // navigate to the screen
                                            Navigator.pushNamed(context,
                                                RouterHelper.triggerScreen);
                                          }
                                        }

                                        //SearchPage 6 for trigger count screen
                                        if (controller.searchPage == 6) {
                                          // initialized the instance of home provider
                                          final triggerProvider =
                                              Provider.of<TriggerProvider>(
                                                  context,
                                                  listen: false);

                                          // check the state of the  API
                                          if (triggerProvider
                                                  .carinTriggerModel.error ==
                                              false) {
                                            // clear the filter data
                                            controller.clearDropdown(0);

                                            // navigate to the screen
                                            Navigator.pushNamed(
                                                context,
                                                RouterHelper
                                                    .triggerCountScreen);
                                          }
                                        }

                                        //SearchPage 7 david recommendation screen
                                        if (controller.searchPage == 7) {
                                          // initialized the instance of home provider
                                          final davidProvider = Provider.of<
                                                  DavidRecommendationScreenProvider>(
                                              context,
                                              listen: false);

                                          // check the state of the  API
                                          if (davidProvider
                                                  .davidRecommendationModel
                                                  .error ==
                                              false) {
                                            // clear the filter data
                                            controller.clearDropdown(0);

                                            // navigate to the screen
                                            Navigator.pushNamed(
                                                context,
                                                RouterHelper
                                                    .davidRecommendationScreen);
                                          }
                                        }

                                        //SearchPage 8 global search screen
                                        if (controller.searchPage == 8) {
                                          // initialized the instance of home provider
                                          final globalSearchScreen =
                                              Provider.of<GlobalScreenProvider>(
                                                  context,
                                                  listen: false);

                                          // check the state of the  API
                                          if (globalSearchScreen
                                                  .globalSearchModel.error ==
                                              false) {
                                            // clear the filter data
                                            controller.clearDropdown(0);

                                            // navigate to the screen
                                            Navigator.pushNamed(
                                                context,
                                                RouterHelper
                                                    .globalSearchScreen);
                                          }
                                        }
                                      });
                                    },
                                    buttonGradient: gradientBlue,
                                    buttonTextColor: primaryWhite,
                                    padding: 20),
                                HeightSizedBox(context, 0.02),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
            }),
          ),
        ),
      ),
    );
  }
}
