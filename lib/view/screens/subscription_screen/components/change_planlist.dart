import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import '../../../../providers/subscription_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_sizedbox.dart';
import 'package:html/dom.dart' as dom;

class ChangePlanList extends StatelessWidget {
  const ChangePlanList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
        builder: (context, controller, child) {
      return ListView.builder(
          shrinkWrap: true,
          reverse: controller.activePlanModel.data!.planId == 1 ? false : true,
          itemCount: controller.getPlanModel.data!.length,
          itemBuilder: (context, index) {
            final data = controller.getPlanModel.data![index];
            final activeIndex =
                controller.activePlanModel.data!.planId == 1 ? 1 : 0;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == activeIndex
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          availablePlan,
                          style: textStyle(
                              fontSize: 16,
                              color: primaryBlack,
                              fontFamily: latoBold),
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: InkWell(
                    onTap: () {
                      controller.setPackagePlan(data.id!);
                      controller.setPlanPrice(data.price!);
                    },
                    child: Container(
                      height: displayHeight(context, 0.25),
                      width: displayWidth(context, 1),
                      decoration: BoxDecoration(
                        color: cardGreyColor,
                        border: Border.all(
                            width: controller.plan == index + 1 ? 2 : 1,
                            color: controller.plan == index + 1
                                ? primaryBlue
                                : primaryGrey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data.name!.toString().toUpperCase(),
                                  style: textStyle(
                                      fontSize: 16,
                                      color: lightGrey,
                                      fontFamily: latoMedium),
                                ),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: controller.plan == index + 1
                                              ? primaryBlue
                                              : lightGrey,
                                          width: controller.plan == index + 1
                                              ? 2.5
                                              : 1)),
                                )
                              ],
                            ),
                            HeightSizedBox(context, 0.01),
                            Row(
                              children: [
                                Text(
                                  data.price.toString(),
                                  style: textStyle(
                                      fontSize: 18,
                                      color: darkBlack,
                                      fontFamily: latoSemiBold),
                                ),
                                Text(
                                  "/" + data.interval.toString(),
                                  style: textStyle(
                                      fontSize: 16,
                                      color: darkBlack,
                                      fontFamily: latoRegular),
                                ),
                              ],
                            ),
                            HeightSizedBox(context, 0.01),
                            SizedBox(
                                height: displayHeight(context, 0.128),
                                child: SingleChildScrollView(
                                  child: Html(
                                    shrinkWrap: true,
                                    data: data.description,
                                    customRender: {
                                      "li": (RenderContext renderContext,
                                          Widget child) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.check_circle,
                                                color: primaryBlue,
                                                size: 15,
                                              ),
                                              WidthSizedBox(context, 0.01),
                                              Expanded(
                                                child: Text(
                                                  renderContext
                                                      .tree.element!.text,
                                                  style: textStyle(
                                                      fontSize: 12,
                                                      color: primaryBlack,
                                                      fontFamily: latoRegular),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    },
                                    style: {
                                      'body': Style(margin: EdgeInsets.zero),
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    });
  }
}
