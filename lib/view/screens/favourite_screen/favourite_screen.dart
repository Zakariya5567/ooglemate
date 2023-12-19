import 'dart:io';

import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/david_recommendataion_screen_provider.dart';
import 'package:caroogle/providers/favourite_provider.dart';
import 'package:caroogle/providers/global_search_provider.dart';
import 'package:caroogle/providers/home_screen_provider.dart';
import 'package:caroogle/view/widgets/named_app_bar.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../widgets/custom_sizedbox.dart';
import '../../widgets/no_data_found.dart';
import '../../widgets/shimmer/shimmer_grid_pagination.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
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
      // if value = 0 its mean first time we are getting data
      // if value = 1 its mean we are doing pagination

      callingApi(0);

      // instance of the FavouriteProvider

      final provider = Provider.of<FavouriteProvider>(context, listen: false);

      // set loading true to display shimmer
      provider.setLoading(true);
      // add listener
      scrollController.addListener(() {
        // check if the scroll position matched with screen bottom offset and isLoading is false
        // then we will call api for pagination

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
      // instance of the FavouriteProvider
      final provider = Provider.of<FavouriteProvider>(context, listen: false);
      if (isPagination == 0) {
        // clear the offset of the pagination
        provider.clearOffset();

        // calling api
        provider.getFavourites(context, 0, RouterHelper.trackedCarScreen);

        // to check if pagination and the current page less then total pages
      } else if (isPagination == 1 && provider.offset < provider.totalPages!) {
        // increment offset
        provider.incrementOffset();

        // calling api
        provider.getFavourites(context, 1, RouterHelper.trackedCarScreen);
      }
    });
  }

  // On Page refresh
  Future<void> onRefresh() async {
    // Your refresh logic goes here

    // instance of the FavouriteProvider

    final provider = Provider.of<FavouriteProvider>(context, listen: false);
    await Future.delayed(Duration.zero, () {
      // clear the offset of the pagination
      provider.clearOffset();

      // calling api
      provider.getFavourites(context, 0, RouterHelper.trackedCarScreen);
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
            appBar: namedAppBar(
              context: context,
              title: favourites,
              color: primaryWhite,
            ),
            backgroundColor: primaryWhite,
            body: Consumer<FavouriteProvider>(
                builder: (context, controller, child) {
              // check if loading is true then we will show shimmer
              // api response data is null then we will show no data found

              return controller.isLoading == true
                  ? ShimmerGrid(pagination: 0)
                  : RefreshIndicator(
                      onRefresh: onRefresh,
                      child: controller.favouriteModel.data == null ||
                              controller.favouriteModel.data!.rows!.isEmpty
                          ? const NoDataFound()
                          : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GridView.builder(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),

                                  // the check is use for pagination
                                  // if current page less then total pages then we will set length + 2 to show shimmer at end of the screen

                                  itemCount: controller.offset <
                                          controller.totalPages!
                                      ? controller.favouriteModel.data!.rows!
                                              .length +
                                          2
                                      : controller
                                          .favouriteModel.data!.rows!.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
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
                                        controller.favouriteModel.data!.rows!
                                            .length) {
                                      final data = controller
                                          .favouriteModel.data!.rows![index];
                                      return Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 4,
                                                offset: const Offset(1,
                                                    1), // changes position of shadow
                                              ),
                                            ],
                                            color: cardGreyColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    height: displayHeight(
                                                        context, 0.20),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: primaryGrey
                                                            .withOpacity(0.5)),
                                                    child: Image.network(
                                                      data.image!,
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (BuildContext context,
                                                              Object exception,
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
                                                    top: 0,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            // set api response null

                                                            controller
                                                                .markAsFavouriteModel
                                                                .error = null;

                                                            // calling api
                                                            controller
                                                                .markAsFavourite(
                                                                    context,
                                                                    data.adId!,
                                                                    RouterHelper
                                                                        .preferencesScreen)
                                                                .then((value) {
                                                              // delete item from the index

                                                              controller
                                                                  .deleteItem(
                                                                      index);

                                                              // instance of the home provider
                                                              // to un mark favourite icon from the listed item

                                                              Provider.of<HomeScreenProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .favouriteDeleteById(
                                                                      data.adId!);

                                                              // instance of the David Recommendation Screen Provider
                                                              // to un mark favourite icon from the listed item
                                                              Provider.of<DavidRecommendationScreenProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .favouriteDeleteById(
                                                                      data.adId!);

                                                              // instance of the GlobalScreenProvider
                                                              // to un mark favourite icon from the listed item

                                                              Provider.of<GlobalScreenProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .favouriteDeleteById(
                                                                      data.adId!);
                                                            });
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: Icon(
                                                                Icons.star,
                                                                size: 18,
                                                                color:
                                                                    primaryYellow),
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
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${data.make ?? " "} ${data.model ?? " "}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: textStyle(
                                                            fontSize: 15,
                                                            color: primaryBlue,
                                                            fontFamily:
                                                                latoRegular),
                                                      ),
                                                      HeightSizedBox(
                                                          context, 0.002),
                                                      Text(
                                                        "AU\$ ${data.price ?? " "}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: textStyle(
                                                            fontSize: 14,
                                                            color: primaryBlack,
                                                            fontFamily:
                                                                latoRegular),
                                                      ),
                                                      HeightSizedBox(
                                                          context, 0.002),
                                                      Text(
                                                        "${data.source ?? ""}${data.source == null ? "" : " | "}"
                                                        " ${data.year ?? ""}${data.year == null ? "" : " | "}"
                                                        "${data.kmDriven ?? ""}${data.kmDriven == null ? " " : "km | "}"
                                                        "${data.fuelType ?? ""}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: textStyle(
                                                            fontSize: 10,
                                                            color: primaryBlack,
                                                            fontFamily:
                                                                latoRegular),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
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
                            ));
            })),
      ),
    );
  }
}
