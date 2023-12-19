import 'dart:io';

import 'package:caroogle/providers/inventory_add_new_provider.dart';
import 'package:caroogle/providers/inventory_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/screens/inventory_screen/components/add_new_toggle_button.dart';
import 'package:caroogle/view/widgets/bottom_navigation.dart';
import 'package:caroogle/view/widgets/custom_floating_action_button.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../widgets/named_app_bar.dart';
import 'components/inventory_add_manually.dart';
import 'components/inventory_upload_csv.dart';

class InventoryAddNewScreen extends StatelessWidget {
  const InventoryAddNewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: SafeArea(
        bottom: Platform.isAndroid ? true : false,
        top: Platform.isAndroid ? true : false,
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          appBar:
              namedAppBar(context: context, title: addNew, color: primaryWhite),
          backgroundColor: primaryWhite,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Consumer<InventoryProvider>(
                    builder: (context, controller, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeightSizedBox(context, 0.02),
                      const AddNewToggleButton(),
                      HeightSizedBox(context, 0.02),
                      controller.addNewToggleValue == 0
                          ? const InventoryAddManually()
                          : const InventoryUploadCSV(),
                      HeightSizedBox(context, 0.02),
                    ],
                  );
                }),
              ),
            ),
          ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: !isKeyboard
          //     ? CustomFloatingActionButton(page: 3)
          //     : const SizedBox(),
          // bottomNavigationBar: const BottomNavigation()
        ),
      ),
    );
  }
}
