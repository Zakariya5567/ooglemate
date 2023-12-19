import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/home_screen_provider.dart';
import 'package:caroogle/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/preferences_add_data_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_sizedbox.dart';

class AddSales extends StatelessWidget {
  AddSales({required this.controller});
  HomeScreenProvider controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            HeightSizedBox(context, 0.06),
            Image.asset(
              Images.cap,
              scale: 4.5,
            ),
            HeightSizedBox(context, 0.02),
            Text(
              oops,
              style: textStyle(
                  fontSize: 22, color: primaryBlack, fontFamily: rubikMedium),
            ),
            HeightSizedBox(context, 0.02),
            Consumer<PreferencesProvider>(
                builder: (context, prefProvider, child) {
              return Text(
                prefProvider.allPreferencesModel.data?.rows != null
                    ? "We got your sales data, waiting for your interested cars in market"
                    : noDataMessage,
                textAlign: TextAlign.center,
                style: textStyle(
                    fontSize: 18, color: primaryGrey, fontFamily: rubikRegular),
              );
            }),
            HeightSizedBox(context, 0.08),
            CustomButton(
              buttonName: btnAddSalesData,
              onPressed: () {
                final prefProvider = Provider.of<PreferencesAddDataProvider>(
                    context,
                    listen: false);
                prefProvider.setHide(false);
                Navigator.of(context)
                    .pushNamed(RouterHelper.preferencesAddDataScreen);
              },
              buttonGradient: gradientBlue,
              buttonTextColor: primaryWhite,
              padding: 20,
            )
          ],
        ),
      ],
    );
  }
}
