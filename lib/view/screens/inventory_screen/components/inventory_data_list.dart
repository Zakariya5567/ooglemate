import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:caroogle/data/models/inventories/inventory_mapping_model.dart';
import 'package:caroogle/helper/csv_generator.dart';
import 'package:caroogle/providers/home_screen_provider.dart';
import 'package:caroogle/providers/inventory_car_detail_provider.dart';
import 'package:caroogle/providers/inventory_provider.dart';
import 'package:caroogle/providers/search_filter_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/images.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../../../../helper/routes_helper.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/style.dart';
import '../../../widgets/no_data_found.dart';

class InventoryDataList extends StatefulWidget {
  const InventoryDataList({Key? key}) : super(key: key);

  @override
  State<InventoryDataList> createState() => _InventoryDataListState();
}

class _InventoryDataListState extends State<InventoryDataList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callingListener();
  }

  callingListener() {
    Future.delayed(Duration.zero, () {
      final provider = Provider.of<InventoryProvider>(context, listen: false);
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
    Future.delayed(Duration.zero, () {
      final provider = Provider.of<InventoryProvider>(context, listen: false);
      if (provider.offset < provider.totalPages!) {
        provider.setIsSearching(false);
        provider.incrementOffset();
        provider.getAllInventories(context, 1, RouterHelper.inventoryScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(builder: (context, controller, child) {
      return controller.inventoryModel.data!.rows!.isEmpty
          ? const Expanded(child: NoDataFound())
          : Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.inventoryModel.data!.rows!.length + 1,
                  itemBuilder: (context, index) {
                    if (index < controller.inventoryModel.data!.rows!.length) {
                      final data = controller.inventoryModel.data!.rows![index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: InkWell(
                          onTap: () {
                            final carDetailProvider =
                                Provider.of<InventoryCarDetailProvider>(context,
                                    listen: false);
                            carDetailProvider.setAdId(data.adId!);
                            carDetailProvider.setInventoryId(data.id!);
                            Navigator.of(context).pushNamed(
                                RouterHelper.inventoryCarDetailScreen);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: const Offset(-4, 4),
                                ),
                              ],
                              color: cardGreyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: displayHeight(context, 0.14),
                                  width: displayWidth(context, 0.32),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: primaryGrey.withOpacity(0.5)),
                                  child: Image.network(
                                    data.image == null ? "null" : data.image!,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 15),
                                  child: SizedBox(
                                    width: displayWidth(context, 0.55),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${data.make ?? " "} ${data.model ?? " "}",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: textStyle(
                                              fontSize: 15,
                                              color: primaryBlue,
                                              fontFamily: latoRegular),
                                        ),
                                        HeightSizedBox(context, 0.01),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              data.sellingPrice == null
                                                  ? const SizedBox()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Sold price",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: textStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  primaryGrey,
                                                              fontFamily:
                                                                  latoRegular),
                                                        ),
                                                        HeightSizedBox(
                                                            context, 0.005),
                                                        Text(
                                                          "${data.sellingPrice == null ? " " : "AU\$"} ${data.sellingPrice ?? " "} ",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: textStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  primaryBlack,
                                                              fontFamily:
                                                                  latoRegular),
                                                        ),
                                                      ],
                                                    ),
                                              data.sellingPrice == null
                                                  ? const SizedBox()
                                                  : WidthSizedBox(
                                                      context, 0.01),
                                              data.purchasePrice == null
                                                  ? const SizedBox()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Purchased price",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: textStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  primaryGrey,
                                                              fontFamily:
                                                                  latoRegular),
                                                        ),
                                                        HeightSizedBox(
                                                            context, 0.005),
                                                        Text(
                                                          "${data.purchasePrice == null ? " " : "AU\$"} ${data.purchasePrice ?? " "} ",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: textStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  primaryBlack,
                                                              fontFamily:
                                                                  latoRegular),
                                                        ),
                                                      ],
                                                    )
                                            ],
                                          ),
                                        ),
                                        HeightSizedBox(context, 0.01),
                                        Text(
                                          "${data.source ?? ""}${data.source == null ? "" : " | "}"
                                          " ${data.year ?? ""}${data.year == null ? "" : " | "}"
                                          "${data.kmDriven ?? ""}${data.kmDriven == null ? " " : "km | "}"
                                          "${data.fuelType ?? ""}",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: textStyle(
                                              fontSize: 10,
                                              color: primaryGrey,
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
                        height: controller.isPagination == true
                            ? displayHeight(context, 0.3)
                            : 120,
                        width: displayWidth(context, 1),
                        color: primaryWhite,
                        child: controller.isPagination == true
                            ? ShimmerList(pagination: 1)
                            : const SizedBox(),
                      );
                    }
                  }),
            );
    });
  }
}
