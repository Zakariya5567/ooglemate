import 'dart:io';

import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/profile_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/images.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/widgets/custom_icon_button.dart';
import 'package:caroogle/view/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../helper/percentage_finder.dart';
import '../../../providers/search_filter_provider.dart';
import '../../../providers/set_trigger_provider.dart';
import '../../../providers/trigger_provider.dart';
import '../../../utils/dimension.dart';
import '../../../utils/style.dart';
import '../../widgets/custom_sizedbox.dart';
import '../../widgets/no_data_found.dart';
import '../../widgets/search_sheet.dart';
import '../../widgets/shimmer/shimmer_simple_list.dart';

class TriggerScreen extends StatefulWidget {
  const TriggerScreen({Key? key}) : super(key: key);

  @override
  State<TriggerScreen> createState() => _TriggerScreenState();
}

class _TriggerScreenState extends State<TriggerScreen> {
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
      if (isPagination == 0 && provider.isFilter == false) {
        provider.clearFilter();
        provider.clearOffset();
        provider.getAllTrigger(context, 0, RouterHelper.trackedCarScreen);
      } else if (isPagination == 1 && provider.offset < provider.totalPages!) {
        provider.incrementOffset();
        provider.getAllTrigger(context, 1, RouterHelper.trackedCarScreen);
      }
    });
  }

  Future<void> onRefresh() async {
    // Your refresh logic goes here
    final provider = Provider.of<TriggerProvider>(context, listen: false);

    await Future.delayed(Duration.zero, () {
      provider.setIsSearching(false);
      provider.clearFilter();
      provider.clearOffset();
      provider.getAllTrigger(context, 0, RouterHelper.trackedCarScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
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
            title: trigger,
            page: 'trigger',
            icon1: const SizedBox(),
            icon2: const SizedBox(),
            icon3: const SizedBox(),
            icon4: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomIconButton(
                  icon: Images.iconSearch,
                  height: displayWidth(context, 0.060),
                  width: displayWidth(context, 0.060),
                  color: primaryGrey,
                  onTap: () async {
                    final filterController = Provider.of<SearchFilterProvider>(
                        context,
                        listen: false);
                    filterController.setSearchPage(5);
                    await searchSheet(context);
                  }),
            ),
          ),
          body:
              Consumer<TriggerProvider>(builder: (context, controller, child) {
            return controller.isLoading == true
                ? ShimmerSimpleList(pagination: 0)
                : RefreshIndicator(
                    onRefresh: onRefresh,
                    child: controller.allTriggerModel.data == null ||
                            controller.allTriggerModel.data!.rows!.isEmpty
                        ? const NoDataFound()
                        : ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount:
                                controller.allTriggerModel.data!.rows!.length +
                                    1,
                            itemBuilder: (context, index) {
                              if (index <
                                  controller
                                      .allTriggerModel.data!.rows!.length) {
                                final data = controller
                                    .allTriggerModel.data!.rows![index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: InkWell(
                                    onTap: () {
                                      controller.setTriggerId(data.id!);
                                      Navigator.of(context).pushNamed(
                                          RouterHelper.triggerCountScreen);
                                    },
                                    child: Slidable(
                                      endActionPane: ActionPane(
                                        extentRatio: 0.14,
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (value) {
                                              controller.deleteTriggerModel
                                                  .error = null;
                                              controller
                                                  .deleteTrigger(
                                                      context,
                                                      data.id!,
                                                      RouterHelper
                                                          .preferencesScreen)
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
                                          color: cardGreyColor,
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 1.5,
                                                  height: displayHeight(
                                                      context, 0.1),
                                                  color: primaryGrey,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: SizedBox(
                                                    width: displayWidth(
                                                        context, 0.65),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          profileProvider
                                                              .getProfileModel
                                                              .data!
                                                              .name!,
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: textStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  primaryBlue,
                                                              fontFamily:
                                                                  latoBold),
                                                        ),
                                                        HeightSizedBox(
                                                            context, 0.002),
                                                        Text(
                                                          profileProvider
                                                              .getProfileModel
                                                              .data!
                                                              .email!,
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: textStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  primaryBlack,
                                                              fontFamily:
                                                                  latoMedium),
                                                        ),
                                                        HeightSizedBox(
                                                            context, 0.002),
                                                        Text(
                                                          data.keyWord!,
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: textStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  primaryBlack,
                                                              fontFamily:
                                                                  latoRegular),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: CircularPercentIndicator(
                                                radius:
                                                    displayWidth(context, 0.06),
                                                lineWidth: 4.0,
                                                percent: getPercentage(
                                                    data.totalCars!),
                                                center: SizedBox(
                                                  height: displayWidth(
                                                      context, 0.05),
                                                  width: displayWidth(
                                                      context, 0.05),
                                                  child: Center(
                                                    child: Text(
                                                      data.totalCars!
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: textStyle(
                                                          fontSize: 10,
                                                          color: primaryBlack,
                                                          fontFamily: latoBold),
                                                    ),
                                                  ),
                                                ),
                                                backgroundColor: veryLightGrey,
                                                progressColor: primaryBlue,
                                              ),
                                            ),
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
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              ShimmerSimpleList(pagination: 1),
                                        )
                                      : const SizedBox(),
                                );
                              }
                            }));
          }),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryBlue,
            child: const Icon(
              Icons.add,
              color: primaryWhite,
              size: 35,
            ),
            onPressed: () {
              final setTriggerProvider =
                  Provider.of<SetTriggerProvider>(context, listen: false);
              setTriggerProvider.setPrepopulate(0);
              setTriggerProvider.setHide(false);
              Navigator.of(context).pushNamed(RouterHelper.setTriggerScreen);
            },
          ),
        ),
      ),
    );
  }
}
