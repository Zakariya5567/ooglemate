import 'dart:io';

import 'package:caroogle/data/models/inventories/inventory_mapping_model.dart';
import 'package:caroogle/providers/dropdown_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:provider/provider.dart';

import '../data/models/inventories/add_inventory_model.dart';
import '../data/models/inventories/upload_inventory_csv_model.dart';
import '../data/models/preferences/download_csv_model.dart';
import '../data/repository/api_repo.dart';
import '../helper/connection_checker.dart';
import '../helper/routes_helper.dart';
import '../utils/api_url.dart';
import '../utils/string.dart';
import '../view/widgets/custom_snackbar.dart';
import '../view/widgets/loader_dialog.dart';

class InventoryAddNewProvider extends ChangeNotifier {
  // isHide is used to show or hide validation text
  bool? isHide;

  //is isMakeSelected is false then we will show show validation message
  bool? isMakeSelected;

  bool? isLoading;

  // downloading is used to show downloading  process loading
  bool? downloading;

  // show percentage of downloading
  int? percentage;

  File? file;
  String value = "value";

  // map index is the current index of the csv mapping screen
  int mapIndex = 0;

  // LIST OF SELECTED ITEM

  // make id is the id of make selected item
  // fuel id is the id of fuel selected item
  // badge is the keyword you enter in badge text-field
  // body id is the id of body selected item
  // transmission id is the id of transmission selected item
  // color id is the id of color selected item

  int? makeId;
  int? modelId;
  int? fuelId;
  int? bodyId;
  int? transmissionId;
  int? colorId;

  // validation string of the screen

  String? sellValidation;
  String? purchaseValidation;
  String? yearValidation;
  String? badgeValidation;
  String? kmValidation;
  String? keywordValidation;

  // AUTO TEXT FIELD
  TextEditingController carMakeController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController transmissionController = TextEditingController();
  TextEditingController fuelController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  // TEXT FIELD

  TextEditingController keyWordsController = TextEditingController();
  TextEditingController kmController = TextEditingController();
  TextEditingController makeYearController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController sellPriceController = TextEditingController();
  TextEditingController carBadgeController = TextEditingController();

  // map of the csv
  Map<String, dynamic> csvMap = {};

  // csv mapped data
  Map<String, dynamic> csvMapData = {};

  ApiRepo apiRepo = ApiRepo();
  DownloadCsvModel csvModel = DownloadCsvModel();
  UploadInventoryModel uploadInventoryModel = UploadInventoryModel();
  AddInventoryModel addNewInventoryModel = AddInventoryModel();
  InventoryMappingModel inventoryMappingModel = InventoryMappingModel();

  // title of the csv map
  List mapTitle = [
    "Make",
    "Model",
    "Badge",
    "Year",
    "Transmission",
    "Fuel Type",
    "Body Type",
    "Purchase Price",
    "Sell Price",
    "Exterior color",
    "Km driven",
    "key word"
  ];

  // to hide or show validation text
  setHide(bool value) {
    isHide = value;
    notifyListeners();
  }

  setMakeSelected(bool value) {
    isMakeSelected = value;
    notifyListeners();
  }

  // to set the current index of the csv map
  setMapIndex() {
    mapIndex = mapIndex + 1;
    notifyListeners();
  }

  // refresh the map index
  refreshMapIndex() {
    mapIndex = 0;
    notifyListeners();
  }

