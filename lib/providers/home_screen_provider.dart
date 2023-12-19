import 'package:caroogle/data/models/home/all_matches_model.dart';
import 'package:caroogle/data/models/home/recommended_model.dart';
import 'package:caroogle/data/models/home/source_model.dart';
import 'package:caroogle/data/repository/api_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../data/models/home/mark_model.dart';
import '../helper/connection_checker.dart';
import '../utils/api_url.dart';

class HomeScreenProvider extends ChangeNotifier {
  // Instance of the model class
  MarkModel markAsPurchasedModel = MarkModel();
  SourceModel sourceModel = SourceModel();
  MarkModel markAsFavouriteModel = MarkModel();
  RecommendedModel recommendationModel = RecommendedModel();
  AllMatchesModel allMatchesModel = AllMatchesModel();

  // Instance of the repository class
  ApiRepo apiRepo = ApiRepo();

  //toggle index is the selected index of the toggle button ( 0 = recommended and  1 = all matches 0
  //titleListIndex is the index of the source
  //purchase index is the index of the item which user want to purchase (on item click we are setting the index of the index to make it mark as purchase)

  int toggleIndex = 0;
  int titleListIndex = 0;
  int? purchaseIndex;

  // isLoading variable is declared for loading state of the API
  // When we call Api we are setting loader or shimmer
  // isLoading == true its means we will show loader
  // if loading false we will finish loader and show UI

  bool? isLoading;

  // isPagination variable is declared for loading state of the API for pagination
  // When we call Api we are setting loader or shimmer
  // isPagination == true its means we will show loader
  // if isPagination false we will finish loader and show UI

  bool? isPagination;

  // isSearching is define to identify the user is searching or  not
  // isSearching true user is searching,
  bool? isSearching;

  // Used for pagination
  // limit is the limit of the data per page
  // offset is the number of page
  // count is the total item of the list
  // totalPages is the total pages is getting from all count
  int limit = 10;
  int offset = 0;
  int count = 0;
  int? totalPages;

  // Id of the ad
  int? adId;

  //=========================================================
  // Filter data
  // text is a searching keyword

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

  // to identify the user is from filter screen or not
  bool isFilter = false;

  // clear filter data
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

  // set the value to the above variable
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

  // clear offset of the pagination
  clearOffset() {
    offset = 0;
    notifyListeners();
  }

  // toggle button (recommended , all matches) selection function.
  // index 0 recommended and 1 for all matches

  setToggle(int newIndex) {
    toggleIndex = newIndex;
    notifyListeners();
  }

  // setSearching user for data searching with keyword
  // isSearching is True  used for searching
  setIsSearching(bool value) {
    isSearching = value;
    notifyListeners();
  }

  // To set ad id
  setAdId(int newId) {
    adId = newId;
    debugPrint("Ad id : $adId}");
    notifyListeners();
  }

  // set source index
  setTitleListIndex(int newIndex, int id) {
    titleListIndex = newIndex;
    sourceId = id;
    notifyListeners();
  }

  // clear  source index
  clearTitleIndex() {
    titleListIndex = 0;
    sourceId = sourceModel.data![0].sourceId;
    notifyListeners();
  }

  // set item to purchase

  setPurchase(int index) {
    // checking for the index (0 recommended , 1 all matches)
    if (toggleIndex == 0) {
      recommendationModel.data!.rows![index].isPurchase == 0
          ? recommendationModel.data!.rows![index].isPurchase = 1
          : recommendationModel.data!.rows![index].isPurchase = 0;
    } else {
      allMatchesModel.data!.rows![index].isPurchase == 0
          ? allMatchesModel.data!.rows![index].isPurchase = 1
          : allMatchesModel.data!.rows![index].isPurchase = 0;
    }

    notifyListeners();
  }

  // set the item of index
  setPurchaseIndex(int newIndex) {
    purchaseIndex = newIndex;
    notifyListeners();
  }

  // To set a data mark as favourite
  favouriteDeleteById(int id) {
    // checking for the index (0 recommended , 1 all matches)
    if (toggleIndex == 0) {
      if (recommendationModel.data != null) {
        // if id found in the recommended model we will set it to favourite
        for (var element in recommendationModel.data!.rows!) {
          if (element.adId == id) {
            element.isFavourite = 0;
          }
        }
      }
    } else if (toggleIndex == 1) {
      if (allMatchesModel.data != null) {
        // if id found in the allMatchesModel  we will set it to favourite
        for (var element in allMatchesModel.data!.rows!) {
          if (element.adId == id) {
            element.isFavourite = 0;
          }
        }
      }
    }
    notifyListeners();
  }

  // Methods to set the state of loading
  // Assigning values to isLoading variable
  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Methods to set the state of pagination loading
  // Assigning values to isPagination variable
  setPagination(bool value) {
    isPagination = value;
    notifyListeners();
  }

  // increment the offset to when user scroll up
  incrementOffset() {
    if (offset < totalPages!) {
      offset = offset + 1;
      debugPrint("offset $offset");
      notifyListeners();
    }
  }

