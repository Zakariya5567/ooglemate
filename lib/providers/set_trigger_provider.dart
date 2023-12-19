import 'package:caroogle/data/repository/api_repo.dart';
import 'package:caroogle/providers/car_detail_provider.dart';
import 'package:caroogle/view/widgets/custom_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../data/models/trigger/add_new_trigger_model.dart';
import '../helper/connection_checker.dart';
import '../helper/routes_helper.dart';
import '../utils/api_url.dart';
import '../utils/string.dart';
import 'dropdown_provider.dart';

class SetTriggerProvider extends ChangeNotifier {
  bool? isLoading;
  bool? isHide;
  bool? isMakeSelected;

  // Pre populate is use when the use click on trigger button of the detail screen
  // The detail of the car will be shown automatically in trigger section

  int? perPopulate;

  // title list
  int titleListIndex = 0;

  // Validation

  String? badgeValidation;
  String? keyWordValidation;

  // LIST OF SELECTED ITEM

  String? makeList;
  String? modelList;
  String? fuelList;
  String? badgeList;
  String? bodyList;
  String? transmissionList;
  String? priceTagList;

  List makeIdList = [];
  List modelIdList = [];
  List fuelTypeIdList = [];
  List badge = [];
  List bodyTypeIdList = [];
  List transmissionIdList = [];
  List checkList = [];

  // range slider

  int? minYear;
  int? maxYear;
  int? minPrice;
  int? maxPrice;
  int? minKm;
  int? maxKm;

  double minimumKm = 0;
  double maximumKm = 64371000;

  double minimumPrice = 0;
  double maximumPrice = 2000000000;

  double minimumYear = 1982;
  double maximumYear = DateTime.now().year.toDouble();

  RangeValues kmValues = const RangeValues(0, 64371000);

  RangeValues priceValues = const RangeValues(0, 2000000000);

  RangeValues makeYearValues =
      RangeValues(1982, DateTime.now().year.toDouble());

  // RangeValues kmValues = const RangeValues(4000000, 60000000);
  //
  // RangeValues priceValues = const RangeValues(120000000, 1870000000);
  //
  // RangeValues makeYearValues = const RangeValues(1984, 2020);

  // AUTO TEXT FIELD

  TextEditingValue carMakeEditingValue = TextEditingValue();

  TextEditingController carMakeController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController transmissionController = TextEditingController();
  TextEditingController fuelController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  // TextField

  TextEditingController keyWordsController = TextEditingController();
  TextEditingController carBadgeController = TextEditingController();

  NewTriggerModel newTriggerModel = NewTriggerModel();
  ApiRepo apiRepo = ApiRepo();

  // CheckBoxes
  Map<String, bool> checkValues = {
    "all": false,
    "low": false,
    "average": false,
    "good": false,
  };

  setPrepopulate(int value) {
    perPopulate = value;
    notifyListeners();
  }

  setTriggerProPopulateData(context) {
    Future.delayed(Duration.zero, () async {
      final dropdownProvider =
          Provider.of<DropdownProvider>(context, listen: false);
      final detailProvider =
          Provider.of<CarDetailProvider>(context, listen: false);

      //For price tag
      //checkValues.forEach((key, value) {});

      // CAR MAKE
      for (var makeElement in dropdownProvider.makeModel.data!.rows!) {
        if (makeElement.name == detailProvider.carDetailModel.data!.make) {
          carMakeController = TextEditingController();
          makeIdList.clear();
          makeIdList.add(makeElement.id);
          carMakeController.clear();
          carMakeController.text = makeElement.name!;
          makeList = '${makeIdList.map((s) => '$s').toList()}';
          isMakeSelected = false;

          // carModel

          await callModelApi(context, makeElement.id!);

          Future.delayed(Duration.zero, () {
            for (var modelElement in dropdownProvider.carModel.data!.rows!) {
              if (modelElement.name ==
                  detailProvider.carDetailModel.data!.model) {
                carModelController = TextEditingController();
                modelIdList.clear();
                modelIdList.add(modelElement.id);
                carModelController.clear();
                carModelController.text = modelElement.name!;
                modelList = '${modelIdList.map((s) => '$s').toList()}';
              }
            }
          });
        }
      }

      // FUEL TYPE
      for (var fuelElement in dropdownProvider.fuelTypeModel.data!.rows!) {
        if (fuelElement.name == detailProvider.carDetailModel.data!.fuelType) {
          fuelController = TextEditingController();
          fuelTypeIdList.clear();
          fuelTypeIdList.add(fuelElement.id);
          fuelController.clear();
          fuelController.text = fuelElement.name!;
          fuelList = '${fuelTypeIdList.map((s) => '$s').toList()}';
        }
      }

      // BODY TYPE
      for (var bodyElement in dropdownProvider.bodyModel.data!.rows!) {
        if (bodyElement.name == detailProvider.carDetailModel.data!.bodyType) {
          bodyController = TextEditingController();
          bodyTypeIdList.clear();
          bodyTypeIdList.add(bodyElement.id);
          bodyController.clear();
          bodyController.text = bodyElement.name!;
          bodyList = '${bodyTypeIdList.map((s) => '$s').toList()}';
        }
      }

      // CAR BADGE
      carBadgeController = TextEditingController();
      badge.clear();
      carBadgeController.clear();
      carBadgeController.text = detailProvider.carDetailModel.data!.badge!;
      badge.add(detailProvider.carDetailModel.data!.badge!);
      badgeList = '${badge.map((s) => '"$s"').toList()}';

      notifyListeners();
    });
  }

