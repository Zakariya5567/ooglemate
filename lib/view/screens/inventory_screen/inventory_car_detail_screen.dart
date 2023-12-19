import 'dart:io';

import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/inventory_car_detail_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/utils/style.dart';
import 'package:caroogle/view/screens/inventory_screen/components/inventory_car_detail_image_section.dart';
import 'package:caroogle/view/screens/inventory_screen/components/inventory_similar_car_list.dart';
import 'package:caroogle/view/screens/inventory_screen/components/inventory_sold_detial.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/named_app_bar.dart';
import 'package:caroogle/view/widgets/no_data_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../widgets/circular_progress.dart';
import '../../widgets/shimmer/shimmer_detail.dart';

class InventoryCarDetailScreen extends StatefulWidget {
  const InventoryCarDetailScreen({Key? key}) : super(key: key);

  @override
  State<InventoryCarDetailScreen> createState() =>
      _InventoryCarDetailScreenState();
}

class _InventoryCarDetailScreenState extends State<InventoryCarDetailScreen> {
  @override
  void initState() {
    super.initState();
    callingApi();
  }

  callingApi() {
    Future.delayed(Duration.zero, () {
      final provider =
          Provider.of<InventoryCarDetailProvider>(context, listen: false);
      provider.setLoading(true);
      provider.getCarDetail(
          context, provider.adId!, RouterHelper.carDetailScreen);
      provider.getSimilarCar(context, 0, RouterHelper.inventoryCarDetailScreen);
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
          backgroundColor: cardLightColor,
          appBar: namedAppBar(
              context: context, title: carInventory, color: primaryWhite),
          body: Consumer<InventoryCarDetailProvider>(
              builder: (context, controller, child) {
            return controller.isLoading == true
                ? const ShimmerDetail()
                : controller.carDetailModel.data == null
                    ? const NoDataFound()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const InventoryCarDetailImageSection(),
                            HeightSizedBox(context, 0.02),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${controller.carDetailModel.data!.make} ${controller.carDetailModel.data!.model}",
                                    style: textStyle(
                                        fontSize: 18,
                                        color: primaryBlue,
                                        fontFamily: latoBold),
                                  ),
                                ],
                              ),
                            ),
                            HeightSizedBox(context, 0.02),
                            const InventorySoldDetailList(),
                            HeightSizedBox(context, 0.02),
                            const SimilarCarList(),
                          ],
                        ),
                      );
          }),
        ),
      ),
    );
  }
}
