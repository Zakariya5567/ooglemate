import 'package:caroogle/data/models/dropdown/car_models_model.dart';
import 'package:caroogle/data/models/dropdown/fuel_type_model.dart';
import 'package:caroogle/providers/car_detail_provider.dart';
import 'package:caroogle/providers/inventory_add_new_provider.dart';
import 'package:caroogle/providers/preferences_add_data_provider.dart';
import 'package:caroogle/providers/search_filter_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/dropdown/body_model.dart';
import '../../data/models/dropdown/color_model.dart';
import '../../data/models/dropdown/make_model.dart';
import '../../data/models/dropdown/transmission_model.dart';
import '../../providers/set_trigger_provider.dart';
import '../../utils/dimension.dart';
import '../../utils/images.dart';

Widget CustomDropdownAutoComplete({
  required BuildContext context,
  required var provider,
  required int id,
  required String title,
  required String hintText,
  required var items,
  required TextEditingController textController,
  required bool isPopulate,
}) {
  return Container(
      height: 70,
      width: displayWidth(context, 0.40),
      decoration: BoxDecoration(
          color: primaryWhite,
          border: Border(
              bottom: BorderSide(color: lightGrey.withOpacity(0.2), width: 1))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: textStyle(
              fontSize: 16, color: primaryBlack, fontFamily: latoBold),
        ),
        Row(
          children: [
            id == 1
                ? Expanded(
                    child: Autocomplete<MakeMapData>(
                      initialValue: isPopulate == true
                          ? TextEditingValue(text: textController.text)
                          : const TextEditingValue(text: ""),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return items
                            .where((MakeMapData mapData) => mapData.name!
                                .toLowerCase()
                                .startsWith(
                                    textEditingValue.text.toLowerCase()))
                            .toList();
                      },
                      displayStringForOption: (MakeMapData mapData) =>
                          mapData.name!,
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                        return TextField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          style: const TextStyle(fontSize: 14),
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
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                          ),
                          onSubmitted: (value) {
                            provider.setDropdownValueValidation(context, id);
                          },
                          onChanged: (value) {
                            provider.carMakeController =
                                fieldTextEditingController;
                          },
                        );
                      },
                      onSelected: (MakeMapData mapData) {
                        provider.setDropDownValue(
                          context: context,
                          title: title,
                          id: mapData.id!,
                        );
                      },
                      optionsViewBuilder: (BuildContext context,
                          AutocompleteOnSelected<MakeMapData> onSelected,
                          Iterable<MakeMapData> options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            child: Container(
                              width: displayWidth(context, 0.40),
                              height: displayHeight(context, 0.40),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade400,
                                      offset: Offset(2, 2),
                                      blurRadius: 2,
                                      spreadRadius: 2)
                                ],
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Scrollbar(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: options.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final MakeMapData option =
                                        options.elementAt(index);

                                    return GestureDetector(
                                      onTap: () {
                                        onSelected(option);
                                        provider.setDropDownValue(
                                            context: context,
                                            title: title,
                                            id: option.id!);
                                      },
                                      child: ListTile(
                                        tileColor: Colors.red,
                                        title: Text(option.name!,
                                            style: const TextStyle(
                                                color: primaryBlack)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : id == 2
                    ? Expanded(
                        child: Autocomplete<ModelMapData>(
                          initialValue: isPopulate == true
                              ? TextEditingValue(text: textController.text)
                              : const TextEditingValue(text: ""),
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            return items
                                .where((ModelMapData mapData) => mapData.name!
                                    .toLowerCase()
                                    .startsWith(
                                        textEditingValue.text.toLowerCase()))
                                .toList();
                          },
                          displayStringForOption: (ModelMapData mapData) =>
                              mapData.name!,
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted) {
                            return TextField(
                              controller: fieldTextEditingController,
                              focusNode: fieldFocusNode,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(fontSize: 12),
                                fillColor: primaryWhite,
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: hintText,
                                hintStyle: textStyle(
                                    fontSize: 12,
                                    color: lightGrey,
                                    fontFamily: latoRegular),
                                contentPadding: EdgeInsets.zero,
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                ),
                              ),
                              onSubmitted: (value) {
                                provider.setDropdownValueValidation(
                                    context, id);
                              },
                              onChanged: (value) {
                                provider.carModelController =
                                    fieldTextEditingController;
                              },
                            );
                          },
                          onSelected: (ModelMapData mapData) {
                            print('Selected: ${mapData.name}');
                          },
                          optionsViewBuilder: (BuildContext context,
                              AutocompleteOnSelected<ModelMapData> onSelected,
                              Iterable<ModelMapData> options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                child: Container(
                                  width: displayWidth(context, 0.40),
                                  height: displayHeight(context, 0.40),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade400,
                                          offset: Offset(2, 2),
                                          blurRadius: 2,
                                          spreadRadius: 2)
                                    ],
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Scrollbar(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final ModelMapData option =
                                            options.elementAt(index);

                                        return GestureDetector(
                                          onTap: () {
                                            onSelected(option);
                                            provider.setDropDownValue(
                                                context: context,
                                                title: title,
                                                id: option.id!);
                                          },
                                          child: ListTile(
                                            tileColor: Colors.red,
                                            title: Text(option.name!,
                                                style: const TextStyle(
                                                    color: primaryBlack)),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : id == 3
                        ? Expanded(
                            child: Autocomplete<TransmissionMapData>(
                              initialValue: isPopulate == true
                                  ? TextEditingValue(text: textController.text)
                                  : const TextEditingValue(text: ""),
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                return items
                                    .where((TransmissionMapData mapData) =>
                                        mapData.name!.toLowerCase().startsWith(
                                            textEditingValue.text
                                                .toLowerCase()))
                                    .toList();
                              },
                              displayStringForOption:
                                  (TransmissionMapData mapData) =>
                                      mapData.name!,
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController
                                      fieldTextEditingController,
                                  FocusNode fieldFocusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextField(
                                  controller: fieldTextEditingController,
                                  focusNode: fieldFocusNode,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                    errorStyle: const TextStyle(fontSize: 12),
                                    fillColor: primaryWhite,
                                    filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: hintText,
                                    hintStyle: textStyle(
                                        fontSize: 12,
                                        color: lightGrey,
                                        fontFamily: latoRegular),
                                    contentPadding: EdgeInsets.zero,
                                    border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    provider.setDropdownValueValidation(
                                        context, id);
                                  },
                                  onChanged: (value) {
                                    provider.transmissionController =
                                        fieldTextEditingController;
                                  },
                                );
                              },
                              onSelected: (TransmissionMapData mapData) {
                                print('Selected: ${mapData.name}');
                              },
                              optionsViewBuilder: (BuildContext context,
                                  AutocompleteOnSelected<TransmissionMapData>
                                      onSelected,
                                  Iterable<TransmissionMapData> options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    child: Container(
                                      width: displayWidth(context, 0.40),
                                      height: displayHeight(context, 0.40),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade400,
                                              offset: Offset(2, 2),
                                              blurRadius: 2,
                                              spreadRadius: 2)
                                        ],
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Scrollbar(
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: options.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final TransmissionMapData option =
                                                options.elementAt(index);

                                            return GestureDetector(
                                              onTap: () {
                                                onSelected(option);
                                                provider.setDropDownValue(
                                                    context: context,
                                                    title: title,
                                                    id: option.id!);
                                              },
                                              child: ListTile(
                                                tileColor: Colors.red,
                                                title: Text(option.name!,
                                                    style: const TextStyle(
                                                        color: primaryBlack)),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : id == 4
                            ? Expanded(
                                child: Autocomplete<FuelMapData>(
                                  initialValue: isPopulate == true
                                      ? TextEditingValue(
                                          text: textController.text)
                                      : const TextEditingValue(text: ""),
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    return items
                                        .where((FuelMapData mapData) => mapData
                                            .name!
                                            .toLowerCase()
                                            .startsWith(textEditingValue.text
                                                .toLowerCase()))
                                        .toList();
                                  },
                                  displayStringForOption:
                                      (FuelMapData mapData) => mapData.name!,
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          fieldTextEditingController,
                                      FocusNode fieldFocusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextField(
                                      controller: fieldTextEditingController,
                                      focusNode: fieldFocusNode,
                                      style: const TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        errorStyle:
                                            const TextStyle(fontSize: 12),
                                        fillColor: primaryWhite,
                                        filled: true,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: hintText,
                                        hintStyle: textStyle(
                                            fontSize: 12,
                                            color: lightGrey,
                                            fontFamily: latoRegular),
                                        contentPadding: EdgeInsets.zero,
                                        border: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                        ),
                                      ),
                                      onSubmitted: (value) {
                                        provider.setDropdownValueValidation(
                                            context, id);
                                      },
                                      onChanged: (value) {
                                        provider.fuelController =
                                            fieldTextEditingController;
                                      },
                                    );
                                  },
                                  onSelected: (FuelMapData mapData) {
                                    print('Selected: ${mapData.name}');
                                  },
                                  optionsViewBuilder: (BuildContext context,
                                      AutocompleteOnSelected<FuelMapData>
                                          onSelected,
                                      Iterable<FuelMapData> options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        child: Container(
                                          width: displayWidth(context, 0.40),
                                          height: displayHeight(context, 0.40),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.shade400,
                                                  offset: Offset(2, 2),
                                                  blurRadius: 2,
                                                  spreadRadius: 2)
                                            ],
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                          child: Scrollbar(
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              itemCount: options.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final FuelMapData option =
                                                    options.elementAt(index);

                                                return GestureDetector(
                                                  onTap: () {
                                                    onSelected(option);
                                                    provider.setDropDownValue(
                                                        context: context,
                                                        title: title,
                                                        id: option.id!);
                                                  },
                                                  child: ListTile(
                                                    tileColor: Colors.red,
                                                    title: Text(option.name!,
                                                        style: const TextStyle(
                                                            color:
                                                                primaryBlack)),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : id == 5
                                ? Expanded(
                                    child: Autocomplete<BodyMapData>(
                                      initialValue: isPopulate == true
                                          ? TextEditingValue(
                                              text: textController.text)
                                          : const TextEditingValue(text: ""),
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                        return items
                                            .where((BodyMapData mapData) =>
                                                mapData.name!
                                                    .toLowerCase()
                                                    .startsWith(textEditingValue
                                                        .text
                                                        .toLowerCase()))
                                            .toList();
                                      },
                                      displayStringForOption:
                                          (BodyMapData mapData) =>
                                              mapData.name!,
                                      fieldViewBuilder: (BuildContext context,
                                          TextEditingController
                                              fieldTextEditingController,
                                          FocusNode fieldFocusNode,
                                          VoidCallback onFieldSubmitted) {
                                        return TextField(
                                          controller:
                                              fieldTextEditingController,
                                          focusNode: fieldFocusNode,
                                          style: const TextStyle(fontSize: 14),
                                          decoration: InputDecoration(
                                            errorStyle:
                                                const TextStyle(fontSize: 12),
                                            fillColor: primaryWhite,
                                            filled: true,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            hintText: hintText,
                                            hintStyle: textStyle(
                                                fontSize: 12,
                                                color: lightGrey,
                                                fontFamily: latoRegular),
                                            contentPadding: EdgeInsets.zero,
                                            border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                          onSubmitted: (value) {
                                            provider.setDropdownValueValidation(
                                                context, id);
                                          },
                                          onChanged: (value) {
                                            provider.bodyController =
                                                fieldTextEditingController;
                                          },
                                        );
                                      },
                                      onSelected: (BodyMapData mapData) {
                                        print('Selected: ${mapData.name}');
                                      },
                                      optionsViewBuilder: (BuildContext context,
                                          AutocompleteOnSelected<BodyMapData>
                                              onSelected,
                                          Iterable<BodyMapData> options) {
                                        return Align(
                                          alignment: Alignment.topLeft,
                                          child: Material(
                                            child: Container(
                                              width:
                                                  displayWidth(context, 0.40),
                                              height:
                                                  displayHeight(context, 0.40),
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color:
                                                          Colors.grey.shade400,
                                                      offset: Offset(2, 2),
                                                      blurRadius: 2,
                                                      spreadRadius: 2)
                                                ],
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              child: Scrollbar(
                                                child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final BodyMapData option =
                                                        options
                                                            .elementAt(index);

                                                    return GestureDetector(
                                                      onTap: () {
                                                        onSelected(option);
                                                        provider
                                                            .setDropDownValue(
                                                                context:
                                                                    context,
                                                                title: title,
                                                                id: option.id!);
                                                      },
                                                      child: ListTile(
                                                        tileColor: Colors.red,
                                                        title: Text(
                                                            option.name!,
                                                            style: const TextStyle(
                                                                color:
                                                                    primaryBlack)),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Expanded(
                                    child: Autocomplete<ColorMapData>(
                                      initialValue: isPopulate == true
                                          ? TextEditingValue(
                                              text: textController.text)
                                          : const TextEditingValue(text: ""),
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                        return items
                                            .where((ColorMapData mapData) =>
                                                mapData
                                                    .name!
                                                    .toLowerCase()
                                                    .startsWith(textEditingValue
                                                        .text
                                                        .toLowerCase()))
                                            .toList();
                                      },
                                      displayStringForOption:
                                          (ColorMapData mapData) =>
                                              mapData.name!,
                                      fieldViewBuilder: (BuildContext context,
                                          TextEditingController
                                              fieldTextEditingController,
                                          FocusNode fieldFocusNode,
                                          VoidCallback onFieldSubmitted) {
                                        return TextField(
                                          controller:
                                              fieldTextEditingController,
                                          focusNode: fieldFocusNode,
                                          style: const TextStyle(fontSize: 14),
                                          decoration: InputDecoration(
                                            errorStyle:
                                                const TextStyle(fontSize: 12),
                                            fillColor: primaryWhite,
                                            filled: true,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            hintText: hintText,
                                            hintStyle: textStyle(
                                                fontSize: 12,
                                                color: lightGrey,
                                                fontFamily: latoRegular),
                                            contentPadding: EdgeInsets.zero,
                                            border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                          onSubmitted: (value) {
                                            provider.setDropdownValueValidation(
                                                context, id);
                                          },
                                          onChanged: (value) {
                                            provider.colorController =
                                                fieldTextEditingController;
                                          },
                                        );
                                      },
                                      onSelected: (ColorMapData mapData) {
                                        print('Selected: ${mapData.name}');
                                      },
                                      optionsViewBuilder: (BuildContext context,
                                          AutocompleteOnSelected<ColorMapData>
                                              onSelected,
                                          Iterable<ColorMapData> options) {
                                        return Align(
                                          alignment: Alignment.topLeft,
                                          child: Material(
                                            child: Container(
                                              width:
                                                  displayWidth(context, 0.40),
                                              height:
                                                  displayHeight(context, 0.40),
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color:
                                                          Colors.grey.shade400,
                                                      offset: Offset(2, 2),
                                                      blurRadius: 2,
                                                      spreadRadius: 2)
                                                ],
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              child: Scrollbar(
                                                child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final ColorMapData option =
                                                        options
                                                            .elementAt(index);

                                                    return GestureDetector(
                                                      onTap: () {
                                                        onSelected(option);

                                                        provider
                                                            .setDropDownValue(
                                                                context:
                                                                    context,
                                                                title: title,
                                                                id: option.id!);
                                                      },
                                                      child: ListTile(
                                                        tileColor: Colors.red,
                                                        title: Text(
                                                            option.name!,
                                                            style: const TextStyle(
                                                                color:
                                                                    primaryBlack)),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
            const ImageIcon(
              AssetImage(Images.iconDropdown),
              size: 15,
              color: primaryBlack,
            )
          ],
        )
      ]));
}
