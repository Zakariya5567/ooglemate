import 'dart:io';

import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/utils/images.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/utils/style.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/subscription_provider.dart';
import '../../widgets/shimmer/shimmer_plan.dart';
import 'componets/plan_list.dart';

class ChoosePlanScreen extends StatefulWidget {
  ChoosePlanScreen({Key? key}) : super(key: key);

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  @override
  void initState() {
    super.initState();
    callingApi();
  }

  callingApi() async {
    Future.delayed(Duration.zero, () {
      final planProvider =
          Provider.of<SubscriptionProvider>(context, listen: false);
      planProvider.setLoading(true);
      planProvider.getPlan(context, RouterHelper.choosePlanScreen);
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
            appBar: AppBar(
              backgroundColor: primaryWhite,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            backgroundColor: primaryWhite,
            body: Consumer<SubscriptionProvider>(
                builder: (context, controller, child) {
              return
                  //Connection();
                  controller.getPlanModel.data == null ||
                          controller.isLoading == true
                      ? const ShimmerPlan()
                      : SingleChildScrollView(
                          child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                choosePlan,
                                style: textStyle(
                                    fontSize: 24,
                                    color: primaryBlack,
                                    fontFamily: latoBold),
                              ),
                              HeightSizedBox(context, 0.05),
                              const PlanList(),

                              HeightSizedBox(context, 0.04),

                              // start your free trail button

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () async {
                                    // Navigator.of(context)
                                    //     .pushNamed(RouterHelper.addCardScreen);
                                    if (controller.plan == 1 ||
                                        controller.plan == 2) {
                                      controller
                                          .createCheckout(
                                              context,
                                              controller.plan!,
                                              RouterHelper.choosePlanScreen)
                                          .then((value) async {
                                        if (controller.checkoutModel.error ==
                                            false) {
                                          Navigator.of(context).pushNamed(
                                              RouterHelper.addCardScreen);
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: displayHeight(context, 0.060),
                                    width: displayWidth(context, 1),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: controller.plan == 1 ||
                                              controller.plan == 2
                                          ? gradientBlue
                                          : greyGradient,
                                    ),
                                    child: controller.plan == 1 ||
                                            controller.plan == 2
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: displayWidth(
                                                        context, 0.040)),
                                                child: Image.asset(
                                                  Images.iconStripe,
                                                  height: displayWidth(
                                                      context, 0.11),
                                                  width: displayWidth(
                                                      context, 0.11),
                                                ),
                                              ),
                                              Text(btnStartYourFreeTrail,
                                                  textAlign: TextAlign.center,
                                                  style: textStyle(
                                                      fontSize: 14,
                                                      color: primaryWhite,
                                                      fontFamily: sfProText)),
                                              Opacity(
                                                opacity: 0,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: displayWidth(
                                                          context, 0.0)),
                                                  child: Image.asset(
                                                    Images.iconStripe,
                                                    height: displayWidth(
                                                        context, 0.11),
                                                    width: displayWidth(
                                                        context, 0.11),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Center(
                                            child: Text(btnStartYourFreeTrail,
                                                style: textStyle(
                                                    fontSize: 14,
                                                    color: primaryWhite,
                                                    fontFamily: sfProText)),
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ));
            })),
      ),
    );
  }
}
