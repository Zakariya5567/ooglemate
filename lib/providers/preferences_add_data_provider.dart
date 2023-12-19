import 'dart:convert';

import 'package:caroogle/data/models/preferences/download_csv_model.dart';
import 'package:caroogle/data/repository/api_repo.dart';
import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/dropdown_provider.dart';
import 'package:caroogle/utils/string.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../data/models/preferences/add_new_preferences_model.dart';
import '../data/models/preferences/csv_mapping_model.dart';
import '../data/models/preferences/upload_csv_model.dart';
import '../helper/connection_checker.dart';
import '../helper/notification_service.dart';
import '../utils/api_url.dart';
import '../view/widgets/custom_snackbar.dart';
import '../view/widgets/loader_dialog.dart';

class PreferencesAddDataProvider extends ChangeNotifier {
  // isHide is used for dropdown and text field validation
  // id isHide is true then we will show error message
  // isMakeSelected is used: if the user select make then can select model or unable to select model
  // isLoading is used for loading : if the api calling is  we will set is loading true other wise false

  bool? isHide;
  bool? isMakeSelected;
  bool? isLoading;
  bool? downloading;
  int? percentage;
  File? file;
  String value = "value";
  int mapIndex = 0;

  String? sellValidation;
  String? purchaseValidation;
  String? yearValidation;
  String? badgeValidation;

  // LIST OF SELECTED ITEM

  String? makeList;
  String? modelList;
  String? fuelList;
  String? badgeList;
  String? bodyList;
  String? transmissionList;

  List makeIdList = [];
  List modelIdList = [];
  List fuelTypeIdList = [];
  List badge = [];
  List bodyTypeIdList = [];
  List transmissionIdList = [];

  // AUTO TEXT FIELD
  TextEditingController carMakeController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController transmissionController = TextEditingController();
  TextEditingController fuelController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  // TEXT FIELD
  TextEditingController carBadgeController = TextEditingController();
  TextEditingController makeYearController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController sellPriceController = TextEditingController();
  TextEditingController keyWordsController = TextEditingController();

  //CSV MAPPING
  Map<String, dynamic> csvMap = {};
  Map<String, dynamic> csvMapData = {};

