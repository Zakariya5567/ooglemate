import 'package:caroogle/data/models/home/source_model.dart';
import 'package:caroogle/data/repository/api_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../data/models/david_recommendation/david_recommendation_model.dart';
import '../data/models/home/mark_model.dart';
import '../helper/connection_checker.dart';
import '../utils/api_url.dart';

class DavidRecommendationScreenProvider extends ChangeNotifier {
  //Instance of model classes
  MarkModel markAsPurchasedModel = MarkModel();
  SourceModel sourceModel = SourceModel();
  MarkModel markAsFavouriteModel = MarkModel();
  DavidRecommendationModel davidRecommendationModel =
      DavidRecommendationModel();

  //Instance of the repository class
  ApiRepo apiRepo = ApiRepo();

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

  //=========================================================
  // Filter SECTION
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

  // Set the item is purchased on the item position
  setPurchase(int index) {
    davidRecommendationModel.data!.rows![index].isPurchased == 0
        ? davidRecommendationModel.data!.rows![index].isPurchased = 1
        : davidRecommendationModel.data!.rows![index].isPurchased = 0;

    notifyListeners();
  }

  // To delete data from favourite , to channge the color of star
  favouriteDeleteById(int id) {
    if (davidRecommendationModel.data != null) {
      for (var element in davidRecommendationModel.data!.rows!) {
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
  setDavidRecommendedTotalPages() {
    if (davidRecommendationModel.data != null ||
        davidRecommendationModel.data!.count != 0) {
      double total;
      total = davidRecommendationModel.data!.count! / 10;
      debugPrint('total is : $total');
      if (davidRecommendationModel.data!.count! > total) {
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

          // setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  //RECOMMENDED
  getDavidRecommended(
      BuildContext context, int pagination, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        pagination == 0 ? setLoading(true) : setPagination(true);

        debugPrint("Get Recommended  ==========================>>>");
        try {
          Response response = await apiRepo
              .getData(context, screen, ApiUrl.getDavidRecommendationUrl, {
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
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          if (pagination == 0 || isSearching == true) {
            davidRecommendationModel =
                DavidRecommendationModel.fromJson(responseBody);
          } else {
            // Adding data to model list
            var newData = DavidRecommendationModel.fromJson(responseBody);
            for (var element in newData.data!.rows!) {
              davidRecommendationModel.data!.rows!.add(element);
            }
          }
          setCount(davidRecommendationModel.data!.count!);
          setDavidRecommendedTotalPages();
          pagination == 0 ? setLoading(false) : setPagination(false);
        } catch (e) {
          pagination == 0 ? setLoading(false) : setPagination(false);
        }

        notifyListeners();
      }
    });
  }

  // MARK AS FAVOURITE
  markAsFavourite(BuildContext context, int id, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        // setLoading(true);

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
          //  setLoading(false);
        } catch (e) {
          //setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  //MARK AS PURCHASED
  markAsPurchased(
      BuildContext context, int id, String price, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        //  setLoading(true);

        debugPrint("mark as purchased  ==========================>>>");
        try {
          Response response = await apiRepo
              .postData(context, screen, ApiUrl.markAsPurchaseUrl, {
            "ad_id": id,
            "purchase_price": price,
            //  "user_preference_id": userPreferenceId
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          markAsPurchasedModel = MarkModel.fromJson(responseBody);
          // setLoading(false);
        } catch (e) {
          //setLoading(false);
        }

        notifyListeners();
      }
    });
  }
}
