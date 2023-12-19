import 'dart:io';

import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/car_detail_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/utils/style.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/named_app_bar.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/set_trigger_provider.dart';
import '../../widgets/no_data_found.dart';
import 'components/image_section.dart';
import 'components/mid_section.dart';
import 'components/purchase_detial.dart';

class CarDetailScreen extends StatefulWidget {
  CarDetailScreen({Key? key, this.adId}) : super(key: key);

  int? adId;

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  @override
  void initState() {
    super.initState();
    callingApi();
  }

  callingApi() {
    Future.delayed(Duration.zero, () {
      // instance of the car detail provider
      final provider = Provider.of<CarDetailProvider>(context, listen: false);

      // set loading true to display a shimmer
      provider.setLoading(true);

      // calling api
      provider.getCarDetail(
          context, widget.adId ?? provider.adId!, RouterHelper.carDetailScreen);
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
          appBar:
              namedAppBar(context: context, title: cars, color: primaryWhite),
          backgroundColor: primaryWhite,
          body: Consumer<CarDetailProvider>(
              builder: (context, controller, child) {
            // check if loading is true then we will show shimmer
            // api response data is null then we will show no data found
            return controller.isLoading == true
                ? const ShimmerDetail()
                : controller.carDetailModel.data == null
                    ? const NoDataFound()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // image section of the screen
                            const ImageSection(),
                            HeightSizedBox(context, 0.02),

                            // middle section of the screen "prediction, track etc"
                            const MidSection(),

                            // list section of the screen
                            const PurchasedDetailList(),
                          ],
                        ),
                      );
          }),

          // Trigger button
          bottomNavigationBar: BottomAppBar(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: GestureDetector(
                onTap: () {
                  // instance of the trigger provider class
                  final setTriggerProvider =
                      Provider.of<SetTriggerProvider>(context, listen: false);

                  // when we navigate to trigger screen from the detail screen we will show pre populated data in text field

                  // to set pre populated 1, mean we are navigating from detail screen and we will will pre populated data
                  setTriggerProvider.setPrepopulate(1);

                  // Hide false to hide validation
                  setTriggerProvider.setHide(false);

                  // navigate to trigger screen

                  Navigator.of(context)
                      .pushNamed(RouterHelper.setTriggerScreen);
                },
                child: Container(
                  height: 50,
                  width: displayWidth(context, 1),
                  decoration: BoxDecoration(
                      gradient: gradientBlue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      btnAddTrigger,
                      style: textStyle(
                          fontSize: 14,
                          color: primaryWhite,
                          fontFamily: latoRegular),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
