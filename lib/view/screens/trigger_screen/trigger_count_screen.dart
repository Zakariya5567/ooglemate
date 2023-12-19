import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/profile_provider.dart';
import 'package:caroogle/providers/trigger_provider.dart';
import 'package:caroogle/view/screens/trigger_screen/components/trigger_title_list.dart';
import 'package:caroogle/view/widgets/custom_app_bar.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../providers/car_detail_provider.dart';
import '../../../providers/search_filter_provider.dart';
import '../../../utils/style.dart';
import '../../widgets/circular_progress.dart';
import '../../widgets/custom_icon_button.dart';

import '../../widgets/custom_sizedbox.dart';
import '../../widgets/no_data_found.dart';
import '../../widgets/search_sheet.dart';
import '../../widgets/shimmer/shimmer_grid_pagination.dart';

class TriggerCountScreen extends StatefulWidget {
  const TriggerCountScreen({Key? key}) : super(key: key);

  @override
  State<TriggerCountScreen> createState() => _TriggerCountScreenState();
}

class _TriggerCountScreenState extends State<TriggerCountScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callingListener();
  }

  callingListener() {
    Future.delayed(Duration.zero, () {
      final provider = Provider.of<TriggerProvider>(context, listen: false);
      provider.setLoading(true);
      callingApi(0);

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
      final provider = Provider.of<TriggerProvider>(context, listen: false);
      provider.setIsSearching(false);
      provider.getSource(context, RouterHelper.inventoryScreen).then((value) {
        if (isPagination == 0 && provider.isFilter == false) {
          provider.clearTitleIndex();
          provider.clearFilter();
          provider.clearOffset();
          provider.getCarInTrigger(context, 0, RouterHelper.triggerCountScreen);
        } else if (isPagination == 1 &&
            provider.offset < provider.totalPages!) {
          provider.incrementOffset();
          provider.getCarInTrigger(context, 1, RouterHelper.triggerCountScreen);
        }
      });
    });
  }

  Future<void> onRefresh() async {
    // Your refresh logic goes here
    final provider = Provider.of<TriggerProvider>(context, listen: false);
    await Future.delayed(Duration.zero, () {
      provider.setIsSearching(false);
      provider.clearFilter();
      provider.clearOffset();
      provider.getCarInTrigger(context, 0, RouterHelper.triggerCountScreen);
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
            appBar: customAppBar(
                context: context,
                color: primaryWhite,
                title: triggerCount,
                page: 'trigger_count',
                icon1: CustomIconButton(
                    icon: Images.iconSearch,
                    height: displayWidth(context, 0.055),
                    width: displayWidth(context, 0.055),
                    color: primaryGrey,
                    onTap: () async {
                      final filterController =
                          Provider.of<SearchFilterProvider>(context,
                              listen: false);
                      filterController.setSearchPage(6);
                      await searchSheet(context);
                    }),
                icon2: CustomIconButton(
                    icon: Images.iconTrack,
                    color: primaryGrey,
                    height: displayWidth(context, 0.055),
                    width: displayWidth(context, 0.055),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(RouterHelper.trackedCarScreen);
                    }),
                icon3: CustomIconButton(
                    icon: Images.iconTrigger,
                    height: displayWidth(context, 0.055),
                    width: displayWidth(context, 0.055),
                    color: primaryGrey,
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(RouterHelper.triggerScreen);
                    }),
                icon4: Consumer<ProfileProvider>(
                    builder: (context, profileProvider, child) {
                  return SizedBox(
                    child: profileProvider.isNotify == true
                        ? badges.Badge(
                            position:
                                badges.BadgePosition.topEnd(top: 0, end: 0),
                            badgeStyle: const badges.BadgeStyle(
                              borderSide: BorderSide(color: primaryWhite),
                              shape: badges.BadgeShape.circle,
                              badgeColor: primaryBlue,
                              elevation: 5,
                            ),
                            child: CustomIconButton(
                                icon: Images.iconNotification,
                                height: displayWidth(context, 0.055),
                                width: displayWidth(context, 0.055),
                                color: primaryGrey,
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      RouterHelper.notificationScreen);
                                }),
                          )
                        : CustomIconButton(
                            icon: Images.iconNotification,
                            height: displayWidth(context, 0.055),
                            width: displayWidth(context, 0.055),
                            color: primaryGrey,
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(RouterHelper.notificationScreen);
                            }),
                  );
                })),
            body: SizedBox(
              height: displayHeight(context, 1),
              child: Consumer<TriggerProvider>(
                  builder: (context, controller, child) {
                return controller.isLoading == true ||
                        controller.carinTriggerModel.data == null
                    ? ShimmerGrid(
                        pagination: 0,
                      )
                    : RefreshIndicator(
                        onRefresh: onRefresh,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 0),
                          child: Column(
                            children: [
                              TriggerTitleList(),
                              controller.carinTriggerModel.data!.rows!.isEmpty
                                  ? const Expanded(child: NoDataFound())
                                  : Expanded(
                                      child: GridView.builder(
                                          controller: scrollController,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemCount: controller.offset <
                                                  controller.totalPages!
                                              ? controller.carinTriggerModel
                                                      .data!.rows!.length +
                                                  2
                                              : controller.carinTriggerModel
                                                  .data!.rows!.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10,
                                            childAspectRatio: displayWidth(
                                                    context, 1) /
                                                displayHeight(context, 0.64),
                                          ),
                                          itemBuilder: (context, index) {
                                            if (index <
                                                controller.carinTriggerModel
                                                    .data!.rows!.length) {
                                              final data = controller
                                                  .carinTriggerModel
                                                  .data!
                                                  .rows![index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    final carDetailProvider =
                                                        Provider.of<
                                                                CarDetailProvider>(
                                                            context,
                                                            listen: false);
                                                    carDetailProvider
                                                        .setAdId(data.adId!);
                                                    carDetailProvider
                                                        .setSelectedScreen(5);
                                                    Navigator.of(context)
                                                        .pushNamed(RouterHelper
                                                            .carDetailScreen);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 1,
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                              1,
                                                              1), // changes position of shadow
                                                        ),
                                                      ],
                                                      color: cardGreyColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height: displayHeight(
                                                              context, 0.20),
                                                          width:
                                                              double.infinity,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              image: DecorationImage(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomCenter,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: NetworkImage(
                                                                      data.image!))),
                                                        ),
                                                        HeightSizedBox(
                                                            context, 0.005),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${data.make ?? " "} ${data.model ?? " "}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color:
                                                                          primaryBlue,
                                                                      fontFamily:
                                                                          latoRegular),
                                                                ),
                                                                HeightSizedBox(
                                                                    context,
                                                                    0.002),
                                                                Text(
                                                                  "${data.price == null ? " " : "AU\$"} ${data.price ?? " "} ",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          primaryBlack,
                                                                      fontFamily:
                                                                          latoRegular),
                                                                ),
                                                                HeightSizedBox(
                                                                    context,
                                                                    0.002),
                                                                Text(
                                                                  "${data.source ?? ""}${data.source == null ? "" : " | "}"
                                                                  " ${data.year ?? ""}${data.year == null ? "" : " | "}"
                                                                  "${data.kmDriven ?? ""}${data.kmDriven == null ? " " : "km | "}"
                                                                  "${data.fuelType ?? ""}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: textStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color:
                                                                          primaryBlack,
                                                                      fontFamily:
                                                                          latoRegular),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return controller.isPagination ==
                                                      true
                                                  ? const ShimmerGridPagination()
                                                  : const SizedBox();
                                            }
                                          })),
                            ],
                          ),
                        ),
                      );
              }),
            )),
      ),
    );
  }
}
