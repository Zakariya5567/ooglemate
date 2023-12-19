import 'dart:io';

import 'package:caroogle/providers/tracked_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/images.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/widgets/custom_icon_button.dart';
import 'package:caroogle/view/widgets/custom_app_bar.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../../helper/routes_helper.dart';
import '../../../providers/car_detail_provider.dart';
import '../../../providers/search_filter_provider.dart';
import '../../../utils/dimension.dart';
import '../../../utils/style.dart';
import '../../widgets/no_data_found.dart';
import '../../widgets/search_sheet.dart';

class TrackedCarScreen extends StatefulWidget {
  const TrackedCarScreen({Key? key}) : super(key: key);

  @override
  State<TrackedCarScreen> createState() => _TrackedCarScreenState();
}

class _TrackedCarScreenState extends State<TrackedCarScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callingListener();
  }

  callingListener() {
    Future.delayed(Duration.zero, () {
      final provider = Provider.of<TrackedProvider>(context, listen: false);
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
      final provider = Provider.of<TrackedProvider>(context, listen: false);
      provider.setIsSearching(false);
      if (isPagination == 0 && provider.isFilter == false) {
        provider.clearFilter();
        provider.clearOffset();
        provider.getAllTrack(context, 0, RouterHelper.trackedCarScreen);
      } else if (isPagination == 1 && provider.offset < provider.totalPages!) {
        provider.incrementOffset();
        provider.getAllTrack(context, 1, RouterHelper.trackedCarScreen);
      }
    });
  }

  Future<void> onRefresh() async {
    // Your refresh logic goes here
    final provider = Provider.of<TrackedProvider>(context, listen: false);
    await Future.delayed(Duration.zero, () {
      provider.setIsSearching(false);
      provider.clearFilter();
      provider.clearOffset();
      provider.getAllTrack(context, 0, RouterHelper.trackedCarScreen);
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
            title: trackedCar,
            page: 'tracked',
            icon1: const SizedBox(),
            icon2: const SizedBox(),
            icon3: const SizedBox(),
            icon4: CustomIconButton(
                icon: Images.iconSearch,
                height: displayWidth(context, 0.055),
                width: displayWidth(context, 0.055),
                color: primaryGrey,
                onTap: () async {
                  final filterController =
                      Provider.of<SearchFilterProvider>(context, listen: false);
                  filterController.setSearchPage(4);
                  await searchSheet(context);
                }),
          ),
          body:
              Consumer<TrackedProvider>(builder: (context, controller, child) {
            return controller.isLoading == true
                ? ShimmerList(pagination: 0)
                : RefreshIndicator(
                    onRefresh: onRefresh,
                    child: controller.allTrackedCarModel.data == null ||
                            controller.allTrackedCarModel.data!.rows!.isEmpty
                        ? const NoDataFound()
                        : ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller
                                    .allTrackedCarModel.data!.rows!.length +
                                1,
                            itemBuilder: (context, index) {
                              if (index <
                                  controller
                                      .allTrackedCarModel.data!.rows!.length) {
                                final data = controller
                                    .allTrackedCarModel.data!.rows![index];
                                return InkWell(
                                  onTap: () {
                                    final carDetailProvider =
                                        Provider.of<CarDetailProvider>(context,
                                            listen: false);
                                    carDetailProvider.setAdId(data!.adId!);
                                    carDetailProvider.setSelectedScreen(4);
                                    Navigator.of(context).pushNamed(
                                        RouterHelper.carDetailScreen);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    child: Slidable(
                                      endActionPane: ActionPane(
                                        extentRatio: 0.15,
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (value) {
                                              controller.deleteTrackModel
                                                  .error = null;

                                              controller
                                                  .deleteTrackCar(
                                                      context,
                                                      data.id!,
                                                      RouterHelper
                                                          .trackedCarScreen)
                                                  .then((value) {
                                                controller.deleteItem(index);
                                              });
                                            },
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10)),
                                            backgroundColor: primaryRed,
                                            foregroundColor: primaryWhite,
                                            icon: Icons.delete,
                                            label: null,
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 4,
                                              offset: const Offset(-4, 4),
                                            ),
                                          ],
                                          color: cardGreyColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height:
                                                  displayHeight(context, 0.14),
                                              width:
                                                  displayWidth(context, 0.32),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: primaryGrey
                                                      .withOpacity(0.5)),
                                              child: Image.network(
                                                data.image!,
                                                alignment:
                                                    Alignment.bottomCenter,
                                                fit: BoxFit.cover,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Image.asset(
                                                    Images.errorCar,
                                                    scale: 5,
                                                  );
                                                },
                                              ),
                                            ),
                                            HeightSizedBox(context, 0.005),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: SizedBox(
                                                width:
                                                    displayWidth(context, 0.52),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${data.make ?? " "} ${data.model ?? " "}",
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: textStyle(
                                                          fontSize: 15,
                                                          color: primaryBlue,
                                                          fontFamily:
                                                              latoRegular),
                                                    ),
                                                    HeightSizedBox(
                                                        context, 0.02),
                                                    Text(
                                                      "${data.price == null ? " " : "AU\$"} ${data.price ?? " "} ",
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: textStyle(
                                                          fontSize: 14,
                                                          color: primaryBlack,
                                                          fontFamily:
                                                              latoRegular),
                                                    ),
                                                    HeightSizedBox(
                                                        context, 0.02),
                                                    Text(
                                                      "${data.source ?? ""}${data.source == null ? "" : " | "}"
                                                      " ${data.year ?? ""}${data.year == null ? "" : " | "}"
                                                      "${data.kmDriven ?? ""}${data.kmDriven == null ? " " : "km | "}"
                                                      "${data.fuelType ?? ""}",
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: textStyle(
                                                          fontSize: 10,
                                                          color: primaryGrey,
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
                                  ),
                                );
                              } else {
                                return Container(
                                  height: controller.isPagination == true
                                      ? displayHeight(context, 0.3)
                                      : 120,
                                  width: displayWidth(context, 1),
                                  color: primaryWhite,
                                  child: controller.isPagination == true
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: ShimmerList(pagination: 1),
                                        )
                                      : const SizedBox(),
                                );
                              }
                            }));
          }),
        ),
      ),
    );
  }
}
