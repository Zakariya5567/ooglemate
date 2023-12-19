import 'package:caroogle/data/models/track/all_tracked_car_model.dart';
import 'package:caroogle/data/models/track/delete_track_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../data/repository/api_repo.dart';
import '../helper/connection_checker.dart';
import '../utils/api_url.dart';

class TrackedProvider extends ChangeNotifier {
  int currentIndex = 0;
  bool? isLoading;
  bool? isPagination;
  int count = 0;
  int? totalPages;

  bool? isSearching;

  //
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

  //==========================================================================

  AllTrackedCarModel allTrackedCarModel = AllTrackedCarModel();
  DeleteTrackModel deleteTrackModel = DeleteTrackModel();

  ApiRepo apiRepo = ApiRepo();

  // setSearching user for data searching with keyword
  // isSearching is True  used for searching

  setIsSearching(bool value) {
    isSearching = value;
    notifyListeners();
  }

  deleteItem(int index) {
    if (deleteTrackModel.error == false) {
      allTrackedCarModel.data!.rows!.removeAt(index);
    }
    notifyListeners();
  }

  setCount(int value) {
    count = value;
    notifyListeners();
  }

  setTotalPages() {
    if (allTrackedCarModel.data != null ||
        allTrackedCarModel.data!.count != 0) {
      double total;
      total = allTrackedCarModel.data!.count! / 10;
      debugPrint('total is : $total');
      if (allTrackedCarModel.data!.count! > total) {
        totalPages = total.toInt() + 1;
      }
      debugPrint('total is : $totalPages');
    }
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

  setNavigationIndex(int newIndex) {
    currentIndex = newIndex;
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

  setMakeId(int newId) {
    makeId = newId;
    notifyListeners();
  }

//=======================================================================================================================
  //Api

  //GET TRACK CAR
  getAllTrack(BuildContext context, int pagination, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        pagination == 0 ? setLoading(true) : setPagination(true);

        debugPrint(" get all tracked  ==========================>>>");
        try {
          final response =
              await apiRepo.getData(context, screen, ApiUrl.allTrackUrl, {
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
          final responseBody = response!.data;
          debugPrint("response body ===============>>> $responseBody");

          if (pagination == 0 || isSearching == true) {
            allTrackedCarModel = AllTrackedCarModel.fromJson(responseBody);
          } else {
            var newData = AllTrackedCarModel.fromJson(responseBody);

            for (var element in newData.data!.rows!) {
              allTrackedCarModel.data!.rows!.add(element);
            }
          }
          setCount(allTrackedCarModel.data!.count!);
          setTotalPages();
          pagination == 0 ? setLoading(false) : setPagination(false);
        } catch (e) {
          pagination == 0 ? setLoading(false) : setPagination(false);
        }

        notifyListeners();
      }
    });
  }

  //DELETE TRACK CAR
  deleteTrackCar(BuildContext context, int trackedId, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        //  setLoading(true);

        debugPrint("tracked_id: $trackedId");
        debugPrint("delete track car  ==========================>>>");

        try {
          Response response =
              await apiRepo.deleteData(context, screen, ApiUrl.deleteTrackUrl, {
            "tracked_id": trackedId,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          deleteTrackModel = DeleteTrackModel.fromJson(responseBody);
          //  setLoading(false);
        } catch (e) {
          // setLoading(false);
        }

        notifyListeners();
      }
    });
  }
}