  // FOR DROP DOWN VALIDATION
  setDropdownValueValidation(BuildContext context, int dropdownId) {
    // DROPDOWN ID 1 FOR MAKE MODEL
    // DROPDOWN ID 2 FOR CAR  MODEL
    // DROPDOWN ID 3 FOR TRANSMISSION MODEL
    // DROPDOWN ID 4 FOR FUEL TYPE MODEL
    // DROPDOWN ID 5 FOR BODY TYPE MODEL
    // DROPDOWN ID 6 FOR COLOR MODEL

    final dropdownProvider =
        Provider.of<DropdownProvider>(context, listen: false);
    if (dropdownId == 1) {
      for (var element in dropdownProvider.makeModel.data!.rows!) {
        if (element.name!.toLowerCase() ==
            carMakeController.text.toLowerCase()) {
          makeId = null;
          makeId = element.id;
          isMakeSelected = false;
          callModelApi(context, element.id!);
          break;
        } else {
          makeId = null;
          isHide = true;
        }
      }
    } else if (dropdownId == 2) {
      for (var element in dropdownProvider.carModel.data!.rows!) {
        if (element.name!.toLowerCase() ==
            carModelController.text.toLowerCase()) {
          modelId = null;
          modelId = element.id;
          break;
        } else {
          modelId = null;
          isHide = true;
        }
      }
    } else if (dropdownId == 3) {
      for (var element in dropdownProvider.transmissionModel.data!.rows!) {
        if (element.name!.toLowerCase() ==
            transmissionController.text.toLowerCase()) {
          transmissionId = null;
          transmissionId = element.id;
          break;
        } else {
          transmissionId = null;
          isHide = true;
        }
      }
    } else if (dropdownId == 4) {
      for (var element in dropdownProvider.fuelTypeModel.data!.rows!) {
        if (element.name!.toLowerCase() == fuelController.text.toLowerCase()) {
          fuelId = null;
          fuelId = element.id;
          break;
        } else {
          fuelId = null;
          isHide = true;
        }
      }
    } else if (dropdownId == 5) {
      for (var element in dropdownProvider.bodyModel.data!.rows!) {
        if (element.name!.toLowerCase() == bodyController.text.toLowerCase()) {
          bodyId = null;
          bodyId = element.id;
          break;
        } else {
          bodyId = null;
          isHide = true;
        }
      }
    } else if (dropdownId == 6) {
      for (var element in dropdownProvider.colorModel.data!.rows!) {
        if (element.name!.toLowerCase() == bodyController.text.toLowerCase()) {
          colorId = null;
          colorId = element.id;
          break;
        } else {
          colorId = null;
          isHide = true;
        }
      }
    }
    notifyListeners();
  }

  setCsvMap(String key, String value) {
    csvMap[key] = value;

    if (key == "Make") {
      csvMapData["make"] = value;
    } else if (key == "Model") {
      csvMapData["model"] = value;
    } else if (key == "Badge") {
      csvMapData["badge"] = value;
    } else if (key == "Year") {
      csvMapData["year"] = value;
    } else if (key == "Transmission") {
      csvMapData["transmission"] = value;
    } else if (key == "Fuel Type") {
      csvMapData["fuel_type"] = value;
    } else if (key == "Body Type") {
      csvMapData["body_type"] = value;
    } else if (key == "Purchase Price") {
      csvMapData["purchase_price"] = value;
    } else if (key == "Sell Price") {
      csvMapData["sell_price"] = value;
    } else if (key == "Exterior color") {
      csvMapData["exterior_color"] = value;
    } else if (key == "Km driven") {
      csvMapData["km_driven"] = value;
    } else if (key == "key word") {
      csvMapData["key_word"] = value;
    }

    debugPrint("map:$csvMap");
    debugPrint("mapped dara :$csvMapData");
    notifyListeners();
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setDialogLoading(BuildContext context, bool value) {
    isLoading = value;
    if (value == true) {
      loaderDialog(context);
    } else {
      Navigator.of(context).pop();
    }
    notifyListeners();
  }

  setDownloading(bool value) {
    downloading = value;
    notifyListeners();
  }
  // dropdown

  setFile(File newFile) {
    file = newFile;
    notifyListeners();
  }

  setPercentage(int value) {
    percentage = value;
    debugPrint("provider $percentage");
    notifyListeners();
  }

  clearDropdown() {
    makeId = null;
    modelId = null;
    fuelId = null;
    bodyId = null;
    transmissionId = null;
    colorId = null;

    sellValidation = null;
    purchaseValidation = null;
    yearValidation = null;
    badgeValidation = null;
    kmValidation = null;
    keywordValidation = null;
    isMakeSelected = false;
    isHide = false;

    keyWordsController.clear();
    kmController.clear();
    makeYearController.clear();
    purchasePriceController.clear();
    sellPriceController.clear();
    carBadgeController.clear();

    notifyListeners();
  }

  setTextFieldValidationValue() {
    badgeValidation = carBadgeController.text.trim();
    purchaseValidation = purchasePriceController.text.trim();
    sellValidation = sellPriceController.text.trim();
    yearValidation = makeYearController.text.trim();
    keywordValidation = keyWordsController.text.trim();
    kmValidation = kmController.text.trim();
    if (badgeValidation!.isEmpty) {
      badgeValidation = null;
    }
    if (purchaseValidation!.isEmpty) {
      purchaseValidation = null;
    }
    if (sellValidation!.isEmpty) {
      sellValidation = null;
    }
    if (yearValidation!.isEmpty) {
      yearValidation = null;
    }
    if (kmValidation!.isEmpty) {
      kmValidation = null;
    }
    if (keywordValidation!.isEmpty) {
      keywordValidation = null;
    }
    notifyListeners();
  }

  setDropDownValue({
    required BuildContext context,
    required String title,
    required int id,
  }) {
    if (title == carMake) {
      makeId = id;
      isMakeSelected = false;
      callModelApi(context, id);
      debugPrint("make id : $makeId");
    } else if (title == carModel) {
      modelId = id;
      debugPrint("model id : $modelId");
    } else if (title == fuelType) {
      fuelId = id;
      debugPrint("fuel id : $fuelId");
    } else if (title == transmission) {
      transmissionId = id;
      debugPrint("transmission id : $transmissionId");
    } else if (title == bodyType) {
      bodyId = id;
      debugPrint("body id : $bodyId");
    } else if (title == colours) {
      colorId = id;
      debugPrint("body id : $colorId");
    }
    notifyListeners();
  }

  //============================================================================
  // API CALLING

  callModelApi(BuildContext context, int id) {
    Future.delayed(Duration.zero, () {
      final dropdownProvider =
          Provider.of<DropdownProvider>(context, listen: false);
      dropdownProvider.getModel(
          context, RouterHelper.inventoryAddNewScreen, id);
    });
  }

  //INVENTORY MAPPING
  inventoryCsvMapping(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setDialogLoading(context, true);

        debugPrint(" csv mapping ==========================>>>");
        try {
          Response response = await apiRepo.postData(
              context, screen, ApiUrl.inventoryMappingUrl, csvMapData);
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          inventoryMappingModel = InventoryMappingModel.fromJson(responseBody);
          if (inventoryMappingModel.error == true) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
                // ignore: use_build_context_synchronously
                customSnackBar(context, inventoryMappingModel.message!, 1));
          }
          setDialogLoading(context, false);
        } catch (e) {
          setDialogLoading(context, false);
        }

