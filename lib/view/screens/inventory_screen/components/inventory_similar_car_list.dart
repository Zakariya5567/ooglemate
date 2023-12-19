import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/car_detail_provider.dart';
import '../../../../providers/inventory_car_detail_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_sizedbox.dart';
import '../../../widgets/shimmer/shimmer_horizantal_list.dart';

class SimilarCarList extends StatefulWidget {
  const SimilarCarList({Key? key}) : super(key: key);

  @override
  State<SimilarCarList> createState() => _SimilarCarListState();
}

class _SimilarCarListState extends State<SimilarCarList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<InventoryCarDetailProvider>(context, listen: false);

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          provider.isLoading == false) {
        callingApi(1);
      }
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

    final provider =
        Provider.of<InventoryCarDetailProvider>(context, listen: false);

    Future.delayed(Duration.zero).then((value) {
      if (isPagination == 1 && provider.offset < provider.totalPages!) {
        provider.incrementOffset();
        provider.getSimilarCar(
            context, 1, RouterHelper.inventoryCarDetailScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryCarDetailProvider>(
        builder: (context, controller, child) {
      return controller.isLoading == true ||
              controller.similarCarModel.data == null
          ? ShimmerHorizantalList(
              pagination: 0,
            )
          : controller.similarCarModel.data!.rows!.isEmpty
              ? const SizedBox()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        similarCars,
                        textAlign: TextAlign.start,
                        style: textStyle(
                            fontSize: 16,
                            color: darkGrey,
                            fontFamily: latoBold),
                      ),
                    ),
                    HeightSizedBox(context, 0.02),
                    SizedBox(
                      height: displayHeight(context, 0.31),
                      width: displayWidth(context, 1),
                      child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const ScrollPhysics(),
                          itemCount:
                              controller.similarCarModel.data!.rows!.length + 1,
                          itemBuilder: (context, index) {
                            if (index <
                                controller.similarCarModel.data!.rows!.length) {
                              final data =
                                  controller.similarCarModel.data!.rows![index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 08.0, vertical: 5),
                                child: InkWell(
                                  onTap: () {
                                    final carDetailProvider =
                                        Provider.of<CarDetailProvider>(context,
                                            listen: false);
                                    carDetailProvider.setAdId(data!.adId!);
                                    carDetailProvider.setSelectedScreen(3);
                                    Navigator.of(context).pushNamed(
                                        RouterHelper.carDetailScreen);
                                  },
                                  child: Container(
                                    height: displayHeight(context, 0.20),
                                    width: displayWidth(context, 0.45),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: const Offset(1,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                      color: cardGreyColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: displayHeight(context, 0.20),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: primaryGrey.withOpacity(0.5),
                                          ),
                                          child: Image.network(
                                            data!.image!,
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
                                                  "${data.make ?? " "} ${data.model ?? " "}",
                                                  //"Ford Thunderdbird",
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: textStyle(
                                                      fontSize: 15,
                                                      color: primaryBlue,
                                                      fontFamily: latoRegular),
                                                ),
                                                HeightSizedBox(context, 0.002),
                                                Text(
                                                  "${data.price == null ? " " : "AU\$"} ${data.price ?? " "} ",
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: textStyle(
                                                      fontSize: 14,
                                                      color: primaryBlack,
                                                      fontFamily: latoRegular),
                                                ),
                                                HeightSizedBox(context, 0.002),
                                                Text(
                                                  "${data.source ?? ""}${data.source == null ? "" : " | "}"
                                                  " ${data.year ?? ""}${data.year == null ? "" : " | "}"
                                                  "${data.kmDriven ?? ""}${data.kmDriven == null ? " " : "km | "}"
                                                  "${data.fuelType ?? ""}",
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                              return Container(
                                  height: displayHeight(context, 0.3),
                                  width: controller.isPagination == true
                                      ? displayWidth(context, 1)
                                      : 100,
                                  color: primaryWhite,
                                  child: controller.isPagination == true
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ShimmerHorizantalList(
                                            pagination: 1,
                                          ))
                                      : const SizedBox());
                            }
                          }),
                    )
                  ],
                );
    });
  }
}