  // Set total item is to count variable
  setCount(int value) {
    count = value;
    notifyListeners();
  }

  // Set total pages for recommended
  setRecommendedTotalPages() {
    if (recommendationModel.data != null ||
        recommendationModel.data!.count != 0) {
      double total;
      total = recommendationModel.data!.count! / 10;
      debugPrint('total is : $total');
      if (recommendationModel.data!.count! > total) {
        totalPages = total.toInt() + 1;
      }
      debugPrint('total is : $totalPages');
    }
  }

  // Set total pages for all matches
  setMatchesTotalPages() {
    if (allMatchesModel.data != null || allMatchesModel.data!.count != 0) {
      double total;
      total = allMatchesModel.data!.count! / 10;
      debugPrint('total is : $total');
      if (allMatchesModel.data!.count! > total) {
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
        //set loading sate to true
        setLoading(true);
        debugPrint("Source  ==========================>>>");

        try {
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.getSourceUrl, {});
          final responseBody = response.data;
          debugPrint("Source response body ===============>>> $responseBody");

          // assign response to the model
          sourceModel = SourceModel.fromJson(responseBody);

          //
          int? othersId;

          // get the order id from the list
          sourceModel.data!.asMap().forEach((index, element) {
            if (element.source!.toLowerCase() == "others") {
              othersId = element.sourceId!;
            }
          });

          // remove facebook from the list

          sourceModel.data!.removeWhere((element) {
            return element.source!.toLowerCase() == "facebook";
          });

          // remove others from the list

          sourceModel.data!.removeWhere((element) {
            return element.source!.toLowerCase() == "others";
          });

          // add other to  list  at the last index
          sourceModel.data!.add(Datum(source: "Others", sourceId: othersId));
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  //RECOMMENDED
  Future<void> getRecommended(
      BuildContext context, int pagination, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        // Pagination 1 is used for pagination and 0 is for not pagination
        pagination == 0 ? setLoading(true) : setPagination(true);

        debugPrint("Get Recommended  ==========================>>>");
        try {
          // calling post method of the repository
          Response response = await apiRepo
              .getData(context, screen, ApiUrl.getRecommendationUrl, {
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

          // store response in variable
          final responseBody = response.data;
          debugPrint(
              "recommended response body ===============>>> $responseBody");

          // Check for pagination
          // if pagination is 0 we will set data to model
          // if pagination is 1 we will add getting data to to model list

          if (pagination == 0 || isSearching == true) {
            recommendationModel = RecommendedModel.fromJson(responseBody);
          } else {
            // store model in new variable
            var newData = RecommendedModel.fromJson(responseBody);

            // add data to the model list
            for (var element in newData.data!.rows!) {
              recommendationModel.data!.rows!.add(element);
            }
          }

          // set count of the recommendationModel
          setCount(recommendationModel.data!.count!);

          // set total pages of the recommendationModel
          setRecommendedTotalPages();

          pagination == 0 ? setLoading(false) : setPagination(false);
        } catch (e) {
          pagination == 0 ? setLoading(false) : setPagination(false);
        }

        notifyListeners();
      }
    });
  }

  //ALL MATCHES
  Future<void> getAllMatches(
      BuildContext context, int pagination, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        // Pagination 1 is used for pagination and 0 is for not pagination
        pagination == 0 ? setLoading(true) : setPagination(true);

        debugPrint("Get All Matches ==========================>>>");
        try {
          // calling post method of the repository
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.getAllMatchesUrl, {
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

          // store response in variable
          final responseBody = response.data;
          debugPrint(
              "all matches response body ===============>>> $responseBody");

          // Check for pagination
          // if pagination is 0 we will set data to model
          // if pagination is 1 we will add getting data to to model list

          if (pagination == 0 || isSearching == true) {
            allMatchesModel = AllMatchesModel.fromJson(responseBody);
          } else {
            // store model in new variable
            var newData = AllMatchesModel.fromJson(responseBody);

            // add data to the model list
            for (var element in newData.data!.rows!) {
              allMatchesModel.data!.rows!.add(element);
            }
          }

          // set count of the recommendationModel
          setCount(allMatchesModel.data!.count!);

          // set total pages of the recommendationModel
          setMatchesTotalPages();

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
        debugPrint(" mark as favourite ==========================>>>");
        debugPrint(" ad_id : $id");

        try {
          // calling post method of the repository
          Response response = await apiRepo
              .postData(context, screen, ApiUrl.markAsFavouriteUrl, {
            "ad_id": id,
          });

          // store response in variable
          final responseBody = response.data;

          debugPrint("response body ===============>>> $responseBody");

          // store response in model class
          markAsFavouriteModel = MarkModel.fromJson(responseBody);
        } catch (e) {
          setLoading(false);
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
        debugPrint("mark as purchased  ==========================>>>");
        try {
          // calling post method of the repository
          Response response = await apiRepo
              .postData(context, screen, ApiUrl.markAsPurchaseUrl, {
            "ad_id": id,
            "purchase_price": price,
          });

          // store response in variable
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");

          // store response in model class
          markAsPurchasedModel = MarkModel.fromJson(responseBody);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }
}
