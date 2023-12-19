import 'dart:io';
import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/screens/preferences_screen/components/mapped_list.dart';
import 'package:caroogle/view/screens/preferences_screen/components/mapping_radio_list.dart';
import 'package:caroogle/view/widgets/bottom_navigation.dart';
import 'package:caroogle/view/widgets/custom_button.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/bottom_navigation_provider.dart';
import '../../../providers/preferences_add_data_provider.dart';
import '../../../utils/style.dart';
import '../../widgets/pictured_app_bar.dart';

class PreferencesCSVMappingScreen extends StatefulWidget {
  const PreferencesCSVMappingScreen({Key? key}) : super(key: key);

  @override
  State<PreferencesCSVMappingScreen> createState() =>
      _PreferencesCSVMappingScreenState();
}

class _PreferencesCSVMappingScreenState
    extends State<PreferencesCSVMappingScreen> {
  @override
  void initState() {
    super.initState();
    callingApi();
  }

  callingApi() {
    Future.delayed(Duration.zero, () {
      final provider =
          Provider.of<PreferencesAddDataProvider>(context, listen: false);
      provider.refreshMapIndex();
      provider.csvMap.clear();
      provider.csvMapData.clear();

      final navigationProvider =
          Provider.of<BottomNavigationProvider>(context, listen: false);
      navigationProvider.setNavigationIndex(context, 1);
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
            resizeToAvoidBottomInset: false,
            backgroundColor: primaryWhite,
            appBar: picturedAppBar(
                context: context, title: preferences, page: 2, isSearch: 0),
            body: Consumer<PreferencesAddDataProvider>(
                builder: (context, controller, child) {
              return Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeightSizedBox(context, 0.03),
                            Text(
                              csvMapping,
                              textAlign: TextAlign.start,
                              style: textStyle(
                                  fontSize: 26,
                                  color: primaryBlack,
                                  fontFamily: latoBold),
                            ),
                            HeightSizedBox(context, 0.02),
                            controller.mapIndex != controller.mapTitle.length
                                ? Text(
                                    csvSelectTheRelevantColumn,
                                    textAlign: TextAlign.start,
                                    style: textStyle(
                                        fontSize: 16,
                                        color: primaryBlack,
                                        fontFamily: latoBold),
                                  )
                                : const SizedBox(),
                            HeightSizedBox(context, 0.01),
                            controller.mapIndex != controller.mapTitle.length
                                ? Text(
                                    csvWhichOfTheColumn,
                                    textAlign: TextAlign.start,
                                    style: textStyle(
                                        fontSize: 16,
                                        color: primaryGrey,
                                        fontFamily: latoRegular),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      HeightSizedBox(context, 0.02),
                      controller.mapIndex < controller.mapTitle.length
                          ? MappingRadioList(
                              radioList: controller.uploadCsvModel.data!)
                          : MappedList(),
                      HeightSizedBox(context, 0.02),
                    ],
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Consumer<PreferencesAddDataProvider>(
                          builder: (context, controller, child) {
                        return Container(
                          color: primaryWhite,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: CustomButton(
                                buttonName: controller.mapIndex <
                                        controller.mapTitle.length
                                    ? btnNext
                                    : btnConfirmAndSave,
                                onPressed: () {
                                  // if (controller.mapTitle.length ==
                                  //     controller.uploadCsvModel.data!.length) {
                                  if (controller.mapIndex <
                                      controller.mapTitle.length) {
                                    if (controller.mapIndex ==
                                        controller.csvMap.length - 1) {
                                      controller.setMapIndex();
                                      controller.value = "value";
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(customSnackBar(
                                              context,
                                              "Select value then tap on next",
                                              1));
                                    }
                                  }
                                  // else if (controller
                                  //         .uploadCsvModel.data!.length >
                                  //     controller.mapTitle.length) {
                                  //   final provider = Provider.of<
                                  //           PreferencesAddDataProvider>(
                                  //       context,
                                  //       listen: false);
                                  //   provider.refreshMapIndex();
                                  //   provider.csvMap.clear();
                                  //   provider.csvMapData.clear();
                                  //   ScaffoldMessenger.of(context)
                                  //       .showSnackBar(customSnackBar(
                                  //           context,
                                  //           "Please upload valid csv file",
                                  //           1));
                                  // }
                                  else if (controller
                                      .uploadCsvModel.data!.isEmpty) {
                                    final provider =
                                        Provider.of<PreferencesAddDataProvider>(
                                            context,
                                            listen: false);
                                    provider.refreshMapIndex();
                                    provider.csvMap.clear();
                                    provider.csvMapData.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        customSnackBar(context,
                                            "Please upload valid csv file", 1));
                                  } else {
                                    controller
                                        .csvMapping(context,
                                            RouterHelper.csvMappingScreen)
                                        .then((value) {
                                      if (controller.csvMappingModel.error ==
                                          false) {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                RouterHelper.preferencesScreen);
                                        controller.refreshMapIndex();
                                        controller.csvMap.clear();
                                        controller.csvMapData.clear();
                                      } else {
                                        final provider = Provider.of<
                                                PreferencesAddDataProvider>(
                                            context,
                                            listen: false);
                                        provider.refreshMapIndex();
                                        provider.csvMap.clear();
                                        provider.csvMapData.clear();
                                      }
                                    });
                                  }
                                  // } else {
                                  //   final provider =
                                  //       Provider.of<PreferencesAddDataProvider>(
                                  //           context,
                                  //           listen: false);
                                  //   provider.refreshMapIndex();
                                  //   provider.csvMap.clear();
                                  //   provider.csvMapData.clear();
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //       customSnackBar(context,
                                  //           "Please upload valid csv file", 1));
                                  // }
                                },
                                buttonGradient: gradientBlue,
                                buttonTextColor: primaryWhite,
                                padding: 35),
                          ),
                        );
                      }),
                    ),
                  )
                ],
              );
            }),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerFloat,
            // floatingActionButton: Padding(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 20,
            //   ),
            //   child: Consumer<PreferencesAddDataProvider>(
            //       builder: (context, controller, child) {
            //     return CustomButton(
            //         buttonName: controller.mapIndex < controller.mapTitle.length
            //             ? btnNext
            //             : btnConfirmAndSave,
            //         onPressed: () {
            //           if (controller.mapIndex < controller.mapTitle.length) {
            //             controller.setMapIndex();
            //             controller.value = "value";
            //           } else {
            //             controller
            //                 .csvMapping(context, RouterHelper.csvMappingScreen)
            //                 .then((value) {
            //               if (controller.csvMappingModel.error == false) {
            //                 Navigator.of(context).pushReplacementNamed(
            //                     RouterHelper.preferencesScreen);
            //                 controller.refreshMapIndex();
            //                 controller.csvMap.clear();
            //                 controller.csvMapData.clear();
            //               } else {
            //                 final provider =
            //                     Provider.of<PreferencesAddDataProvider>(context,
            //                         listen: false);
            //                 provider.refreshMapIndex();
            //                 provider.csvMap.clear();
            //                 provider.csvMapData.clear();
            //               }
            //             });
            //           }
            //         },
            //         buttonGradient: gradientBlue,
            //         buttonTextColor: primaryWhite,
            //         padding: 35);
            //   }),
            // ),
            bottomNavigationBar: const BottomNavigation()),
      ),
    );
  }
}
