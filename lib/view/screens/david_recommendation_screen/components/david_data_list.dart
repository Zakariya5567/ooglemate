import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/car_detail_provider.dart';
import 'package:caroogle/providers/david_recommendataion_screen_provider.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/dimension.dart';
import '../../../../../utils/images.dart';
import '../../../../../utils/string.dart';
import '../../../../../utils/style.dart';
import '../../../widgets/custom_dialog_box.dart';
import '../../../widgets/custom_sizedbox.dart';
import '../../../widgets/no_data_found.dart';
import '../../../widgets/shimmer/shimmer_grid_pagination.dart';

class DavidDataList extends StatefulWidget {
  const DavidDataList({Key? key}) : super(key: key);

  @override
  State<DavidDataList> createState() => _DavidDataListState();
}

class _DavidDataListState extends State<DavidDataList> {
  //instance of the scroll listener to listen for list scroll
  //use for pagination
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callingListener();
  }

  // To listen the scroll of the list
  callingListener() {
    Future.delayed(Duration.zero, () {
      // instance of the provider class
      final provider = Provider.of<DavidRecommendationScreenProvider>(context,
          listen: false);

      // add listener
      scrollController.addListener(() {
        // check if the scroll position matched with screen bottom offset and isLoading is false
        // then we will call api for pagination

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

    // To dispose scroll listener
    scrollController.dispose();
  }

  callingApi() {
    Future.delayed(Duration.zero, () {
      // instance of the provider
      final davidProvider = Provider.of<DavidRecommendationScreenProvider>(
          context,
          listen: false);

      // set searching false because we are not searching
      davidProvider.setIsSearching(false);

      // check if the current page is less then total pages
      // offset is the current page

      if (davidProvider.offset < davidProvider.totalPages!) {
        // increment offset
        davidProvider.incrementOffset();

        // calling api to get data
        davidProvider.getDavidRecommended(
            context, 1, RouterHelper.davidRecommendationScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DavidRecommendationScreenProvider>(
        builder: (context, controller, child) {
      return Expanded(
        // api response data is null the we will show shimmer
        // api response data list is empty then we will show no data found
        child: controller.davidRecommendationModel.data == null
            ? ShimmerGrid()
            : controller.davidRecommendationModel.data!.rows!.isEmpty
                ? const NoDataFound()
                : GridView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),

                    // the check is use for pagination
                    // if current page less then total pages then we will set length + 2 to show shimmer at end of the screen
                    itemCount: controller.offset < controller.totalPages!
                        ? controller
                                .davidRecommendationModel.data!.rows!.length +
                            2
                        : controller
                            .davidRecommendationModel.data!.rows!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: displayWidth(context, 1) /
                          displayHeight(context, 0.64),
                    ),
                    itemBuilder: (context, index) {
                      // check if index less the api length list then we will show actual data
                      // if length greater then the api list length then we will show pagination shimmer

                      if (index <
                          controller
                              .davidRecommendationModel.data!.rows!.length) {
                        final davidData = controller
                            .davidRecommendationModel.data!.rows![index];
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: InkWell(
                            onTap: () {
                              // instance of the car detail provider
                              final carDetailProvider =
                                  Provider.of<CarDetailProvider>(context,
                                      listen: false);

                              // set ad id
                              carDetailProvider.setAdId(davidData.adId!);

                              // set car purchase car index
                              carDetailProvider.setCarPurchaseIndex(index);

                              // set screen id
                              carDetailProvider.setSelectedScreen(2);

                              // navigation to car detail screen
                              Navigator.of(context)
                                  .pushNamed(RouterHelper.carDetailScreen);
                            },
                            child: Container(
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
                                          davidData.image!,
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
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: SizedBox(
                                          height: 40,
                                          width: displayWidth(context, 0.45),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    // calling api to make car favourite

                                                    controller
                                                        .markAsFavourite(
                                                            context,
                                                            davidData.adId!,
                                                            RouterHelper
                                                                .homeScreen)
                                                        .then((value) {
                                                      // to set the value locally 0 and 1 after calling api
                                                      davidData.isFavourite == 0
                                                          ? davidData
                                                              .isFavourite = 1
                                                          : davidData
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
                                                      color: davidData
                                                                  .isFavourite ==
                                                              1
                                                          ? primaryYellow
                                                          : primaryWhite,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    // instance of car detail provider
                                                    final isHideProvider = Provider
                                                        .of<CarDetailProvider>(
                                                            context,
                                                            listen: false);

                                                    // set validation false
                                                    isHideProvider
                                                        .setHide(false);

                                                    //  set ad id
                                                    controller.setAdId(
                                                        davidData.adId!);

                                                    // To check the car is already purchased or not "1 for purchased , 0 for not"
                                                    // if the car is already purchased then we will not show dialog box
                                                    if (davidData.isPurchased ==
                                                        0) {
                                                      controller
                                                          .markAsPurchasedModel
                                                          .error = null;
                                                      customDialog(
                                                          context: context,
                                                          adId: davidData.adId,
                                                          screenID: 4,
                                                          title: purchasePrice,
                                                          index: index);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    // width: 95,
                                                    decoration: BoxDecoration(
                                                      color: lightGrey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                          child: davidData
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
                                                                      size: 12,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    WidthSizedBox(
                                                                        context,
                                                                        0.004),
                                                                    Text(
                                                                      "Purchased",
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
                                            "${davidData.make ?? " "} ${davidData.model ?? " "}",
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            style: textStyle(
                                                fontSize: 15,
                                                color: primaryBlue,
                                                fontFamily: latoRegular),
                                          ),
                                          HeightSizedBox(context, 0.002),
                                          Text(
                                            "AU\$ ${davidData.price ?? " "} ",
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            style: textStyle(
                                                fontSize: 14,
                                                color: primaryBlack,
                                                fontFamily: latoRegular),
                                          ),
                                          HeightSizedBox(context, 0.002),
                                          Text(
                                            "${davidData.source ?? ""}${davidData.source == null ? "" : " | "}"
                                            " ${davidData.year ?? ""}${davidData.year == null ? "" : " | "}"
                                            "${davidData.kmDriven ?? ""}${davidData.kmDriven == null ? " " : "km | "}"
                                            "${davidData.fuelType ?? ""}",
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
                        //  if the pagination loading is true then we will show pagination shimmer
                        return controller.isPagination == true
                            ? const ShimmerGridPagination()
                            : const SizedBox();
                      }
                    }),
      );
    });
  }
}
