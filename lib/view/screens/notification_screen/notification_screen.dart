import 'dart:io';
import 'package:caroogle/helper/date_format.dart';
import 'package:caroogle/providers/notification_provider.dart';
import 'package:caroogle/providers/profile_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/images.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/named_app_bar.dart';
import 'package:caroogle/view/widgets/no_data_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../helper/routes_helper.dart';
import '../../../providers/car_detail_provider.dart';
import '../../../utils/dimension.dart';
import '../../../utils/style.dart';
import '../../widgets/shimmer/shimmer_simple_list.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callingListener();
  }

  callingListener() async {
    Future.delayed(Duration.zero, () {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);

      // set the notification status false , to hide highlight notification
      profileProvider.setNotificationStatus(false);

      final provider =
          Provider.of<NotificationProvider>(context, listen: false);

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
    // if value = 1 its mean we are doing pagination with increment pages
    //if value = 2 its mean we are doing pagination with decrement pages

    Future.delayed(Duration.zero).then((value) {
      final provider =
          Provider.of<NotificationProvider>(context, listen: false);
      if (isPagination == 0) {
        provider.clearOffset();
        provider.getNotification(context, 0, RouterHelper.notificationScreen);
      } else if (isPagination == 1 && provider.offset < provider.totalPages!) {
        provider.incrementOffset();
        provider.getNotification(context, 1, RouterHelper.notificationScreen);
      }
    });
  }

  Future<void> onRefresh() async {
    // Your refresh logic goes here
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    await Future.delayed(Duration.zero, () {
      provider.clearOffset();
      provider.getNotification(context, 0, RouterHelper.notificationScreen);
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
          appBar: namedAppBar(
              context: context, title: notifications, color: primaryWhite),
          body: Consumer<NotificationProvider>(
              builder: (context, controller, child) {
            return controller.isLoading == true ||
                    controller.notificationModel.data == null
                ? ShimmerSimpleList(pagination: 0)
                : RefreshIndicator(
                    onRefresh: onRefresh,
                    child: controller.notificationModel.data!.rows!.isEmpty
                        ? const NoDataFound()
                        : ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller
                                    .notificationModel.data!.rows!.length +
                                1,
                            itemBuilder: (context, index) {
                              if (index <
                                  controller
                                      .notificationModel.data!.rows!.length) {
                                final data = controller
                                    .notificationModel.data!.rows![index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: InkWell(
                                    onTap: () {
                                      final carDetailProvider =
                                          Provider.of<CarDetailProvider>(
                                              context,
                                              listen: false);
                                      carDetailProvider.setAdId(data.adId!);

                                      carDetailProvider.setDataId(data.userId!);

                                      carDetailProvider
                                          .setCarPurchaseIndex(index);

                                      carDetailProvider.setSelectedScreen(6);
                                      Navigator.of(context).pushNamed(
                                          RouterHelper.carDetailScreen);
                                    },
                                    child: Container(
                                      height: displayHeight(context, 0.09),
                                      width: displayWidth(context, 0.02),
                                      decoration: const BoxDecoration(
                                          color: primaryWhite,
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: veryLightGrey,
                                                  width: 1))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: displayHeight(
                                                    context, 0.09),
                                                width:
                                                    displayWidth(context, 0.18),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: displayWidth(
                                                          context, 0.14),
                                                      width: displayWidth(
                                                          context, 0.14),
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Image.network(
                                                        data.carImage!,
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object
                                                                    exception,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Image.asset(
                                                            Images.errorCar,
                                                            scale: 5,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: displayWidth(
                                                          context, 0.080),
                                                      top: displayHeight(
                                                          context, 0.034),
                                                      child: Container(
                                                        height: displayWidth(
                                                            context, 0.09),
                                                        width: displayWidth(
                                                            context, 0.09),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: primaryBlue,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Center(
                                                          child: Image.asset(
                                                            data.type ==
                                                                    "PREFERENCE"
                                                                ? Images
                                                                    .iconPreferences
                                                                : data.type ==
                                                                        "TRIGGER"
                                                                    ? Images
                                                                        .iconTrigger
                                                                    : data.type ==
                                                                            "TRACK_PURCHASE"
                                                                        ? Images
                                                                            .iconTrack
                                                                        : Images
                                                                            .iconTrack,
                                                            height:
                                                                displayWidth(
                                                                    context,
                                                                    0.055),
                                                            width: displayWidth(
                                                                context, 0.055),
                                                            color: primaryWhite,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: displayHeight(
                                                        context, 0)),
                                                child: SizedBox(
                                                  width: displayWidth(
                                                      context, 0.60),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      HeightSizedBox(
                                                          context, 0.005),
                                                      Text(
                                                        data.title ?? " ",
                                                        //"Ford Mustang",
                                                        textAlign:
                                                            TextAlign.start,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: textStyle(
                                                            fontSize: 14,
                                                            color: primaryBlack,
                                                            fontFamily:
                                                                latoRegular),
                                                      ),
                                                      HeightSizedBox(
                                                          context, 0.005),
                                                      Text(
                                                        data.carTitle ?? " ",
                                                        //"Ford Mustang",
                                                        textAlign:
                                                            TextAlign.start,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: textStyle(
                                                            fontSize: 15,
                                                            color: primaryBlack,
                                                            fontFamily:
                                                                latoBold),
                                                      ),
                                                      HeightSizedBox(
                                                          context, 0.01),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: Image.asset(
                                                              Images.iconClock,
                                                              height:
                                                                  displayWidth(
                                                                      context,
                                                                      0.03),
                                                              width:
                                                                  displayWidth(
                                                                      context,
                                                                      0.03),
                                                              color:
                                                                  primaryBlack,
                                                            ),
                                                          ),
                                                          WidthSizedBox(
                                                              context, 0.005),
                                                          Text(
                                                            timeFormat(data
                                                                .createdAt!),
                                                            //"12:00 AM",
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: textStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    primaryBlack,
                                                                fontFamily:
                                                                    latoBold),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              height: 12,
                                              width: 12,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: primaryBlue),
                                            ),
                                          )
                                        ],
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
                                              vertical: 8.0, horizontal: 15),
                                          child:
                                              ShimmerSimpleList(pagination: 1),
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
