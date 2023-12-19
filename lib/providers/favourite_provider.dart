import 'package:caroogle/data/models/home/favourite_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../data/models/home/mark_model.dart';
import '../data/repository/api_repo.dart';
import '../helper/connection_checker.dart';
import '../utils/api_url.dart';

class FavouriteProvider extends ChangeNotifier {
  bool? isLoading;
  bool? isPagination;
  int limit = 10;
  int count = 0;
  int? totalPages;
  int? listIndex;
  int offset = 0;

  FavouriteModel favouriteModel = FavouriteModel();
  MarkModel markAsFavouriteModel = MarkModel();

  ApiRepo apiRepo = ApiRepo();

  // set loading
  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // delete the item from the list
  deleteItem(int index) {
    if (markAsFavouriteModel.error == false) {
      favouriteModel.data!.rows!.removeAt(index);
    }
    notifyListeners();
  }

  // set loading of the pagination

  setPagination(bool value) {
    isPagination = value;
    notifyListeners();
  }

  // clear offset of the pagination
  clearOffset() {
    offset = 0;
    notifyListeners();
  }

  // increment offset of the pagination
  incrementOffset() {
    if (offset < totalPages!) {
      offset = offset + 1;
      debugPrint("offset $offset");
      notifyListeners();
    }
  }

  // set total count of the list
  setCount(int value) {
    count = value;
    notifyListeners();
  }

  // set total pages
  setTotalPages() {
    if (favouriteModel.data != null || favouriteModel.data!.count != 0) {
      double total;
      total = favouriteModel.data!.count! / 10;
      debugPrint('total is : $total');
      if (favouriteModel.data!.count! > total) {
        totalPages = total.toInt() + 1;
      }
      debugPrint('total is : $totalPages');
    }
  }

//=======================================================================================================================
  //Api

  //GET ALL INVENTORIES
  getFavourites(BuildContext context, int pagination, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        pagination == 0 ? setLoading(true) : setPagination(true);

        debugPrint(" get favourites  ==========================>>>");

        try {
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.favouritesUrl, {
            "limit": limit,
            "offset": offset,
            "order": "desc",
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");

          if (pagination == 0) {
            favouriteModel = FavouriteModel.fromJson(responseBody);
          } else {
            var newData = FavouriteModel.fromJson(responseBody);

            for (var element in newData.data!.rows!) {
              favouriteModel.data!.rows!.add(element);
            }
          }
          setCount(favouriteModel.data!.count!);
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
}
