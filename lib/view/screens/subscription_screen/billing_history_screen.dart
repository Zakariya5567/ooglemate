import 'dart:io';

import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/utils/style.dart';
import 'package:caroogle/view/widgets/custom_button.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/named_app_bar.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_plan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../helper/date_format.dart';
import '../../../helper/routes_helper.dart';
import '../../../providers/subscription_provider.dart';

class BillingHistoryScreen extends StatefulWidget {
  const BillingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<BillingHistoryScreen> createState() => _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends State<BillingHistoryScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callingListener();
  }

  callingListener() {
    Future.delayed(Duration.zero, () {
      final provider =
          Provider.of<SubscriptionProvider>(context, listen: false);
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
          Provider.of<SubscriptionProvider>(context, listen: false);
      if (isPagination == 0) {
        provider.clearOffset();
        provider.billingHistory(context, 0, RouterHelper.billingHistoryScreen);
      } else if (isPagination == 1 && provider.offset < provider.totalPages!) {
        provider.incrementOffset();
        provider.billingHistory(context, 1, RouterHelper.billingHistoryScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: greyStatusStatusBar(),
      child: SafeArea(
        bottom: Platform.isAndroid ? true : false,
        top: Platform.isAndroid ? true : false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: namedAppBar(
                context: context, title: billingHistory, color: cardGreyColor),
            backgroundColor: primaryWhite,
            body: Consumer<SubscriptionProvider>(
                builder: (context, controller, child) {
              return controller.isLoading == true ||
                      controller.historyModel.data == null
                  ? const ShimmerPlan()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: displayWidth(context, 1),
                          decoration: const BoxDecoration(
                              color: cardGreyColor,
                              border: Border(
                                  bottom: BorderSide(color: veryLightGrey))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                HeightSizedBox(context, 0.02),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      HeightSizedBox(context, 0.01),
                                      Text(
                                        "You will be charged AU\$${controller.activePlanModel.data!.price} at the ${controller.activePlanModel.data!.createdAt!.day} of every month",
                                        style: textStyle(
                                            fontSize: 12,
                                            color: primaryBlack,
                                            fontFamily: latoBold),
                                      ),
                                      HeightSizedBox(context, 0.01),
                                      Text(
                                        "Next billing date ${dateFormat(controller.activePlanModel.data!.endAt!)}",
                                        style: textStyle(
                                            fontSize: 12,
                                            color: primaryBlack,
                                            fontFamily: latoRegular),
                                      ),
                                      HeightSizedBox(context, 0.01),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        HeightSizedBox(context, 0.02),

                        // history
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            width: displayWidth(context, 1),
                            decoration: BoxDecoration(
                              color: cardGreyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 60,
                                    width: displayWidth(context, 1),
                                    decoration: const BoxDecoration(
                                      //color: Colors.red,
                                      border: Border(
                                          bottom: BorderSide(
                                              color: veryLightGrey, width: 1)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const SizedBox(),
                                        Text(
                                          historyDate,
                                          style: textStyle(
                                              fontSize: 18,
                                              color: darkBlack,
                                              fontFamily: latoSemiBold),
                                        ),
                                        const SizedBox(),
                                        Text(
                                          historyAmount,
                                          style: textStyle(
                                              fontSize: 18,
                                              color: darkBlack,
                                              fontFamily: latoSemiBold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  HeightSizedBox(context, 0.01),
                                  controller.historyModel.data!.rows!.isEmpty
                                      ? Container(
                                          height: 50,
                                        )
                                      : SizedBox(
                                          height: displayHeight(context, 0.50),
                                          child: ListView.builder(
                                              controller: scrollController,
                                              shrinkWrap: true,
                                              itemCount: controller.historyModel
                                                      .data!.rows!.length! +
                                                  1,
                                              physics: const ScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                if (index <
                                                    controller.historyModel
                                                        .data!.rows!.length) {
                                                  final data = controller
                                                      .historyModel
                                                      .data!
                                                      .rows![index];
                                                  return Container(
                                                    height: 60,
                                                    width: displayWidth(
                                                        context, 1),
                                                    decoration:
                                                        const BoxDecoration(
                                                      //color: Colors.red,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color:
                                                                  // index ==
                                                                  //         controller
                                                                  //                 .historyModel
                                                                  //                 .data!
                                                                  //                 .rows!
                                                                  //                 .length -
                                                                  //             1
                                                                  //     ? Colors
                                                                  //         .transparent
                                                                  //     :
                                                                  veryLightGrey,
                                                              width: 1)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text(
                                                          dateFormatDash(
                                                              data.createdAt!),
                                                          style: textStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  primaryGrey,
                                                              fontFamily:
                                                                  latoRegular),
                                                        ),
                                                        Text(
                                                          "AU\$${data.price}",
                                                          style: textStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  primaryGrey,
                                                              fontFamily:
                                                                  latoRegular),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  return controller
                                                              .isPagination ==
                                                          true
                                                      ? Shimmer.fromColors(
                                                          baseColor:
                                                              veryLightGrey,
                                                          highlightColor:
                                                              cardGreyColor,
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child:
                                                                    Container(
                                                                  height: 60,
                                                                  width:
                                                                      displayWidth(
                                                                          context,
                                                                          1),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color:
                                                                        cardGreyColor,
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color:
                                                                                veryLightGrey,
                                                                            width:
                                                                                1)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child:
                                                                    Container(
                                                                  height: 60,
                                                                  width:
                                                                      displayWidth(
                                                                          context,
                                                                          1),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color:
                                                                        cardGreyColor,
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color:
                                                                                veryLightGrey,
                                                                            width:
                                                                                1)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : const SizedBox();
                                                }
                                              }),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
            })),
      ),
    );
  }
}
