import 'dart:io';

import 'package:caroogle/data/models/inventories/all_inventories_model.dart';
import 'package:caroogle/data/models/inventories/markAsSold.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/models/home/source_model.dart';
import '../data/repository/api_repo.dart';
import '../helper/connection_checker.dart';
import '../utils/api_url.dart';

class InventoryProvider extends ChangeNotifier {
  int titleIndex = 0;
  int addNewToggleValue = 0;
  bool? isLoading;
  bool? isPagination;
  int count = 0;
  int toggleIndex = 0;
  int? totalPages;
  int? sellingPrice;

  bool? isSearching;

  //=========================================================
  String type = "all";
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
  int? sourceId;
  int? priceMin;
  int? priceMax;
  int? kmMin;
  int? kmMax;
  int? yearMin;
  int? yearMax;
  bool isFilter = false;
  // String? price;
  // String? factor;

  clearFilter() {
    type = type;
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
    required newType,
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
    type = newType;
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

  //=========================================================

  InventoriesModel inventoryModel = InventoriesModel();
  MarkAsSoldModel markAsSoldModel = MarkAsSoldModel();
  SourceModel sourceModel = SourceModel();

  ApiRepo apiRepo = ApiRepo();

  // setSearching user for data searching with keyword
  // isSearching is True  used for searching

  setIsSearching(bool value) {
    isSearching = value;
    notifyListeners();
  }

  setTotalPages() {
    if (inventoryModel.data != null || inventoryModel.data!.count != 0) {
      double total;
      total = inventoryModel.data!.count! / 10;
      debugPrint('total is : $total');
      if (inventoryModel.data!.count! > total) {
        totalPages = total.toInt() + 1;
      }
      debugPrint('total is : $totalPages');
    }
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

  setAddNewToggleValue(int newIndex) {
    addNewToggleValue = newIndex;
    notifyListeners();
  }

  clearOffset() {
    offset = 0;
    notifyListeners();
  }

  setTitleIndex(int newIndex, int id) {
    titleIndex = newIndex;
    sourceId = id;
    notifyListeners();
  }

  clearTitleIndex() {
    titleIndex = 0;
    sourceId = sourceModel.data![0].sourceId;
    notifyListeners();
  }

  setToggleIndex(int newIndex) {
    toggleIndex = newIndex;
    if (toggleIndex == 0) {
      type = "all";
    }
    if (toggleIndex == 1) {
      type = "purchased";
    }
    if (toggleIndex == 2) {
      type = "sold";
    }
    debugPrint("type $type");
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

  setSellingPrice(int price) {
    sellingPrice = price;
    notifyListeners();
  }

//=======================================================================================================================
  //Api

  //GET ALL INVENTORIES
  getAllInventories(BuildContext context, int pagination, String screen) async {
    return checkInternet(context, screen).then((value) async {
      debugPrint("type $type");
      if (value == true) {
        pagination == 0 ? setLoading(true) : setPagination(true);

        debugPrint("PaginationLoading: $isLoading");
        debugPrint(" get all inventories  ==========================>>>");
        try {
          Response response = await apiRepo.getData(
              context,
              screen,
              ApiUrl.allInventoriesUrl,

              // sourceId == 7
              //     ? {
              //         "limit": limit,
              //         "offset": offset,
              //         "type": type,
              //         "text": text,
              //         "order": "desc",
              //         "make_id": makeId,
              //         "model_id": modelId,
              //         "fuel_type_id": fuelTypeId,
              //         "body_type_id": bodyTypeId,
              //         "badge": badge,
              //         "exterior_color_id": exteriorColorId,
              //         "transmission_id": transmissionId,
              //         "price_min": priceMin,
              //         "price_max": priceMax,
              //         "km_min": kmMin,
              //         "km_max": kmMax,
              //         "year_min": yearMax,
              //         "year_max": yearMin,
              //       }
              //     :

              {
                "limit": limit,
                "offset": offset,
                "type": type,
                "text": text,
                "order": "desc",
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
                "year_min": yearMax,
                "year_max": yearMin,
              });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          if (pagination == 0 || isSearching == true) {
            inventoryModel = InventoriesModel.fromJson(responseBody);
          } else {
            var newData = InventoriesModel.fromJson(responseBody);

            for (var element in newData.data!.rows!) {
              inventoryModel.data!.rows!.add(element);
            }
          }
          setCount(inventoryModel.data!.count!);
          setTotalPages();
          pagination == 0 ? setLoading(false) : setPagination(false);

          debugPrint("PaginationLoading: $isLoading");
        } catch (e) {
          pagination == 0 ? setLoading(false) : setPagination(false);

          debugPrint("PaginationLoading: $isLoading");
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
          //setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

//===========================================================================================================================
// pdf converter
}
