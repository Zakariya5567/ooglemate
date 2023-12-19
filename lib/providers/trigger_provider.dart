import 'package:caroogle/data/models/trigger/add_new_trigger_model.dart';
import 'package:caroogle/data/models/trigger/all_trigger_model.dart';
import 'package:caroogle/data/models/trigger/carin_trigger_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../data/models/home/source_model.dart';
import '../data/models/trigger/delete_trigger_model.dart';
import '../data/repository/api_repo.dart';
import '../helper/connection_checker.dart';
import '../utils/api_url.dart';

class TriggerProvider extends ChangeNotifier {
  int titleListIndex = 0;

  bool? isLoading;
  bool? isPagination;
  int count = 0;
  int? totalPages;
  int? triggerId;

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
  // String? price;
  // String? factor;

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

  AllTriggerModel allTriggerModel = AllTriggerModel();
  CarinTriggerModel carinTriggerModel = CarinTriggerModel();
  NewTriggerModel newTriggerModel = NewTriggerModel();
  DeleteTriggerModel deleteTriggerModel = DeleteTriggerModel();
  SourceModel sourceModel = SourceModel();

  ApiRepo apiRepo = ApiRepo();

  // setSearching user for data searching with keyword
  // isSearching is True  used for searching

  setIsSearching(bool value) {
    isSearching = value;
    notifyListeners();
  }

  setTitleListIndex(int newIndex, int id) {
    titleListIndex = newIndex;
    sourceId = id;
    notifyListeners();
  }

  deleteItem(int index) {
    if (deleteTriggerModel.error == false) {
      allTriggerModel.data!.rows!.removeAt(index);
    }
    notifyListeners();
  }

  clearTitleIndex() {
    titleListIndex = 0;
    sourceId = sourceModel.data![0].sourceId;
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

  setCount(int value) {
    count = value;
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

  setTotalPages() {
    if (allTriggerModel.data != null || allTriggerModel.data!.count != 0) {
      double total;
      total = allTriggerModel.data!.count! / 10;
      debugPrint('total is : $total');
      if (allTriggerModel.data!.count! > total) {
        totalPages = total.toInt() + 1;
      }
      debugPrint('total is : $totalPages');
    }
  }

  setTriggerId(int newId) {
    triggerId = newId;
    notifyListeners();
  }

//=======================================================================================================================
  //Api

  //TRACKED CAR
  getAllTrigger(BuildContext context, int pagination, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        pagination == 0 ? setLoading(true) : setPagination(true);

        debugPrint(" get all trigger  ==========================>>>");

        try {
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.allTriggerUrl, {
            "limit": limit,
            "offset": offset,
            "order": "desc",
            "text": text,
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
            allTriggerModel = AllTriggerModel.fromJson(responseBody);
          } else {
            var newData = AllTriggerModel.fromJson(responseBody);

            for (var element in newData.data!.rows!) {
              allTriggerModel.data!.rows!.add(element);
            }
          }
          setCount(allTriggerModel.data!.count!);
          setTotalPages();
          pagination == 0 ? setLoading(false) : setPagination(false);
        } catch (e) {
          pagination == 0 ? setLoading(false) : setPagination(false);
        }

        notifyListeners();
      }
    });
  }

  //CAR IN TRIGGER
  getCarInTrigger(BuildContext context, int pagination, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        pagination == 0 ? setLoading(true) : setPagination(true);

        debugPrint("car in trigger  ==========================>>>");
        try {
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.carinTriggerUrl, {
            "limit": limit,
            "offset": offset,
            "order": "desc",
            "trigger_id": triggerId.toString(),
            "text": text,
            "make_id": makeId,
            "model_id": modelId,
            "fuel_type_id": fuelTypeId,
            "body_type_id": bodyTypeId,
            "badge": badge,
            "exterior_color_id": exteriorColorId,
            "transmission_id": transmissionId,
            "source_id": sourceId,
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
            carinTriggerModel = CarinTriggerModel.fromJson(responseBody);
          } else {
            var newData = CarinTriggerModel.fromJson(responseBody);

            for (var element in newData.data!.rows!) {
              carinTriggerModel.data!.rows!.add(element);
            }
          }
          setCount(carinTriggerModel.data!.count!);
          setTotalPages();
          pagination == 0 ? setLoading(false) : setPagination(false);
        } catch (e) {
          pagination == 0 ? setLoading(false) : setPagination(false);
        }

        notifyListeners();
      }
    });
  }

  //DELETE TRIGGER
  deleteTrigger(BuildContext context, int id, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        // setLoading(true);

        debugPrint("delete trigger  ==========================>>>");
        final url = ApiUrl.deleteTriggerUrl + id.toString();
        try {
          Response response =
              await apiRepo.deleteData(context, screen, url, {});
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          deleteTriggerModel = DeleteTriggerModel.fromJson(responseBody);
          //  setLoading(false);
        } catch (e) {
          // setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  //CAR SOURCE
  Future<void> getSource(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint("Source  ==========================>>>");
        try {
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.getSourceUrl, {});
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          sourceModel = SourceModel.fromJson(responseBody);
          int? othersId;
          sourceModel.data!.asMap().forEach((index, element) {
            if (element.source!.toLowerCase() == "others") {
              othersId = element.sourceId!;
            }
          });

          sourceModel.data!.removeWhere((element) {
            return element.source!.toLowerCase() == "facebook";
          });

          sourceModel.data!.removeWhere((element) {
            return element.source!.toLowerCase() == "others";
          });

          sourceModel.data!.add(Datum(source: "Others", sourceId: othersId));
          setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }
}
