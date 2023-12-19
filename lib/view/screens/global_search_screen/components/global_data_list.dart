import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/colors.dart';
import '../../../../../utils/dimension.dart';
import '../../../../../utils/images.dart';
import '../../../../../utils/string.dart';
import '../../../../../utils/style.dart';
import '../../../../helper/date_format.dart';
import '../../../../helper/routes_helper.dart';
import '../../../../providers/car_detail_provider.dart';
import '../../../../providers/global_search_provider.dart';
import '../../../widgets/custom_dialog_box.dart';
import '../../../widgets/custom_sizedbox.dart';
import '../../../widgets/no_data_found.dart';
import '../../../widgets/shimmer/shimmer_grid.dart';
import '../../../widgets/shimmer/shimmer_grid_pagination.dart';

class GlobalDataList extends StatefulWidget {
  const GlobalDataList({Key? key}) : super(key: key);

  @override
  State<GlobalDataList> createState() => _GlobalDataListState();
}

class _GlobalDataListState extends State<GlobalDataList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callingListener();
  }

  callingListener() {
    Future.delayed(Duration.zero, () {
      final provider =
          Provider.of<GlobalScreenProvider>(context, listen: false);
      scrollController.addListener(() {
        if (scrollController.position.maxScrollExtent ==
                scrollController.offset &&
            provider.isLoading == false) {
          callingApi();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  callingApi() {
    Future.delayed(Duration.zero, () {
      final globalSearchProvider =
          Provider.of<GlobalScreenProvider>(context, listen: false);
      if (globalSearchProvider.offset < globalSearchProvider.totalPages!) {
        globalSearchProvider.setIsSearching(false);
        globalSearchProvider.incrementOffset();
        globalSearchProvider.getGlobalSearchData(
            context, 1, RouterHelper.globalSearchScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalScreenProvider>(
        builder: (context, controller, child) {
      return Expanded(
          child: controller.globalSearchModel.data == null
              ? ShimmerGrid()
              : controller.globalSearchModel.data!.rows!.isEmpty
                  ? const NoDataFound()
                  : GridView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.offset < controller.totalPages!
                          ? controller.globalSearchModel.data!.rows!.length + 2
                          : controller.globalSearchModel.data!.rows!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        crossAxisCount: 2,
                        childAspectRatio: displayWidth(context, 1) /
                            displayHeight(context, 0.64),
                      ),
                      itemBuilder: (context, index) {
                        if (index <
                            controller.globalSearchModel.data!.rows!.length) {
                          final globalData =
                              controller.globalSearchModel.data!.rows![index];
                          return Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: InkWell(
                              onTap: () {
                                final carDetailProvider =
                                    Provider.of<CarDetailProvider>(context,
                                        listen: false);
                                carDetailProvider.setAdId(globalData.adId!);
                                carDetailProvider.setCarPurchaseIndex(index);
                                carDetailProvider.setSelectedScreen(7);
                                Navigator.of(context)
                                    .pushNamed(RouterHelper.carDetailScreen);
                              },
                              child: Container(
                                //  height: displayHeight(context, 0.60),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                  // color: Colors.red,
                                  color: cardGreyColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: displayHeight(context, 0.20),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color:
                                                  primaryGrey.withOpacity(0.5)),
                                          child: Image.network(
                                            globalData.image!,
                                            alignment: Alignment.bottomCenter,
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Image.asset(
                                                Images.errorCar,
                                                scale: 5,
                                              );
                                            },
                                          ),

                                          // image: NetworkImage(matchesData.image!))),
                                        ),
                                        Positioned(
                                          top: 0,
                                          child: SizedBox(
                                            height: 40,
                                            width: displayWidth(context, 0.45),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      controller
                                                          .markAsFavourite(
                                                              context,
                                                              globalData.adId!,
                                                              RouterHelper
                                                                  .globalSearchScreen)
                                                          .then((value) {
                                                        globalData.isFavourite ==
                                                                0
                                                            ? globalData
                                                                .isFavourite = 1
                                                            : globalData
                                                                .isFavourite = 0;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Icon(
                                                        Icons.star,
                                                        size: 18,
                                                        color: globalData
                                                                    .isFavourite ==
                                                                1
                                                            ? primaryYellow
                                                            : primaryWhite,
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      final isHideProvider =
                                                          Provider.of<
                                                                  CarDetailProvider>(
                                                              context,
                                                              listen: false);
                                                      isHideProvider
                                                          .setHide(false);
                                                      controller.setAdId(
                                                          globalData.adId!);
                                                      if (globalData
                                                              .isPurchased ==
                                                          0) {
                                                        controller
                                                            .markAsPurchasedModel
                                                            .error = null;
                                                        customDialog(
                                                            context: context,
                                                            adId:
                                                                globalData.adId,
                                                            screenID: 5,
                                                            title:
                                                                purchasePrice,
                                                            index: index);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      // width: 95,
                                                      decoration: BoxDecoration(
                                                        color: lightGrey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                            child: globalData
                                                                        .isPurchased ==
                                                                    0
                                                                ? Text(
                                                                    btnMarkAsPurchased,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: textStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color:
                                                                            primaryWhite,
                                                                        fontFamily:
                                                                            latoRegular),
                                                                  )
                                                                : Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        size:
                                                                            12,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      WidthSizedBox(
                                                                          context,
                                                                          0.004),
                                                                      Text(
                                                                        "Purchased",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: textStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                primaryWhite,
                                                                            fontFamily:
                                                                                latoRegular),
                                                                      ),
                                                                    ],
                                                                  )),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: Visibility(
                                            visible: true,
                                            child: Container(
                                              height:
                                                  displayHeight(context, 0.04),
                                              width: displayWidth(context, 0.5),
                                              color: lightGrey,
                                              child: Center(
                                                child: Text(
                                                  "${lastSeen(globalData.dateTime!)}",
                                                  textAlign: TextAlign.center,
                                                  style: textStyle(
                                                      fontSize: 12,
                                                      color: primaryWhite,
                                                      fontFamily: latoRegular),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    HeightSizedBox(context, 0.005),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${globalData.make ?? " "} ${globalData.model ?? " "}",

                                              // "Ford Thunderdbird",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: textStyle(
                                                  fontSize: 15,
                                                  color: primaryBlue,
                                                  fontFamily: latoRegular),
                                            ),
                                            HeightSizedBox(context, 0.002),
                                            Text(
                                              //  "AU\$ 15000 ",
                                              "AU\$ ${globalData.price ?? " "} ",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: textStyle(
                                                  fontSize: 14,
                                                  color: primaryBlack,
                                                  fontFamily: latoRegular),
                                            ),
                                            HeightSizedBox(context, 0.002),
                                            Text(
                                              "${globalData.source ?? ""}${globalData.source == null ? "" : " | "}"
                                              " ${globalData.year ?? ""}${globalData.year == null ? "" : " | "}"
                                              "${globalData.kmDriven ?? ""}${globalData.kmDriven == null ? " " : "km | "}"
                                              "${globalData.fuelType ?? ""}",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: textStyle(
                                                  fontSize: 10,
                                                  color: primaryBlack,
                                                  fontFamily: latoRegular),
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
                          return controller.isPagination == true
                              ? const ShimmerGridPagination()
                              : const SizedBox();
                        }
                      }));
    });
  }
}