  setHide(bool value) {
    isHide = value;
    notifyListeners();
  }

  setMakeSelected(bool value) {
    isMakeSelected = value;
    notifyListeners();
  }

  setTextFieldValidationValue() {
    badgeValidation = carBadgeController.text.trim();
    keyWordValidation = keyWordsController.text.trim();
    if (keyWordValidation!.isEmpty) {
      keyWordValidation = null;
    }
    if (carBadge!.isEmpty) {
      badgeValidation = null;
    }
    notifyListeners();
  }

  setCheckBoxValue(String key) {
    if (key == "all") {
      checkValues[key] == true
          ? checkValues.forEach((key, value) {
              checkValues[key] = false;
              checkList.remove(key);
            })
          : checkValues.forEach((key, value) {
              checkValues[key] = true;
              checkList.remove(key);
              checkList.add(key);
            });
    } else {
      checkValues[key] == true
          ? checkValues[key] = false
          : checkValues[key] = true;
      checkValues[key] == true ? checkList.add(key) : checkList.remove(key);
    }

    print(checkList);
    notifyListeners();
  }

  clearCheckBox() {
    checkList.clear();
    checkValues.forEach((key, value) {
      checkValues[key] = false;
    });
    notifyListeners();
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setTitleListIndex(int newIndex) {
    titleListIndex = newIndex;
    notifyListeners();
  }

  setRangeValues(
      {required String rangeTitle, required RangeValues rangeValues}) {
    if (rangeTitle == km) {
      kmValues = rangeValues;
    } else if (rangeTitle == priceRange) {
      priceValues = rangeValues;
    } else if (rangeTitle == makeYear) {
      makeYearValues = rangeValues;
    }

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

    keyWordValidation = null;
    badgeValidation = null;

    carBadgeController.clear();
    keyWordsController.clear();

    notifyListeners();
  }

  setCarBadge() {
    badge.clear();
    badge.add(carBadgeController.text);
    badgeList = '${badge.map((s) => '"$s"').toList()}';
    debugPrint("BadgeList  : $badgeList");
    notifyListeners();
  }

  setPriceTag() {
    priceTagList = '${checkList.map((s) => '"$s"').toList()}';
    debugPrint("price Tag  : $priceTagList");
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
    } else if (title == fuelType) {
      fuelTypeIdList.clear();
      fuelTypeIdList.add(id);
      fuelList = '${fuelTypeIdList.map((s) => '$s').toList()}';
      debugPrint("fuel id : $fuelList");
    } else if (title == transmission) {
      transmissionIdList.clear();
      transmissionIdList.add(id);
      transmissionList = '${transmissionIdList.map((s) => '$s').toList()}';
      debugPrint("transmission id : $transmissionList");
    } else if (title == bodyType) {
      bodyTypeIdList.clear();
      bodyTypeIdList.add(id);
      bodyList = '${bodyTypeIdList.map((s) => '$s').toList()}';
      debugPrint("body id : $bodyList");
    }
    notifyListeners();
  }

  getMaxMinRange() {
    minYear = makeYearValues.start.toInt();
    maxYear = makeYearValues.end.toInt();
    minPrice = priceValues.start.toInt();
    maxPrice = priceValues.end.toInt();
    minKm = kmValues.start.toInt();
    maxKm = kmValues.end.toInt();
    notifyListeners();
  }

  //====================================================================
  // API CALLING

  callModelApi(BuildContext context, int id) {
    Future.delayed(Duration.zero, () {
      final dropdownProvider =
          Provider.of<DropdownProvider>(context, listen: false);
      dropdownProvider.getModel(context, RouterHelper.setTriggerScreen, id);
    });
  }

  // ADD TRIGGER
  addTrigger(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint("ad new preferences  ==========================>>>");
        try {
          Response response =
              await apiRepo.postData(context, screen, ApiUrl.addNewTriggerUrl, {
            "make_id": makeList,
            "model_id": modelList,
            "fuel_type_id": fuelList,
            "badge": badgeList,
            "body_type_id": bodyList,
            "transmission_id": transmissionList,
            "from_year": minYear,
            "to_year": maxYear,
            "minimum_price": minPrice,
            "maximum_price": maxPrice,
            "minimum_km": minKm,
            "maximum_km": maxKm,
            "key_word": keyWordsController.text,
            "price_tag": priceTagList,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          newTriggerModel = NewTriggerModel.fromJson(responseBody);
          if (newTriggerModel.error == true) {
            ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(context, newTriggerModel.message!, 1));
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
