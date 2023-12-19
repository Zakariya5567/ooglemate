import 'package:caroogle/data/models/home/mark_model.dart';
import 'package:caroogle/data/models/home/rate_predict_model.dart';
import 'package:caroogle/view/widgets/custom_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/models/home/car_detail_model.dart';
import '../data/models/track/set_track_model.dart';
import '../data/repository/api_repo.dart';
import '../helper/connection_checker.dart';
import '../utils/api_url.dart';
import '../view/widgets/loader_dialog.dart';

class CarDetailProvider extends ChangeNotifier {
  // loading state variable
  bool? isLoading;

  // adId of the item
  int? adId;

  // For rate predict we need data id (item id)
  // id of the item
  int? dataId;

  // isHide user for validation
  bool? isHide;

  // car index is the index of the listed items
  int? carIndex;

  // selection screen is the screen id / to navigate back to those screen
  int? selectedScreen;

  // Instance of the model classes
  CarDetailModel carDetailModel = CarDetailModel();
  SetTrackModel setTrackModel = SetTrackModel();
  RatePredictModel ratePredictModel = RatePredictModel();
  MarkModel markAsPurchasedModel = MarkModel();

  // Instance of the repository class
  ApiRepo apiRepo = ApiRepo();

  // To set the AdId of the item
  setAdId(int newId) {
    debugPrint("add id : $adId}");
    adId = newId;
    notifyListeners();
  }

  // Setting to which item is purchased
  setCarPurchaseIndex(int newIndex) {
    carIndex = newIndex;
    notifyListeners();
  }

  // Setting selection screen

  setSelectedScreen(int newScreen) {
    selectedScreen = newScreen;
    // 1 HOME SCREEN
    // 2 DAVID SCREEN
    // 3 INVENTORY SIMILAR SCREEN
    // 4 TRACKED SCREEN
    // 5 TRIGGER COUNT SCREEN
    // 6 NOTIFICATION SCREEN
    // 7 GLOBAL SEARCH SCREEN

    notifyListeners();
  }

  // Method to hide and show the validation
  // true show , false hide
  setHide(bool value) {
    isHide = value;
    notifyListeners();
  }

  // Set the id of the item
  setDataId(int newId) {
    debugPrint("data id : $dataId}");
    dataId = newId;
    notifyListeners();
  }

  // To set the state of the loading
  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  bool? isDialogLoading;
  // Dialog loading
  setDialogLoading(BuildContext context, bool value) {
    isDialogLoading = value;
    if (value == true) {
      loaderDialog(context);
    } else {
      Navigator.of(context).pop();
    }
    notifyListeners();
  }

  // To set data is purchased
  setPurchase() {
    if (markAsPurchasedModel.error == false) {
      carDetailModel.data!.isPurchase == 0
          ? carDetailModel.data!.isPurchase = 1
          : carDetailModel.data!.isPurchase = 0;
    }
    notifyListeners();
  }

  //============================================================================
  // API

  //CAR DETAIL
  getCarDetail(BuildContext context, int? adId, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint(" get car detail  ==========================>>>");

        try {
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.carDetailUrl, {
            "ad_id": adId.toString(),
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          carDetailModel = CarDetailModel.fromJson(responseBody);
          setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  //SET TRACK CAR
  setTrackCar(BuildContext context, int adId, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setDialogLoading(context, true);

        debugPrint("isDialog loading: $isDialogLoading");
        debugPrint("set track car  ==========================>>>");

        try {
          Response response =
              await apiRepo.postData(context, screen, ApiUrl.setTrackUrl, {
            "ad_id": adId.toString(),
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          setTrackModel = SetTrackModel.fromJson(responseBody);

          ScaffoldMessenger.of(context)
              .showSnackBar(customSnackBar(context, setTrackModel.message!, 0));

          setDialogLoading(context, false);
        } catch (e) {
          setDialogLoading(context, false);
        }

        notifyListeners();
      }
    });
  }

  //RATE PREDICT CAR
  ratePredict(
      BuildContext context, int id, int ratePredict, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        debugPrint("Rate predict  ==========================>>>");
        try {
          Response response =
              await apiRepo.postData(context, screen, ApiUrl.ratePredictUrl, {
            "id": id.toString(),
            "rate_predict": ratePredict,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          ratePredictModel = RatePredictModel.fromJson(responseBody);
          if (ratePredictModel.error == false) {
            ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(context, ratePredictModel.message!, 0));
          }
        } catch (e) {
          debugPrint(e.toString());
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
