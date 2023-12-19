import 'package:caroogle/data/models/subscription/create_checkout_model.dart';
import 'package:caroogle/helper/connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/subscription/active_plan_model.dart';
import '../data/models/subscription/cancel_subscription_model.dart';
import '../data/models/subscription/change_subscription.dart';
import '../data/models/subscription/get_plan_model.dart';
import '../data/models/subscription/history_model.dart';
import 'package:caroogle/utils/api_url.dart';
import '../data/models/subscription/subscription_setting_model.dart';
import '../data/repository/api_repo.dart';
import '../view/widgets/custom_snackbar.dart';

class SubscriptionProvider extends ChangeNotifier {
  int? plan;
  int? planPrice;
  bool? isLoading;
  bool? isPagination = false;
  int offset = 0;
  int limit = 10;
  int count = 0;
  int? totalPages;

  GetPlanModel getPlanModel = GetPlanModel();
  CreateCheckoutModel checkoutModel = CreateCheckoutModel();
  ActivePlanModel activePlanModel = ActivePlanModel();
  CancelSubscriptionModel cancelSubscriptionModel = CancelSubscriptionModel();
  ChangeSubscriptionModel changeSubscriptionModel = ChangeSubscriptionModel();
  HistoryModel historyModel = HistoryModel();
  SubscriptionSettingModel subscriptionSettingModel =
      SubscriptionSettingModel();

  ApiRepo apiRepo = ApiRepo();

  incrementOffset() {
    if (offset < totalPages!) {
      offset = offset! + 1;
      debugPrint("offset $offset");
    }

    notifyListeners();
  }

  clearOffset() {
    offset = 0;
    notifyListeners();
  }

  setCount(int value) {
    count = value;
    notifyListeners();
  }

  setTotalPages() {
    if (historyModel.data != null || historyModel.data!.count != 0) {
      double total;
      total = historyModel.data!.count! / 10;
      debugPrint('total is : $total');
      if (historyModel.data!.count! > total) {
        totalPages = total.toInt() + 1;
      }
      debugPrint('total is : $totalPages');
    }
  }

  setPackagePlan(int newPlan) {
    plan = newPlan;
    notifyListeners();
  }

  setPlanPrice(int newPrice) {
    planPrice = newPrice;
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

  // =======================================================================
  // Api

  // GET PLAN
  getPlan(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint(" get plan  ==========================>>>");
        try {
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.getPlanUrl, {});
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          getPlanModel = GetPlanModel.fromJson(responseBody);

          setLoading(false);
        } catch (e) {
          setLoading(false);
        }
      }
      notifyListeners();
    });
  }

  //CREATE CHECKOUT
  createCheckout(BuildContext context, int planId, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint(" create checkout ==========================>>>");
        debugPrint(" plan id : $planId");
        try {
          Response response = await apiRepo
              .postData(context, screen, ApiUrl.createCheckOutUrl, {
            "plan_id": planId,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          checkoutModel = CreateCheckoutModel.fromJson(responseBody);
          setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  // CHANGE SUBSCRIPTION
  changeSubscription(BuildContext context, int id, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint(" cancel Subscription ==========================>>>");
        debugPrint(" plan_id : $id");
        try {
          Response response = await apiRepo
              .postData(context, screen, ApiUrl.changeSubscriptionUrl, {
            "plan_id": id,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          changeSubscriptionModel =
              ChangeSubscriptionModel.fromJson(responseBody);
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
              context,
              changeSubscriptionModel.message.toString(),
              changeSubscriptionModel.error == false ? 0 : 1));

          setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  // CANCEL SUBSCRIPTION
  cancelSubscription(BuildContext context, int id, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint(" cancel Subscription ==========================>>>");
        debugPrint(" subscription id : $id");
        try {
          Response response = await apiRepo
              .postData(context, screen, ApiUrl.cancelSubscriptionUrl, {
            "subscription_id": id,
          });
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          cancelSubscriptionModel =
              CancelSubscriptionModel.fromJson(responseBody);

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
              context,
              cancelSubscriptionModel.message.toString(),
              cancelSubscriptionModel.error == false ? 0 : 1));

          setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  //GET ACTIVE PLAN
  getActivePlan(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint(" get active plan  ==========================>>>");
        try {
          Response response = await apiRepo
              .getData(context, screen, ApiUrl.getActivePlanUrl, {});
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          activePlanModel = ActivePlanModel.fromJson(responseBody);
          setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  //BILLING HISTORY
  billingHistory(BuildContext context, int pagination, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        pagination == 0 ? setLoading(true) : setPagination(true);

        debugPrint(" billing history ==========================>>>");
        try {
          Response response = await apiRepo.getData(context, screen,
              ApiUrl.historyUrl, {"limit": limit, "offset": offset});
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");

          if (pagination == 0) {
            historyModel = HistoryModel.fromJson(responseBody);
          } else {
            var newData = HistoryModel.fromJson(responseBody);

            for (var element in newData.data!.rows!) {
              historyModel.data!.rows!.add(element);
            }
          }
          setCount(historyModel.data!.count!);
          setTotalPages();
          pagination == 0 ? setLoading(false) : setPagination(false);

          debugPrint("pag: $isPagination");
        } catch (e) {
          pagination == 0 ? setLoading(false) : setPagination(false);
        }

        notifyListeners();
      }
    });
  }

  //SUBSCRIPTION SETTING

//GET SUBSCRIPTION SETTING
  getSubscriptionSetting(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        setLoading(true);

        debugPrint(" get subscription setting  ==========================>>>");
        try {
          Response response = await apiRepo
              .getData(context, screen, ApiUrl.subscriptionSettingUrl, {});
          final responseBody = response.data;
          debugPrint("response body ===============>>> $responseBody");
          subscriptionSettingModel =
              SubscriptionSettingModel.fromJson(responseBody);
          setLoading(false);
        } catch (e) {
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }
}