        notifyListeners();
      }
    });
  }

//   //UPLOAD INVENTORY CSV
  uploadInventoryCsv(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setDialogLoading(context, true);

        debugPrint(" upload inventory csv ==========================>>>");
        try {
          String? mimeType = mime(file!.path);
          String? mimee = mimeType?.split('/')[0];
          String? type = mimeType?.split('/')[1];

          Response response = await apiRepo.postMultipartData(
              context, screen, ApiUrl.uploadInventoryCsvUrl, {
            'csv_file': await MultipartFile.fromFile(file!.path,
                filename: file!.path, contentType: MediaType(mimee!, type!)),
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          uploadInventoryModel = UploadInventoryModel.fromJson(responseBody);

          if (uploadInventoryModel.error == true) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
                // ignore: use_build_context_synchronously
                customSnackBar(
                    context, uploadInventoryModel.message.toString(), 1));
          }

          setDialogLoading(context, false);
        } catch (e) {
          setDialogLoading(context, false);
        }

        notifyListeners();
      }
    });
  }

// ADD NEW INVENTORY
  addNewInventory(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint("ad new preferences  ==========================>>>");
        try {
          Response response = await apiRepo
              .postData(context, screen, ApiUrl.addNewInventoriesUrl, {
            "make_id": makeId,
            "model_id": modelId,
            "fuel_type_id": fuelId,
            "badge": carBadgeController.text,
            "body_type_id": bodyId,
            "transmission_id": transmissionId,
            "year": makeYearController.text,
            "km_driven": kmController.text,
            "purchase_price": purchasePriceController.text,
            "sell_price": sellPriceController.text,
            "key_word": keyWordsController.text,
            "exterior_color_id": colorId,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          addNewInventoryModel = AddInventoryModel.fromJson(responseBody);
          if (addNewInventoryModel.error == true) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
                // ignore: use_build_context_synchronously
                customSnackBar(context, addNewInventoryModel.message!, 1));
          }

          setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }
}
