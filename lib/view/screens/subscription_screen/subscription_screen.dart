import 'dart:io';

import 'package:caroogle/data/models/subscription/get_plan_model.dart';
import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/utils/style.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/named_app_bar.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../helper/connection_checker.dart';
import '../../../helper/date_format.dart';
import '../../../providers/subscription_provider.dart';
import '../../widgets/circular_progress.dart';
import '../../widgets/connection.dart';
import '../../widgets/custom_button.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    callingApi();
  }

  callingApi() {
    Future.delayed(Duration.zero).then((value) {
      final provider =
          Provider.of<SubscriptionProvider>(context, listen: false);
      provider.setLoading(true);
      provider.getPlan(context, RouterHelper.subscriptionScreen);
      provider.getActivePlan(context, RouterHelper.subscriptionScreen);
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
                context: context, title: subscription, color: cardGreyColor),
            backgroundColor: primaryWhite,
            body: Consumer<SubscriptionProvider>(
                builder: (context, controller, child) {
              return controller.isLoading == true ||
                      controller.activePlanModel.data == null ||
                      controller.getPlanModel.data == null
                  ? const ShimmerPlan()
                  : SingleChildScrollView(
                      child: Builder(builder: (context) {
                        var planIndex =
                            controller.activePlanModel.data!.planId == 1
                                ? controller.getPlanModel.data![0]
                                : controller.getPlanModel.data![1];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: displayWidth(context, 1),
                              decoration: const BoxDecoration(
                                  color: cardGreyColor,
                                  border: Border(
                                      bottom:
                                          BorderSide(color: veryLightGrey))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 08.0, vertical: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    HeightSizedBox(context, 0.04),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        currentPlan,
                                        style: textStyle(
                                            fontSize: 24,
                                            color: primaryBlack,
                                            fontFamily: latoBold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            HeightSizedBox(context, 0.03),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: displayWidth(context, 1),
                                    decoration: BoxDecoration(
                                      color: cardGreyColor,
                                      border: Border.all(
                                          width: 2, color: primaryBlue),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            planIndex.name!.toUpperCase(),
                                            style: textStyle(
                                                fontSize: 16,
                                                color: lightGrey,
                                                fontFamily: latoMedium),
                                          ),
                                          HeightSizedBox(context, 0.01),
                                          Row(
                                            children: [
                                              Text(
                                                "AU\$${planIndex.price}",
                                                style: textStyle(
                                                    fontSize: 18,
                                                    color: darkBlack,
                                                    fontFamily: latoSemiBold),
                                              ),
                                              Text(
                                                "/${planIndex.interval}",
                                                style: textStyle(
                                                    fontSize: 16,
                                                    color: darkBlack,
                                                    fontFamily: latoRegular),
                                              ),
                                            ],
                                          ),
                                          HeightSizedBox(context, 0.01),
                                          SizedBox(
                                              height:
                                                  displayHeight(context, 0.128),
                                              child: SingleChildScrollView(
                                                child: Html(
                                                  shrinkWrap: true,
                                                  data: planIndex.description,
                                                  customRender: {
                                                    "li": (RenderContext
                                                            renderContext,
                                                        Widget child) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  primaryBlue,
                                                              size: 15,
                                                            ),
                                                            WidthSizedBox(
                                                                context, 0.01),
                                                            Expanded(
                                                              child: Text(
                                                                renderContext
                                                                    .tree
                                                                    .element!
                                                                    .text,
                                                                style: textStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color:
                                                                        primaryBlack,
                                                                    fontFamily:
                                                                        latoRegular),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  },
                                                  style: {
                                                    'body': Style(
                                                        margin:
                                                            EdgeInsets.zero),
                                                  },
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  HeightSizedBox(context, 0.02),
                                  Container(
                                    width: displayWidth(context, 1),
                                    decoration: BoxDecoration(
                                      color: cardGreyColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          HeightSizedBox(context, 0.01),
                                          Text(
                                            "You will be charged AU\$${controller.activePlanModel.data!.price} at the ${controller.activePlanModel.data!.createdAt!.day}th of every month",
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
                                  ),
                                  HeightSizedBox(context, 0.02),
                                  CustomButton(
                                      buttonName: btnViewBillingHistory,
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            RouterHelper.billingHistoryScreen);
                                      },
                                      buttonGradient:
                                          const LinearGradient(colors: [
                                        primaryWhite,
                                        primaryWhite,
                                      ]),
                                      buttonTextColor: primaryBlue,
                                      padding: 20),
                                  HeightSizedBox(context, 0.10),
                                  CustomButton(
                                      buttonName: btnCancelOrChangePlan,
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            RouterHelper.changePlanScreen);
                                      },
                                      buttonGradient: gradientBlue,
                                      buttonTextColor: primaryWhite,
                                      padding: 20),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    );
            })),
      ),
    );
  }
}
