import 'package:caroogle/data/models/preferences/all_preferences_model.dart';
import 'package:caroogle/data/models/preferences/delete_model.dart';
import 'package:caroogle/data/models/preferences/enable_disable_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../data/repository/api_repo.dart';
import '../helper/connection_checker.dart';
import '../utils/api_url.dart';
import '../view/widgets/custom_snackbar.dart';

class PreferencesProvider extends ChangeNotifier {
  bool? isLoading;
  bool? isPagination;
  int count = 0;
  int? totalPages;
  int toggleValue = 0;
  bool switchValue = false;
  int? option;
  bool? isSearching;

  //=========================================================

  String? text;
  int? makeId;
  int limit = 10;
  int offset = 0;
  int? modelId;
  int? fuelTypeId;
  int? bodyTypeId;
  String? badge;
  int? exteriorColorId;
  int? transmissionId;
  int? priceMin;
  int? sourceId;
  int? priceMax;
  int? kmMin;
  int? kmMax;
  int? yearMin;
  int? yearMax;
  bool isFilter = false;

  clearFilter() {
    text = null;
    makeId = null;
    modelId = null;
    fuelTypeId = null;
    bodyTypeId = null;
    badge = null;
    exteriorColorId = null;
    transmissionId = null;
    priceMin = null;
    priceMax = null;
    kmMin = null;
    kmMax = null;
    yearMin = null;
    yearMax = null;
    isFilter = false;
    notifyListeners();
  }

  setFilter({
    required newFilter,
    required newText,
    required newMakeId,
    required newModelId,
    required newFuelTypeId,
    required newBodyTypeId,
    required newBadge,
    required newExteriorColorId,
    required newTransmissionId,
    required newPriceMin,
    required newPriceMax,
    required newKmMin,
    required newKmMax,
    required newYearMin,
    required newYearMax,
    required newOffset,
    required newIsSearching,
  }) {
    isFilter = newFilter;
    text = newText;
    makeId = newMakeId;
    modelId = newModelId;
    fuelTypeId = newFuelTypeId;
    bodyTypeId = newBodyTypeId;
    badge = newBadge;
    exteriorColorId = newExteriorColorId;
    transmissionId = newTransmissionId;
    priceMin = newPriceMin;
    priceMax = newPriceMax;
    kmMin = newKmMin;
    kmMax = newKmMax;
    yearMin = newYearMin;
    yearMax = newYearMax;
    offset = 0;
    isSearching = newIsSearching;
    notifyListeners();
  }

  AllPreferencesModel allPreferencesModel = AllPreferencesModel();
  EnableDisableModel enableDisableModel = EnableDisableModel();
  DeleteModel deleteModel = DeleteModel();

  ApiRepo apiRepo = ApiRepo();

  // setSearching user for data searching with keyword
  // isSearching is True  used for searching

  setIsSearching(bool value) {
    isSearching = value;
    notifyListeners();
  }

  setSwitchValue(bool newBool) {
    switchValue = newBool;
    if (switchValue == true) {
      option = 1;
    } else {
      option = 0;
    }
    print(option);
    notifyListeners();
  }

  setNotify(int index) {
    if (enableDisableModel.error == false) {
      allPreferencesModel.data!.rows![index].isEnabled == 0
          ? allPreferencesModel.data!.rows![index].isEnabled = 1
          : allPreferencesModel.data!.rows![index].isEnabled = 0;
    }
    notifyListeners();
  }

  deleteItem(int index) {
    if (deleteModel.error == false) {
      allPreferencesModel.data!.rows!.removeAt(index);
    }
    notifyListeners();
  }

  setToggleValue(int newIndex) {
    toggleValue = newIndex;
    notifyListeners();
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setPagination(bool value) {
    isPagination = value;
    notifyListeners();
  }

  clearOffset() {
    offset = 0;
    notifyListeners();
  }

  incrementOffset() {
    if (offset < totalPages!) {
      offset = offset! + 1;
      debugPrint("offset $offset");
      notifyListeners();
    }
  }

  setCount(int value) {
    count = value;
    notifyListeners();
  }

  setTotalPages() {
    if (allPreferencesModel.data != null ||
        allPreferencesModel.data!.count != 0) {
      double total;
      total = allPreferencesModel.data!.count! / 10;
      debugPrint('total is : $total');
      if (allPreferencesModel.data!.count! > total) {
        totalPages = total.toInt() + 1;
      }
      debugPrint('total is : $totalPages');
    }
  }

//=======================================================================================================================
  //Api

  //BILLING HISTORY
  getAllPreferences(BuildContext context, int pagination, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        pagination == 0 ? setLoading(true) : setPagination(true);

        debugPrint(" all preferences ==========================>>>");
        try {
          Response response = await apiRepo
              .getData(context, screen, ApiUrl.getAllPreferencesUrl, {
            "limit": limit,
            "offset": offset,
            "text": text,
            "order": "desc",
            "make_id": makeId,
            "model_id": modelId,
            "fuel_type_id": fuelTypeId,
            "body_type_id": bodyTypeId,
            "badge": badge,
            "exterior_color_id": exteriorColorId,
            "transmission_id": transmissionId,
            "price_min": priceMin,
            "price_max": priceMax,
            "km_min": kmMin,
            "km_max": kmMax,
            "year_min": yearMin,
            "year_max": yearMax,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          if (pagination == 0 || isSearching == true) {
            allPreferencesModel = AllPreferencesModel.fromJson(responseBody);
            //clearFilter();
          } else {
            var newData = AllPreferencesModel.fromJson(responseBody);

            for (var element in newData.data!.rows!) {
              allPreferencesModel.data!.rows!.add(element);
            }
          }
          setCount(allPreferencesModel.data!.count!);
          setTotalPages();
          pagination == 0 ? setLoading(false) : setPagination(false);
        } catch (e) {
          pagination == 0 ? setLoading(false) : setPagination(false);
        }

        notifyListeners();
      }
    });
  }

  //SINGLE ENABLE DISABLE
  singleEnableDisable(BuildContext context, int preferenceId, int isEnable,
      String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        //   setLoading(true);

        debugPrint(" single enable disable ==========================>>>");
        try {
          Response response = await apiRepo.putData(
              context, screen, ApiUrl.enableDisableSinglePreferencesUrl, {
            "preference_id": preferenceId,
            "option": isEnable,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          enableDisableModel = EnableDisableModel.fromJson(responseBody);
          // setLoading(false);
        } catch (e) {
          // setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  //All ENABLE DISABLE
  allEnableDisable(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint("all enable disable ==========================>>>");
        try {
          Response response = await apiRepo
              .putData(context, screen, ApiUrl.enableDisableAllPreferencesUrl, {
            "option": option,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          enableDisableModel = EnableDisableModel.fromJson(responseBody);
          //  setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  //DELETE ALL PREFERENCES
  deleteAllPreferences(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint("delete all preferences  ==========================>>>");
        try {
          Response response = await apiRepo
              .deleteData(context, screen, ApiUrl.deleteAllPreferencesUrl, {});
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          deleteModel = DeleteModel.fromJson(responseBody);
          //  setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  //DELETE SINGLE PREFERENCES
  deleteSinglePreferences(BuildContext context, int id, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        //  setLoading(true);

        debugPrint("delete single preferences  ==========================>>>");
        try {
          final url = ApiUrl.deleteSinglePreferencesUrl + id.toString();
          Response response =
              await apiRepo.deleteData(context, screen, url, {});
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          deleteModel = DeleteModel.fromJson(responseBody);
          //  setLoading(false);
        } catch (e) {
          // setLoading(false);
        }

        notifyListeners();
      }
    });
  }
}
