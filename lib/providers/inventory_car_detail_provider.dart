import 'package:caroogle/data/models/inventories/markAsSold.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../data/models/home/car_detail_model.dart';
import '../data/models/home/mark_model.dart';
import '../data/models/inventories/similar_car_model.dart';
import '../data/repository/api_repo.dart';
import '../helper/connection_checker.dart';
import '../utils/api_url.dart';

class InventoryCarDetailProvider extends ChangeNotifier {
  int sold = 0;
  bool? isLoading;
  bool? isPagination;
  int? adId;
  int? inventoryId;
  int count = 0;
  int? totalPages;
  int limit = 10;
  int offset = 0;

  CarDetailModel carDetailModel = CarDetailModel();
  MarkAsSoldModel markAsSoldModel = MarkAsSoldModel();
  SimilarCarModel similarCarModel = SimilarCarModel();

  ApiRepo apiRepo = ApiRepo();

  setAdId(int newId) {
    adId = newId;
    notifyListeners();
  }

  setInventoryId(int newId) {
    inventoryId = newId;
    notifyListeners();
  }

  setSold() {
    carDetailModel.data!.isSold == 0
        ? carDetailModel.data!.isSold = 1
        : carDetailModel.data!.isSold = 0;

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

  setLimit() {
    limit = limit;
    debugPrint("limit $limit");
    notifyListeners();
  }

  incrementOffset() {
    if (offset < totalPages!) offset = offset! + 1;
    debugPrint("offset $offset");
    notifyListeners();
  }

  decrementOffset() {
    if (offset > 0) {
      offset = offset! - 1;
    }
    debugPrint("offset $offset");
    notifyListeners();
  }

  setCount(int value) {
    count = value;
    notifyListeners();
  }

  setTotalPages() {
    if (similarCarModel.data != null || similarCarModel.data!.count != 0) {
      double total;
      total = similarCarModel.data!.count! / 10;
      debugPrint('total is : $total');
      if (similarCarModel.data!.count! > total) {
        totalPages = total.toInt() + 1;
      }
      debugPrint('total is : $totalPages');
    }
  }

  //============================================================================
  // API

  //CAR DETAIL
  getCarDetail(BuildContext context, int adId, String screen) async {
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

  //SIMILAR CAR
  getSimilarCar(BuildContext context, int pagination, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        pagination == 0 ? setLoading(true) : setPagination(true);

        debugPrint(" get all trigger  ==========================>>>");

        String url = "${ApiUrl.similarCarInventoriesUrl}$adId";
        try {
          Response response = await apiRepo.getData(context, screen, url,
              {"limit": limit.toString(), "offset": offset, "order": "desc"});
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          if (pagination == 0) {
            similarCarModel = SimilarCarModel.fromJson(responseBody);
          } else {
            var newData = SimilarCarModel.fromJson(responseBody);

            for (var element in newData.data!.rows!) {
              similarCarModel.data!.rows!.add(element);
            }
          }
          setCount(similarCarModel.data!.count!);
          setTotalPages();
          pagination == 0 ? setLoading(false) : setPagination(false);
        } catch (e) {
          pagination == 0 ? setLoading(false) : setPagination(false);
        }

        notifyListeners();
      }
    });
  }

  //MARK AS SOLD
  markAsSold(BuildContext context, int id, String price, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        //   setLoading(true);

        debugPrint("mark as sold  ==========================>>>");
        try {
          Response response = await apiRepo.postData(
              context,
              screen,
              ApiUrl.markAsSoldUrl,
              {"inventory_id": id, "selling_price": price});
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          markAsSoldModel = MarkAsSoldModel.fromJson(responseBody);
          //  setLoading(false);
        } catch (e) {
          // setLoading(false);
        }

        notifyListeners();
      }
    });
  }
}