  ApiRepo apiRepo = ApiRepo();
  DownloadCsvModel csvModel = DownloadCsvModel();
  UploadCsvModel uploadCsvModel = UploadCsvModel();
  CsvMappingModel csvMappingModel = CsvMappingModel();
  AddNewPreferencesModel addNewPreferencesModel = AddNewPreferencesModel();

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
  ];

  setHide(bool value) {
    isHide = value;
    notifyListeners();
  }

  setMakeSelected(bool value) {
    isMakeSelected = value;
    notifyListeners();
  }

  setMapIndex() {
    mapIndex = mapIndex + 1;
    notifyListeners();
  }

  refreshMapIndex() {
    mapIndex = 0;
    notifyListeners();
  }

  setTextFieldValidationValue() {
    badgeValidation = carBadgeController.text.trim();
    purchaseValidation = purchasePriceController.text.trim();
    sellValidation = sellPriceController.text.trim();
    yearValidation = makeYearController.text.trim();
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
    makeIdList.clear();
    modelIdList.clear();
    fuelTypeIdList.clear();
    badge.clear();
    bodyTypeIdList.clear();
    transmissionIdList.clear();

    makeList = null;
    modelList = null;
    fuelList = null;
    badgeList = null;
    bodyList = null;
    transmissionList = null;

    sellValidation = null;
    purchaseValidation = null;
    yearValidation = null;
    badgeValidation = null;
    isMakeSelected = null;
    isHide = false;

    carBadgeController.clear();
    makeYearController.clear();
    purchasePriceController.clear();
    sellPriceController.clear();

    notifyListeners();
  }

  setCarBadge() {
    badge.clear();
    badge.add(carBadgeController.text);
    badgeList = '${badge.map((s) => '"$s"').toList()}';
    debugPrint("BadgeList  : $badgeList");
    notifyListeners();
  }

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
          makeIdList.clear();
          makeIdList.add(element.id);
          makeList = '${makeIdList.map((s) => '$s').toList()}';
          isMakeSelected = false;
          callModelApi(context, element.id!);
          break;
        } else {
          makeIdList.clear();
          isHide = true;
        }
      }
    } else if (dropdownId == 2) {
      for (var element in dropdownProvider.carModel.data!.rows!) {
        if (element.name!.toLowerCase() ==
            carModelController.text.toLowerCase()) {
          modelIdList.clear();
          modelIdList.add(element.id);
          modelList = '${modelIdList.map((s) => '$s').toList()}';
          debugPrint("model id : $modelList");
          break;
        } else {
          modelIdList.clear();
          isHide = true;
        }
      }
    } else if (dropdownId == 3) {
      for (var element in dropdownProvider.transmissionModel.data!.rows!) {
        if (element.name!.toLowerCase() ==
            transmissionController.text.toLowerCase()) {
          transmissionIdList.clear();
          transmissionIdList.add(element.id);
          transmissionList = '${transmissionIdList.map((s) => '$s').toList()}';
          debugPrint("transmission id : $transmissionList");
          break;
        } else {
          transmissionIdList.clear();
          isHide = true;
        }
      }
    } else if (dropdownId == 4) {
      for (var element in dropdownProvider.fuelTypeModel.data!.rows!) {
        if (element.name!.toLowerCase() == fuelController.text.toLowerCase()) {
          fuelTypeIdList.clear();
          fuelTypeIdList.add(element.id);
          fuelList = '${fuelTypeIdList.map((s) => '$s').toList()}';
          debugPrint("fuel id : $fuelList");
          break;
        } else {
          fuelTypeIdList.clear();
          isHide = true;
        }
      }
    } else if (dropdownId == 5) {
      for (var element in dropdownProvider.bodyModel.data!.rows!) {
        if (element.name!.toLowerCase() == bodyController.text.toLowerCase()) {
          bodyTypeIdList.clear();
          bodyTypeIdList.add(element.id);
          bodyList = '${bodyTypeIdList.map((s) => '$s').toList()}';
          debugPrint("body id : $bodyList");
          break;
        } else {
          bodyTypeIdList.clear();
          isHide = true;
        }
      }
    }
    notifyListeners();
  }

  setDropDownValue({
    required BuildContext context,
    required String title,
    required int id,
  }) {
    if (title == carMake) {
      makeIdList.clear();
      makeIdList.add(id);
      makeList = '${makeIdList.map((s) => '$s').toList()}';
      isMakeSelected = false;
      callModelApi(context, id);
      debugPrint("make id : $makeList");
    } else if (title == carModel) {
      modelIdList.clear();
      modelIdList.add(id);
      modelList = '${modelIdList.map((s) => '$s').toList()}';
      debugPrint("model id : $modelList");
    } else if (title == transmission) {
      transmissionIdList.clear();
      transmissionIdList.add(id);
      transmissionList = '${transmissionIdList.map((s) => '$s').toList()}';
      debugPrint("transmission id : $transmissionList");
    } else if (title == fuelType) {
      fuelTypeIdList.clear();
      fuelTypeIdList.add(id);
      fuelList = '${fuelTypeIdList.map((s) => '$s').toList()}';
      debugPrint("fuel id : $fuelList");
    } else if (title == bodyType) {
      bodyTypeIdList.clear();
      bodyTypeIdList.add(id);
      bodyList = '${bodyTypeIdList.map((s) => '$s').toList()}';
      debugPrint("body id : $bodyList");
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
          context, RouterHelper.preferencesAddDataScreen, id);
    });
  }

  //DOWNLOAD CSV FILE
  getCsvFile(BuildContext context, String screen) async {
    return await checkInternet(context, screen).then((value) async {
      if (value == true) {
        setPercentage(0);
        setDownloading(true);
        debugPrint("downloading: $isLoading");
        debugPrint("download csv  ==========================>>>");
        try {
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.downloadCsvUrl, {});
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          csvModel = DownloadCsvModel.fromJson(responseBody);
          // setDownloading(false);
          debugPrint("downloading: $isLoading");
        } catch (e) {
          setDownloading(false);
          debugPrint("downloading: $isLoading");
        }

        notifyListeners();
      }
    });
  }

  downloadCsvFile(BuildContext context, String screen, String localPath) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setDownloading(true);
        debugPrint("downloading: $downloading");
        debugPrint("download csv  ==========================>>>");
        try {
          String url = csvModel.data!.sampleCsv!;

          // Get the name of the file from the path
          String fileName = url.substring(url.lastIndexOf("/") + 1);
          debugPrint("file :$fileName");
          List splitList = fileName.split("?");
          debugPrint("list :$splitList");
          debugPrint("file name is  : ${splitList.first}");

          // path the file will be save
          String savePath =
              "$localPath${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}${DateTime.now().microsecond}${splitList.first}";

          // calling api
          Response response = await apiRepo.downloadData(
              context, screen, csvModel.data!.sampleCsv!, savePath);
          print("${response.data}");

          if (response.statusCode == 200) {
            Future.delayed(Duration.zero, () {
              // when download then we will show message in notification class
              NotificationService().displayAlertNotification();
            });
          }

          setDownloading(false);
          debugPrint("downloading: $downloading");
        } catch (e) {
          setDownloading(false);
          debugPrint("downloading: $downloading");
        }

        notifyListeners();
      }
    });
  }

  //UPLOAD CSV
  uploadCsv(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setDialogLoading(context, true);

        debugPrint(" upload csv ==========================>>>");
        try {
          String? mimeType = mime(file!.path);
          String? mimee = mimeType?.split('/')[0];
          String? type = mimeType?.split('/')[1];

          Response response = await apiRepo
              .postMultipartData(context, screen, ApiUrl.uploadCsvUrl, {
            'csv_file': await MultipartFile.fromFile(file!.path,
                filename: file!.path, contentType: MediaType(mimee!, type!)),
          });
          final responseBody = response.data;
          debugPrint(
              "Csv upload response body ===============>>> $responseBody");
          uploadCsvModel = UploadCsvModel.fromJson(responseBody);

          if (uploadCsvModel.error == true) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
                // ignore: use_build_context_synchronously
                customSnackBar(context, uploadCsvModel.message.toString(), 1));
          }

          setDialogLoading(context, false);
        } catch (e) {
          setDialogLoading(context, false);
        }

        notifyListeners();
      }
    });
  }

  //CSV MAPPING
  csvMapping(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setDialogLoading(context, true);

        debugPrint(" csv mapping ==========================>>>");
        try {
          Response response = await apiRepo.postData(
              context, screen, ApiUrl.csvMappingUrl, csvMapData);
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          csvMappingModel = CsvMappingModel.fromJson(responseBody);
          if (csvMappingModel.error == true) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
                // ignore: use_build_context_synchronously
                customSnackBar(context, csvMappingModel.message!, 1));
          }
          setDialogLoading(context, false);
        } catch (e) {
          setDialogLoading(context, false);
        }

        notifyListeners();
      }
    });
  }

  // ADD NEW PREFERENCES
  addNewPreferences(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint("ad new preferences  ==========================>>>");
        try {
          Response response = await apiRepo
              .postData(context, screen, ApiUrl.addPreferencesUrl, {
            "make_id": makeList,
            "model_id": modelList,
            "fuel_type_id": fuelList,
            "badge": badgeList,
            "body_type_id": bodyList,
            "transmission_id": transmissionList,
            "from_year": makeYearController.text,
            "to_year": makeYearController.text,
            "minimum_purchase_price": 0,
            "maximum_purchase_price": purchasePriceController.text,
            "minimum_sale_price": 0,
            "maximum_sale_price": sellPriceController.text,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          addNewPreferencesModel =
              AddNewPreferencesModel.fromJson(responseBody);
          if (addNewPreferencesModel.error == true) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
                // ignore: use_build_context_synchronously
                customSnackBar(context, addNewPreferencesModel.message!, 1));
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
