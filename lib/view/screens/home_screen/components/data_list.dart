import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/car_detail_provider.dart';
import 'package:caroogle/providers/favourite_provider.dart';
import 'package:caroogle/providers/home_screen_provider.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/profile_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_dialog_box.dart';
import '../../../widgets/custom_sizedbox.dart';
import '../../../widgets/shimmer/shimmer_grid_pagination.dart';
import 'add_sales.dart';

class DataList extends StatefulWidget {
  const DataList({Key? key}) : super(key: key);

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  ScrollController recommendedScrollController = ScrollController();
  ScrollController allMatchesScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callingListener();
  }

  callingListener() {
    Future.delayed(Duration.zero, () {
      final provider = Provider.of<HomeScreenProvider>(context, listen: false);
      recommendedScrollController.addListener(() {
        if (recommendedScrollController.position.maxScrollExtent ==
                recommendedScrollController.offset &&
            provider.isLoading == false) {
          callingApi();
        }
      });

      allMatchesScrollController.addListener(() {
        if (allMatchesScrollController.position.maxScrollExtent ==
                allMatchesScrollController.offset &&
            provider.isLoading == false) {
          callingApi();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    recommendedScrollController.dispose();
    allMatchesScrollController.dispose();
  }

  callingApi() {
    Future.delayed(Duration.zero, () {
      final homeProvider =
          Provider.of<HomeScreenProvider>(context, listen: false);
      homeProvider.setIsSearching(false);
      if (homeProvider.offset < homeProvider.totalPages!) {
        if (homeProvider.toggleIndex == 0) {
          homeProvider.incrementOffset();
          homeProvider.getRecommended(context, 1, RouterHelper.homeScreen);
        } else {
          homeProvider.incrementOffset();
          homeProvider.getAllMatches(context, 1, RouterHelper.homeScreen);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (context, controller, child) {
      return Expanded(
        child: controller.toggleIndex == 0

            // Recommended list
            ? controller.recommendationModel.data == null
                ? ShimmerGrid()
                : controller.recommendationModel.data!.rows!.isEmpty
                    ? AddSales(
                        controller: controller,
                      )
                    : GridView.builder(
                        controller: recommendedScrollController,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.offset < controller.totalPages!
                            ? controller
                                    .recommendationModel.data!.rows!.length +
                                2
                            : controller.recommendationModel.data!.rows!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          crossAxisCount: 2,
                          childAspectRatio: displayWidth(context, 1) /
                              displayHeight(context, 0.64),
                        ),
                        itemBuilder: (context, index) {
                          if (index <
                              controller
                                  .recommendationModel.data!.rows!.length) {
                            final recommendedData = controller
                                .recommendationModel.data!.rows![index];
                            return Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: InkWell(
                                onTap: () {
                                  // carDetailProvider.setAdId(2151105);
                                  // carDetailProvider.setDataId(5);
                                  // controller.setPreferenceId(1);
                                  final carDetailProvider =
                                      Provider.of<CarDetailProvider>(context,
                                          listen: false);

                                  carDetailProvider
                                      .setAdId(recommendedData.adId!);
                                  carDetailProvider
                                      .setDataId(recommendedData.id!);
                                  carDetailProvider.setCarPurchaseIndex(index);
                                  carDetailProvider.setSelectedScreen(1);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height:
                                                displayHeight(context, 0.20),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: primaryGrey
                                                    .withOpacity(0.5)),
                                            child: Image.network(
                                              recommendedData.image!,
                                              alignment: Alignment.bottomCenter,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
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
                                              width:
                                                  displayWidth(context, 0.45),
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
                                                                recommendedData
                                                                    .adId!,
                                                                RouterHelper
                                                                    .homeScreen)
                                                            .then((value) {
                                                          recommendedData
                                                                      .isFavourite ==
                                                                  0
                                                              ? recommendedData
                                                                      .isFavourite =
                                                                  1
                                                              : recommendedData
                                                                  .isFavourite = 0;
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Icon(
                                                          Icons.star,
                                                          size: 18,
                                                          color: recommendedData
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
                                                            recommendedData
                                                                .adId!);

                                                        if (recommendedData
                                                                .isPurchase ==
                                                            0) {
                                                          controller
                                                              .markAsPurchasedModel
                                                              .error = null;
                                                          customDialog(
                                                              context: context,
                                                              adId:
                                                                  recommendedData
                                                                      .adId,
                                                              screenID: 1,
                                                              title:
                                                                  purchasePrice,
                                                              index: index);
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        // width: 95,
                                                        decoration:
                                                            BoxDecoration(
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
                                                              child: recommendedData
                                                                          .isPurchase ==
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
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        WidthSizedBox(
                                                                            context,
                                                                            0.004),
                                                                        Text(
                                                                          "Purchased",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: textStyle(
                                                                              fontSize: 10,
                                                                              color: primaryWhite,
                                                                              fontFamily: latoRegular),
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
                                                "${recommendedData.make ?? " "} ${recommendedData.model ?? " "}",

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
                                                "AU\$ ${recommendedData.price ?? " "} ",
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyle(
                                                    fontSize: 14,
                                                    color: primaryBlack,
                                                    fontFamily: latoRegular),
                                              ),
                                              HeightSizedBox(context, 0.002),
                                              Text(
                                                "${recommendedData.source ?? ""}${recommendedData.source == null ? "" : " | "}"
                                                " ${recommendedData.year ?? ""}${recommendedData.year == null ? "" : " | "}"
                                                "${recommendedData.kmDriven ?? ""}${recommendedData.kmDriven == null ? " " : "km | "}"
                                                "${recommendedData.fuelType ?? ""}",
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
                        })

            // ========================================================================================
            // All matches list
            : controller.allMatchesModel.data == null
                ? ShimmerGrid()
                : controller.allMatchesModel.data!.rows!.isEmpty
                    ? AddSales(
                        controller: controller,
                      )
                    : GridView.builder(
                        controller: allMatchesScrollController,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.offset < controller.totalPages!
                            ? controller.allMatchesModel.data!.rows!.length + 2
                            : controller.allMatchesModel.data!.rows!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          crossAxisCount: 2,
                          childAspectRatio: displayWidth(context, 1) /
                              displayHeight(context, 0.64),
                        ),
                        itemBuilder: (context, index) {
                          if (index <
                              controller.allMatchesModel.data!.rows!.length) {
                            final matchesData =
                                controller.allMatchesModel.data!.rows![index];

                            return Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: InkWell(
                                onTap: () {
                                  final carDetailProvider =
                                      Provider.of<CarDetailProvider>(context,
                                          listen: false);

                                  carDetailProvider.setAdId(matchesData.adId!);
                                  carDetailProvider.setDataId(matchesData.id!);
                                  carDetailProvider.setCarPurchaseIndex(index);
                                  carDetailProvider.setSelectedScreen(1);
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
                                        offset: const Offset(
                                            1, 1), // changes position of shadow
                                      ),
                                    ],
                                    // color: Colors.red,
                                    color: cardGreyColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height:
                                                displayHeight(context, 0.20),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: primaryGrey
                                                    .withOpacity(0.5)),
                                            child: Image.network(
                                              matchesData.image!,
                                              alignment: Alignment.bottomCenter,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                  Images.errorCar,
                                                  scale: 5,
                                                );
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            child: SizedBox(
                                              height: 40,
                                              width:
                                                  displayWidth(context, 0.45),
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
                                                                matchesData
                                                                    .adId!,
                                                                RouterHelper
                                                                    .homeScreen)
                                                            .then((value) {
                                                          matchesData.isFavourite ==
                                                                  0
                                                              ? matchesData
                                                                      .isFavourite =
                                                                  1
                                                              : matchesData
                                                                  .isFavourite = 0;
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Icon(
                                                          Icons.star,
                                                          size: 18,
                                                          color: matchesData
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
                                                            matchesData.adId!);

                                                        if (matchesData
                                                                .isPurchase ==
                                                            0) {
                                                          controller
                                                              .markAsPurchasedModel
                                                              .error = null;
                                                          customDialog(
                                                              context: context,
                                                              adId: matchesData
                                                                  .adId,
                                                              screenID: 1,
                                                              title:
                                                                  purchasePrice,
                                                              index: index);
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        // width: 95,
                                                        decoration:
                                                            BoxDecoration(
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
                                                              child:

                                                                  /////////////////////////////////////

                                                                  matchesData.isPurchase ==
                                                                          0
                                                                      ? Text(
                                                                          btnMarkAsPurchased,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: textStyle(
                                                                              fontSize: 10,
                                                                              color: primaryWhite,
                                                                              fontFamily: latoRegular),
                                                                        )
                                                                      : Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.check_circle,
                                                                              size: 12,
                                                                              color: Colors.white,
                                                                            ),
                                                                            WidthSizedBox(context,
                                                                                0.004),
                                                                            Text(
                                                                              "Purchased",
                                                                              textAlign: TextAlign.center,
                                                                              style: textStyle(fontSize: 10, color: primaryWhite, fontFamily: latoRegular),
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
                                                "${matchesData.make ?? " "} ${matchesData.model ?? " "}",

                                                //"Ford Thunderdbird",
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyle(
                                                    fontSize: 15,
                                                    color: primaryBlue,
                                                    fontFamily: latoRegular),
                                              ),
                                              HeightSizedBox(context, 0.002),
                                              Text(
                                                // "AU\$ 15000 ",
                                                "AU\$ ${matchesData.price ?? " "} ",
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                style: textStyle(
                                                    fontSize: 14,
                                                    color: primaryBlack,
                                                    fontFamily: latoRegular),
                                              ),
                                              HeightSizedBox(context, 0.002),
                                              Text(
                                                "${matchesData.source ?? ""}${matchesData.source == null ? "" : " | "}"
                                                " ${matchesData.year ?? ""}${matchesData.year == null ? "" : " | "}"
                                                "${matchesData.kmDriven ?? ""}${matchesData.kmDriven == null ? " " : "km | "}"
                                                "${matchesData.fuelType ?? ""}",
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
                        }),
      );
    });
  }
}
