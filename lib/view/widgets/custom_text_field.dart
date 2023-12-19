import 'package:caroogle/providers/car_detail_provider.dart';
import 'package:caroogle/providers/inventory_add_new_provider.dart';
import 'package:caroogle/providers/preferences_add_data_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/set_trigger_provider.dart';
import '../../utils/images.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    required var this.provider,
    required this.controller,
    required this.title,
    required this.hintText,
    required this.isNumber,
    required this.width,
    required this.fieldType,
  });
  TextEditingController controller = TextEditingController();
  String title;
  String hintText;
  int isNumber;
  double width;
  var provider;
  int fieldType;

  // isNumber == 1 its mean its number  , if  in number == 0 its mean its text
  // fieldType 1 => purchase controller;
  // fieldType 2 => sell controller;
  // fieldType 3 => keyword controller;
  // fieldType 4 => badge controller;
  // fieldType 5 => make year controller;
  // fieldType 6 => km controller;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        width: width,
        decoration: BoxDecoration(
            color: primaryWhite,
            border: Border(
                bottom:
                    BorderSide(color: lightGrey.withOpacity(0.2), width: 1))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: textStyle(
                fontSize: 16, color: primaryBlack, fontFamily: latoBold),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  inputFormatters: [
                    // price value must be 0 - 2 billion
                    // keyword character 0 - 1500
                    // car badge character 0 - 1500
                    // year character 4

                    // Checking for type of data to set input character length according to it
                    fieldType == 1 || fieldType == 2
                        ? LengthLimitingTextInputFormatter(10)
                        : fieldType == 3
                            ? LengthLimitingTextInputFormatter(500)
                            : fieldType == 4
                                ? LengthLimitingTextInputFormatter(150)
                                : fieldType == 5
                                    ? LengthLimitingTextInputFormatter(4)
                                    : LengthLimitingTextInputFormatter(8)
                  ],
                  autofocus: false,
                  controller: controller,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(fontSize: 14),
                  obscureText: false,

                  // checking for keyboard type
                  keyboardType:
                      isNumber == 1 ? TextInputType.number : TextInputType.text,

                  onChanged: (value) {
                    //================================================================================
                    // instance of car detail provider
                    // user to validate text field of the dialog box

                    final dialogBoxProvider =
                        Provider.of<CarDetailProvider>(context, listen: false);

                    // Set the validation error false
                    dialogBoxProvider.setHide(false);

                    //================================================================================
                    // instance of car SetTriggerProvider
                    final setTriggerProvider =
                        Provider.of<SetTriggerProvider>(context, listen: false);

                    // checking for text field to validate text
                    // if text field controller matched
                    if (controller == setTriggerProvider.keyWordsController ||
                        controller == setTriggerProvider.carBadgeController) {
                      // set validation
                      setTriggerProvider.setTextFieldValidationValue();
                    }

                    //================================================================================
                    // instance of car PreferencesAddDataProvider
                    final prefProvider =
                        Provider.of<PreferencesAddDataProvider>(context,
                            listen: false);
                    // checking for text field to validate text
                    // if text field controller matched
                    if (controller == prefProvider.sellPriceController ||
                        controller == prefProvider.purchasePriceController ||
                        controller == prefProvider.makeYearController ||
                        controller == prefProvider.carBadgeController) {
                      // set validation
                      prefProvider.setTextFieldValidationValue();
                    }

                    //================================================================================
                    // instance of car InventoryAddNewProvider

                    final inventoryProvider =
                        Provider.of<InventoryAddNewProvider>(context,
                            listen: false);

                    // checking for text field to validate text
                    // if text field controller matched
                    if (controller == inventoryProvider.sellPriceController ||
                        controller ==
                            inventoryProvider.purchasePriceController ||
                        controller == inventoryProvider.makeYearController ||
                        controller == inventoryProvider.carBadgeController ||
                        controller == inventoryProvider.kmController ||
                        controller == inventoryProvider.keyWordsController) {
                      // set validation
                      inventoryProvider.setTextFieldValidationValue();
                    }
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(fontSize: 12),
                    fillColor: primaryWhite,
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: hintText,
                    hintStyle: textStyle(
                        fontSize: 12,
                        color: lightGrey,
                        fontFamily: latoRegular),
                    contentPadding: EdgeInsets.zero,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              const ImageIcon(
                AssetImage(Images.iconDropdown),
                size: 15,
                color: primaryWhite,
              )
            ],
          ),
        ]));
  }
}
