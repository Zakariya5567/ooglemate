import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../data/models/global_search/global_seach_model.dart';
import '../data/models/home/mark_model.dart';
import '../data/models/home/source_model.dart';
import '../data/repository/api_repo.dart';
import '../helper/connection_checker.dart';
import '../utils/api_url.dart';

class GlobalScreenProvider extends ChangeNotifier {
  int purchase = 0;
  int titleListIndex = 0;
  int? purchaseIndex;
  bool? isLoading;
  bool? isPagination;
  int limit = 10;
  int offset = 0;
  int count = 0;
  int? totalPages;
  int? adId;
  bool? isSearching;

  //toggle index is the selected button of price tag
  // 0 low , 1 good, 2 best
  int? toggleIndex;

  //=========================================================
  // Filter SECTION
  String? priceTag;
  String? text;
  int? makeId;
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

  // To clear filter of the screen

  clearFilter() {
    text = null;
    makeId = null;
    limit = isFilter == true ? 10 : limit;
    offset = 0;
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

  // to set filter for the screen
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

  //===========================================================================

  //Instance of model classes
  MarkModel markAsPurchasedModel = MarkModel();
  SourceModel sourceModel = SourceModel();
  MarkModel markAsFavouriteModel = MarkModel();
  GlobalSearchModel globalSearchModel = GlobalSearchModel();

  //Instance of the repository class
  ApiRepo apiRepo = ApiRepo();

  // Set loading state
  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // setSearching user for data searching with keyword
  // isSearching is True  used for searching

  setIsSearching(bool value) {
    isSearching = value;
    notifyListeners();
  }

  // toggle index is to set price tag button
  setToggleIndex(int newIndex) {
    if (toggleIndex == newIndex) {
      toggleIndex = null;
      priceTag = null;
    } else {
      toggleIndex = newIndex;
      if (toggleIndex == 0) {
        priceTag = "low";
      }
      if (toggleIndex == 1) {
        priceTag = "good";
      }
      if (toggleIndex == 2) {
        priceTag = "best";
      }
    }

    debugPrint("Price tag :  $priceTag");
    notifyListeners();
  }

  // Set the item is purchased on the item position
  setPurchase(int index) {
    globalSearchModel.data!.rows![index].isPurchased == 0
        ? globalSearchModel.data!.rows![index].isPurchased = 1
        : globalSearchModel.data!.rows![index].isPurchased = 0;

    notifyListeners();
  }

  // To delete data from favourite , to change the color of star
  favouriteDeleteById(int id) {
    if (globalSearchModel.data != null) {
      for (var element in globalSearchModel.data!.rows!) {
        if (element.adId == id) {
          element.isFavourite = 0;
        }
      }
    }

    notifyListeners();
  }

  // To set item adId
  setAdId(int newId) {
    adId = newId;
    notifyListeners();
  }

  // Highlight the source item on selected position
  setTitleListIndex(int newIndex, int id) {
    titleListIndex = newIndex;
    sourceId = id;
    notifyListeners();
  }

  // To clear the source to 0
  // User first time Navigate to the screen the first source will be selected
  clearTitleIndex() {
    titleListIndex = 0;
    sourceId = sourceModel.data![0].sourceId;
    notifyListeners();
  }

  resetPriceTag() {
    priceTag = null;
    toggleIndex = null;
    notifyListeners();
  }

  // To set the purchased on the item index
  setPurchaseIndex(int newIndex) {
    purchaseIndex = newIndex;
    notifyListeners();
  }

  //=========================================================================
  //PAGINATION SECTION

// set loader for pagination
  setPagination(bool value) {
    isPagination = value;
    notifyListeners();
  }

  // Clear offset of the pagination
  clearOffset() {
    offset = 0;
    notifyListeners();
  }

  // to set the limit of the pagination
  setLimit() {
    limit = limit;
    debugPrint("limit $limit");
    notifyListeners();
  }

  // Incrementing offset
  incrementOffset() {
    if (offset < totalPages!) {
      offset = offset! + 1;
      debugPrint("offset $offset");
      notifyListeners();
    }
  }

  // Set total data in apis
  setCount(int value) {
    count = value;
    notifyListeners();
  }

  // To find total pages according to limits
  setTotalPages() {
    if (globalSearchModel.data != null || globalSearchModel.data!.count != 0) {
      double total;
      total = globalSearchModel.data!.count! / 10;
      debugPrint('total is : $total');
      if (globalSearchModel.data!.count! > total) {
        totalPages = total.toInt() + 1;
      }
      debugPrint('total is : $totalPages');
    }
  }

  // ===========================================================================
  // API CALLING

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

          //setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  //RECOMMENDED
  Future<void> getGlobalSearchData(
      BuildContext context, int pagination, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        pagination == 0 ? setLoading(true) : setPagination(true);

        debugPrint("Get Global search  ==========================>>>");
        try {
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.globalSearchUrl, {
            "offset": offset,
            "order": "desc",
            "text": text,
            "make_id": makeId,
            "limit": limit,
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
            "price_tag": priceTag,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          if (pagination == 0 || isSearching == true) {
            globalSearchModel = GlobalSearchModel.fromJson(responseBody);
          } else {
            // Adding data to model list
            var newData = GlobalSearchModel.fromJson(responseBody);
            for (var element in newData.data!.rows!) {
              globalSearchModel.data!.rows!.add(element);
            }
          }
          setCount(globalSearchModel.data!.count!);
          setTotalPages();
          pagination == 0 ? setLoading(false) : setPagination(false);
        } catch (e) {
          pagination == 0 ? setLoading(false) : setPagination(false);
        }

        notifyListeners();
      }
    });
  }

  // MARK AS FAVOURITE
  Future<void> markAsFavourite(
      BuildContext context, int id, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        debugPrint(" mark as favourite ==========================>>>");
        debugPrint(" ad_id : $id");
        try {
          Response response = await apiRepo
              .postData(context, screen, ApiUrl.markAsFavouriteUrl, {
            "ad_id": id,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          markAsFavouriteModel = MarkModel.fromJson(responseBody);
        } catch (e) {
          debugPrint(e.toString());
        }

        notifyListeners();
      }
    });
  }

  //MARK AS PURCHASED
  Future<void> markAsPurchased(
      BuildContext context, int id, String price, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        debugPrint("mark as purchased  ==========================>>>");
        try {
          Response response = await apiRepo
              .postData(context, screen, ApiUrl.markAsPurchaseUrl, {
            "ad_id": id,
            "purchase_price": price,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          markAsPurchasedModel = MarkModel.fromJson(responseBody);
        } catch (e) {
          debugPrint(e.toString());
        }

        notifyListeners();
      }
    });
  }
}
