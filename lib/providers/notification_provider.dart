import 'package:caroogle/data/models/home/notification_model.dart';
import 'package:caroogle/data/repository/api_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../helper/connection_checker.dart';
import '../utils/api_url.dart';

class NotificationProvider extends ChangeNotifier {
  int offset = 0;
  int limit = 10;
  int count = 0;
  int? totalPages;
  bool? isLoading;
  bool? isPagination;
  NotificationModel notificationModel = NotificationModel();

  ApiRepo apiRepo = ApiRepo();

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
    offset = offset! + 1;
    debugPrint("offset $offset");
    notifyListeners();
  }

  setCount(int value) {
    count = value;
    notifyListeners();
  }

  setTotalPages() {
    if (notificationModel.data != null || notificationModel.data!.count != 0) {
      double total;
      total = notificationModel.data!.count! / 10;
      debugPrint('total is : $total');
      if (notificationModel.data!.count! > total) {
        totalPages = total.toInt() + 1;
      }
      debugPrint('total is : $totalPages');
    }
  }

  //=========================================================================
  //API

  //ALL NOTIFICATION
  getNotification(BuildContext context, int pagination, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        pagination == 0 ? setLoading(true) : setPagination(true);

        debugPrint("get all notification  ==========================>>>");
        try {
          Response response = await apiRepo
              .getData(context, screen, ApiUrl.getNotificationUrl, {
            "limit": -1,
            //  "offset": offset,
            "order": "desc",
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");

          if (pagination == 0) {
            notificationModel = NotificationModel.fromJson(responseBody);
          } else {
            var newData = NotificationModel.fromJson(responseBody);
            for (var element in newData.data!.rows!) {
              notificationModel.data!.rows!.add(element);
            }
          }
          setCount(notificationModel.data!.count!);
          setTotalPages();
          pagination == 0 ? setLoading(false) : setPagination(false);
        } catch (e) {
          pagination == 0 ? setLoading(false) : setPagination(false);
        }

        notifyListeners();
      }
    });
  }
}
