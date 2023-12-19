import 'dart:io';
import 'package:caroogle/providers/preferences_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/screens/preferences_screen/components/add_manually.dart';
import 'package:caroogle/view/screens/preferences_screen/components/preferences_toggle_button.dart';
import 'package:caroogle/view/screens/preferences_screen/components/upload_csv.dart';
import 'package:caroogle/view/widgets/bottom_navigation.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/bottom_navigation_provider.dart';
import '../../../utils/style.dart';
import '../../widgets/pictured_app_bar.dart';

class PreferencesAddDataScreen extends StatefulWidget {
  PreferencesAddDataScreen({Key? key}) : super(key: key);

  @override
  State<PreferencesAddDataScreen> createState() =>
      _PreferencesAddDataScreenState();
}

class _PreferencesAddDataScreenState extends State<PreferencesAddDataScreen> {
  @override
  void initState() {
    super.initState();
    callingApi();
  }

  callingApi() {
    Future.delayed(Duration.zero, () {
      final navigationProvider =
          Provider.of<BottomNavigationProvider>(context, listen: false);
      navigationProvider.setNavigationIndex(context, 1);
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
            //resizeToAvoidBottomInset: true,
            backgroundColor: primaryWhite,
            appBar: picturedAppBar(
                context: context, title: preferences, page: 2, isSearch: 0),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Consumer<PreferencesProvider>(
                      builder: (context, controller, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeightSizedBox(context, 0.02),
                        const PreferencesToggleButton(),
                        HeightSizedBox(context, 0.02),
                        controller.toggleValue == 0
                            ? AddManually()
                            : UploadCSV()
                      ],
                    );
                  }),
                ),
              ),
            ),
            bottomNavigationBar: const BottomNavigation()),
      ),
    );
  }

  Widget dataList(
    BuildContext context,
    String title1,
    String data1,
    String title2,
    String data2,
    String title3,
    String data3,
  ) {
    return Row(
      children: [
        Text(
          title1,
          textAlign: TextAlign.center,
          style: textStyle(
              fontSize: 10, color: primaryBlack, fontFamily: latoBold),
        ),
        WidthSizedBox(context, 0.003),
        Text(
          data1,
          textAlign: TextAlign.center,
          style: textStyle(
              fontSize: 10, color: primaryBlack, fontFamily: latoRegular),
        ),
        WidthSizedBox(context, 0.003),
        Text(
          "|",
          textAlign: TextAlign.center,
          style: textStyle(
              fontSize: 10, color: primaryBlack, fontFamily: latoBold),
        ),
        WidthSizedBox(context, 0.003),
        Text(
          title2,
          textAlign: TextAlign.center,
          style: textStyle(
              fontSize: 10, color: primaryBlack, fontFamily: latoBold),
        ),
        WidthSizedBox(context, 0.003),
        Text(
          data2,
          textAlign: TextAlign.center,
          style: textStyle(
              fontSize: 10, color: primaryBlack, fontFamily: latoRegular),
        ),
        WidthSizedBox(context, 0.003),
        Text(
          "|",
          textAlign: TextAlign.center,
          style: textStyle(
              fontSize: 10, color: primaryBlack, fontFamily: latoBold),
        ),
        WidthSizedBox(context, 0.003),
        Text(
          title3,
          textAlign: TextAlign.center,
          style: textStyle(
              fontSize: 10, color: primaryBlack, fontFamily: latoBold),
        ),
        WidthSizedBox(context, 0.003),
        Text(
          data3,
          textAlign: TextAlign.center,
          style: textStyle(
              fontSize: 10, color: primaryBlack, fontFamily: latoRegular),
        ),
        WidthSizedBox(context, 0.003),
      ],
    );
  }
}
