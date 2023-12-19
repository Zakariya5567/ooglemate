import 'dart:io';

import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/utils/style.dart';
import 'package:caroogle/view/widgets/custom_button.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/named_app_bar.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/subscription_provider.dart';
import '../../../utils/app_constant.dart';
import '../../widgets/circular_progress.dart';
import '../packege_plan_screen/componets/plan_list.dart';
import 'components/change_planlist.dart';

class ChangePlanScreen extends StatelessWidget {
  const ChangePlanScreen({Key? key}) : super(key: key);

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
                context: context, title: changPlan, color: cardLightColor),
            backgroundColor: primaryWhite,
            body: Consumer<SubscriptionProvider>(
                builder: (context, controller, child) {
              return controller.isLoading == true
                  ? const ShimmerPlan()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentPlan,
                                  style: textStyle(
                                      fontSize: 16,
                                      color: primaryBlack,
                                      fontFamily: latoBold),
                                ),
                                // HeightSizedBox(context, 0.02),
                                const ChangePlanList(),
                                HeightSizedBox(context, 0.01),
                                CustomButton(
                                    buttonName: btnContinue,
                                    onPressed: () async {
                                      controller
                                          .changeSubscription(
                                              context,
                                              controller.plan!,
                                              RouterHelper.changePlanScreen)
                                          .then((value) {
                                        if (controller.changeSubscriptionModel
                                                .error ==
                                            false) {
                                          controller.getActivePlan(context,
                                              RouterHelper.changePlanScreen);
                                          controller.getPlan(context,
                                              RouterHelper.changePlanScreen);
                                        }
                                      });
                                    },
                                    buttonGradient: gradientBlue,
                                    buttonTextColor: primaryWhite,
                                    padding: 20),
                                HeightSizedBox(context, 0.015),
                                Divider(),
                                HeightSizedBox(context, 0.015),
                                CustomButton(
                                    buttonName: btnCancelSubscription,
                                    onPressed: () async {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      // ignore: use_build_context_synchronously
                                      controller
                                          .cancelSubscription(
                                              context,
                                              controller
                                                  .activePlanModel.data!.id!,
                                              RouterHelper.changePlanScreen)
                                          .then((value) {
                                        if (controller.cancelSubscriptionModel
                                                .error ==
                                            false) {
                                          sharedPreferences.setBool(
                                              AppConstant.subscription, false);
                                          Navigator.pushReplacementNamed(
                                              context,
                                              RouterHelper.choosePlanScreen);
                                        }
                                      });
                                    },
                                    buttonGradient: const LinearGradient(
                                        colors: [primaryWhite, primaryWhite]),
                                    buttonTextColor: primaryBlue,
                                    padding: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
            })),
      ),
    );
  }
}
