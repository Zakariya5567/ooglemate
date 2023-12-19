import 'dart:io';

import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/preferences_provider.dart';
import 'package:caroogle/providers/profile_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/images.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/widgets/bottom_navigation.dart';
import 'package:caroogle/view/widgets/circular_progress.dart';
import 'package:caroogle/view/widgets/custom_floating_action_button.dart';
import 'package:caroogle/view/widgets/custom_icon_button.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../helper/percentage_finder.dart';
import '../../../providers/bottom_navigation_provider.dart';
import '../../../providers/preferences_add_data_provider.dart';
import '../../../utils/dimension.dart';
import '../../../utils/style.dart';
import '../../widgets/no_data_found.dart';
import '../../widgets/pictured_app_bar.dart';
import '../../widgets/round_add_button.dart';
import '../../widgets/shimmer/shimmer_simple_list.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callingListener();
  }

  callingListener() {
    Future.delayed(Duration.zero, () {
      final provider = Provider.of<PreferencesProvider>(context, listen: false);
      provider.setLoading(true);
      callingApi(0);
      final navigationProvider =
          Provider.of<BottomNavigationProvider>(context, listen: false);

      navigationProvider.setNavigationIndex(context, 1);

      scrollController.addListener(() {
        if (scrollController.position.maxScrollExtent ==
                scrollController.offset &&
            provider.isLoading == false) {
          callingApi(1);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  callingApi(int isPagination) {
    debugPrint("isPagination : $isPagination");
    // if value = 0 its mean first time we are getting data
    // if value = 1 its mean we are doing pagination

    Future.delayed(Duration.zero).then((value) {
      final provider = Provider.of<PreferencesProvider>(context, listen: false);
      provider.setIsSearching(false);
      if (isPagination == 0 && provider.isFilter == false) {
        provider.clearFilter();
        provider.clearOffset();
        provider.getAllPreferences(context, 0, RouterHelper.preferencesScreen);
      } else if (isPagination == 1 && provider.offset < provider.totalPages!) {
        provider.incrementOffset();
        provider.getAllPreferences(context, 1, RouterHelper.preferencesScreen);
      }
    });
  }

  Future<void> onRefresh() async {
    // Your refresh logic goes here
    final provider = Provider.of<PreferencesProvider>(context, listen: false);
    await Future.delayed(Duration.zero, () {
      provider.setIsSearching(false);
      provider.clearFilter();
      provider.clearOffset();
      provider.getAllPreferences(context, 0, RouterHelper.preferencesScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: SafeArea(
        bottom: Platform.isAndroid ? true : false,
        top: Platform.isAndroid ? true : false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: primaryWhite,
            appBar: picturedAppBar(
                context: context, title: preferences, page: 2, isSearch: 1),
            body: Consumer<PreferencesProvider>(
                builder: (context, controller, child) {
              return controller.isLoading == true ||
                      profileProvider.isLoading == true
                  ? ShimmerSimpleList(pagination: 0)
                  : RefreshIndicator(
                      onRefresh: onRefresh,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Stack(
                            children: [
                              controller.allPreferencesModel.data!.rows!.isEmpty
                                  ? const NoDataFound()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushNamed(RouterHelper
                                                            .notificationScreen);
                                                  },
                                                  child: Image.asset(
                                                      Images.iconNotification,
                                                      height: displayWidth(
                                                          context, 0.055),
                                                      width: displayWidth(
                                                          context, 0.055),
                                                      color: primaryGrey),
                                                ),
                                                WidthSizedBox(context, 0.01),
                                                Text(
                                                  allNotification,
                                                  textAlign: TextAlign.center,
                                                  style: textStyle(
                                                      fontSize: 16,
                                                      color: primaryGrey,
                                                      fontFamily: rubikRegular),
                                                ),
                                                WidthSizedBox(context, 0.02),
                                                Consumer<ProfileProvider>(
                                                    builder: (context,
                                                        profileController,
                                                        child) {
                                                  return FlutterSwitch(
                                                      height: 20,
                                                      width: 38,
                                                      activeColor: primaryBlue,
                                                      inactiveColor: primaryGrey
                                                          .withOpacity(0.5),
                                                      toggleColor: primaryWhite,
                                                      toggleSize: 15,
                                                      value: profileController
                                                                  .getProfileModel
                                                                  .data!
                                                                  .notification ==
                                                              0
                                                          ? false
                                                          : true,
                                                      // controller.switchValue,
                                                      onToggle:
                                                          (newValue) async {
                                                        final profileProvider =
                                                            Provider.of<
                                                                    ProfileProvider>(
                                                                context,
                                                                listen: false);

                                                        controller
                                                            .setSwitchValue(
                                                                newValue);

                                                        await controller
                                                            .allEnableDisable(
                                                                context,
                                                                RouterHelper
                                                                    .preferencesScreen)
                                                            .then(
                                                                (value) async {
                                                          profileProvider
                                                              .getProfile(
                                                                  context,
                                                                  RouterHelper
                                                                      .preferencesScreen);
                                                          controller
                                                              .getAllPreferences(
                                                                  context,
                                                                  0,
                                                                  RouterHelper
                                                                      .preferencesScreen);
                                                        });
                                                      });
                                                })
                                              ],
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                controller
                                                    .deleteAllPreferences(
                                                        context,
                                                        RouterHelper
                                                            .preferencesScreen)
                                                    .then((value) {
                                                  controller.getAllPreferences(
                                                      context,
                                                      0,
                                                      RouterHelper
                                                          .preferencesScreen);
                                                });
                                              },
                                              child: Text(
                                                deleteAll,
                                                textAlign: TextAlign.center,
                                                style: textStyle(
                                                    fontSize: 16,
                                                    color: primaryBlue,
                                                    fontFamily: rubikRegular),
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                              controller: scrollController,
                                              shrinkWrap: true,
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              itemCount: controller
                                                      .allPreferencesModel
                                                      .data!
                                                      .rows!
                                                      .length +
                                                  1,
                                              itemBuilder: (context, index) {
                                                if (index <
                                                    controller
                                                        .allPreferencesModel
                                                        .data!
                                                        .rows!
                                                        .length) {
                                                  final data = controller
                                                      .allPreferencesModel
                                                      .data!
                                                      .rows![index];
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0),
                                                    child: Slidable(
                                                      endActionPane: ActionPane(
                                                        extentRatio: 0.14,
                                                        motion:
                                                            const ScrollMotion(),
                                                        children: [
                                                          SlidableAction(
                                                            onPressed: (value) {
                                                              controller
                                                                  .deleteSinglePreferences(
                                                                      context,
                                                                      data.id!,
                                                                      RouterHelper
                                                                          .preferencesScreen)
                                                                  .then(
                                                                      (value) {
                                                                controller
                                                                    .deleteItem(
                                                                        index);
                                                              });
                                                            },
                                                            borderRadius: const BorderRadius
                                                                    .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10)),
                                                            backgroundColor:
                                                                primaryRed,
                                                            foregroundColor:
                                                                primaryWhite,
                                                            icon: Icons.delete,
                                                            label: null,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Container(
                                                          decoration: const BoxDecoration(
                                                              color:
                                                                  cardGreyColor,
                                                              border: Border(
                                                                  left: BorderSide(
                                                                      color:
                                                                          primaryGrey,
                                                                      width:
                                                                          2))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5.0,
                                                                    top: 11,
                                                                    bottom: 11),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      displayWidth(
                                                                          context,
                                                                          0.81),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      dataList(
                                                                          context,
                                                                          prefMake,
                                                                          data.make!.isEmpty
                                                                              ? " "
                                                                              : data.make![
                                                                                  0],
                                                                          prefModel,
                                                                          data.model!.isEmpty
                                                                              ? " "
                                                                              : data.model![
                                                                                  0],
                                                                          prefBadge,
                                                                          data.badge!.isEmpty
                                                                              ? " "
                                                                              : data.badge![0]),
                                                                      HeightSizedBox(
                                                                          context,
                                                                          0.01),
                                                                      dataList(
                                                                          context,
                                                                          prefYear,
                                                                          data.year
                                                                              .toString(),
                                                                          prefTransmission,
                                                                          data.transmission!.isEmpty
                                                                              ? " "
                                                                              : data.transmission![
                                                                                  0],
                                                                          prefFuelType,
                                                                          data.fuelType!.isEmpty
                                                                              ? " "
                                                                              : data.fuelType![0]),
                                                                      HeightSizedBox(
                                                                          context,
                                                                          0.01),
                                                                      dataList(
                                                                          context,
                                                                          prefBodyType,
                                                                          data.bodyType!.isEmpty
                                                                              ? " "
                                                                              : data.bodyType![0],
                                                                          prefPurchase,
                                                                          "${data.maximumPurchasePrice == null ? " " : "AU\$"}${data.maximumPurchasePrice ?? " "}",
                                                                          prefSell,
                                                                          "${data.maximumSalePrice == null ? "" : "AU\$"}${data.maximumSalePrice ?? " "}"),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    CustomIconButton(
                                                                        icon: data.isEnabled ==
                                                                                0
                                                                            ? Images
                                                                                .iconNotificationBorder
                                                                            : Images
                                                                                .iconBell,
                                                                        onTap:
                                                                            () {
                                                                          controller.enableDisableModel.error ==
                                                                              null;
                                                                          controller
                                                                              .singleEnableDisable(context, data.id!, data.isEnabled == 0 ? 1 : 0, RouterHelper.preferencesScreen)
                                                                              .then((value) {
                                                                            controller.setNotify(index);
                                                                          });
                                                                        },
                                                                        height: displayWidth(
                                                                            context,
                                                                            0.050),
                                                                        width: displayWidth(
                                                                            context,
                                                                            0.050),
                                                                        color:
                                                                            primaryBlue),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              05.0,
                                                                          horizontal:
                                                                              5.0),
                                                                      child:
                                                                          CircularPercentIndicator(
                                                                        radius: displayWidth(
                                                                            context,
                                                                            0.04),
                                                                        lineWidth:
                                                                            3.0,
                                                                        percent:
                                                                            getPercentage(data.totalCars!),
                                                                        center:
                                                                            SizedBox(
                                                                          height: displayWidth(
                                                                              context,
                                                                              0.05),
                                                                          width: displayWidth(
                                                                              context,
                                                                              0.05),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              data.totalCars!.toString(),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.center,
                                                                              style: textStyle(fontSize: 10, color: primaryBlack, fontFamily: latoBold),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        backgroundColor:
                                                                            veryLightGrey,
                                                                        progressColor:
                                                                            primaryBlue,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                  );
                                                } else {
                                                  return Container(
                                                    height: controller
                                                                .isPagination ==
                                                            true
                                                        ? displayHeight(
                                                            context, 0.3)
                                                        : 120,
                                                    width: displayWidth(
                                                        context, 1),
                                                    color: primaryWhite,
                                                    child: controller
                                                                .isPagination ==
                                                            true
                                                        ? ShimmerSimpleList(
                                                            pagination: 1)
                                                        : const SizedBox(),
                                                  );
                                                }
                                              }),
                                        )
                                      ],
                                    ),
                              Positioned(
                                  right: 10,
                                  bottom: 25,
                                  child: RoundAddButton(
                                    onTap: () {
                                      final prefProvider = Provider.of<
                                              PreferencesAddDataProvider>(
                                          context,
                                          listen: false);
                                      prefProvider.setHide(false);
                                      Navigator.of(context).pushNamed(
                                          RouterHelper
                                              .preferencesAddDataScreen);
                                    },
                                  ))
                            ],
                          )),
                    );
            }),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: !isKeyboard
                ? const CustomFloatingActionButton()
                : const SizedBox(),
            bottomNavigationBar: const BottomNavigation()),
      ),
    );
  }

  Widget dataList(
    BuildContext context,
    String title1,
    String data1,
    String title2,
    String data2,
    String title3,
    String data3,
  ) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: title1,
        style: textStyle(
          fontSize: 10,
          color: primaryBlack,
          fontFamily: latoBold,
        ),
      ),
      WidgetSpan(
        child: WidthSizedBox(context, 0.002),
      ),
      TextSpan(
        text: data1,
        style: textStyle(
            fontSize: 11, color: primaryBlack, fontFamily: latoRegular),
      ),
      WidgetSpan(
        child: WidthSizedBox(context, 0.002),
      ),
      TextSpan(
        text: "|",
        style:
            textStyle(fontSize: 11, color: primaryBlack, fontFamily: latoBold),
      ),
      WidgetSpan(
        child: WidthSizedBox(context, 0.002),
      ),
      TextSpan(
        text: title2,
        style:
            textStyle(fontSize: 10, color: primaryBlack, fontFamily: latoBold),
      ),
      WidgetSpan(
        child: WidthSizedBox(context, 0.002),
      ),
      TextSpan(
        text: data2,
        style: textStyle(
            fontSize: 11, color: primaryBlack, fontFamily: latoRegular),
      ),
      WidgetSpan(
        child: WidthSizedBox(context, 0.002),
      ),
      TextSpan(
        text: "|",
        style:
            textStyle(fontSize: 11, color: primaryBlack, fontFamily: latoBold),
      ),
      WidgetSpan(
        child: WidthSizedBox(context, 0.002),
      ),
      TextSpan(
        text: title3,
        style:
            textStyle(fontSize: 10, color: primaryBlack, fontFamily: latoBold),
      ),
      WidgetSpan(
        child: WidthSizedBox(context, 0.002),
      ),
      TextSpan(
        text: data3,
        style: textStyle(
            fontSize: 11, color: primaryBlack, fontFamily: latoRegular),
      ),
    ]));
  }
}
