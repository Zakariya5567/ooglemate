// To parse this JSON data, do
//
//     final activePlanModel = activePlanModelFromJson(jsonString);

import 'dart:convert';

ActivePlanModel activePlanModelFromJson(String str) =>
    ActivePlanModel.fromJson(json.decode(str));

String activePlanModelToJson(ActivePlanModel data) =>
    json.encode(data.toJson());

class ActivePlanModel {
  ActivePlanModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory ActivePlanModel.fromJson(Map<String, dynamic> json) =>
      ActivePlanModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.planId,
    this.userId,
    this.stripeSubscriptionId,
    this.checkoutSessionId,
    this.startAt,
    this.endAt,
    this.price,
    this.interval,
    this.receiptToken,
    this.isCancelled,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? planId;
  int? userId;
  String? stripeSubscriptionId;
  String? checkoutSessionId;
  DateTime? startAt;
  DateTime? endAt;
  String? price;
  String? interval;
  String? receiptToken;
  int? isCancelled;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        planId: json["plan_id"],
        userId: json["user_id"],
        stripeSubscriptionId: json["stripe_subscription_id"],
        checkoutSessionId: json["checkout_session_id"],
        startAt:
            json["start_at"] == null ? null : DateTime.parse(json["start_at"]),
        endAt: json["end_at"] == null ? null : DateTime.parse(json["end_at"]),
        price: json["price"],
        interval: json["interval"],
        receiptToken: json["receipt_token"],
        isCancelled: json["is_cancelled"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "plan_id": planId,
        "user_id": userId,
        "stripe_subscription_id": stripeSubscriptionId,
        "checkout_session_id": checkoutSessionId,
        "start_at": startAt == null
            ? null
            : "${startAt!.year.toString().padLeft(4, '0')}-${startAt!.month.toString().padLeft(2, '0')}-${startAt!.day.toString().padLeft(2, '0')}",
        "end_at": endAt == null
            ? null
            : "${endAt!.year.toString().padLeft(4, '0')}-${endAt!.month.toString().padLeft(2, '0')}-${endAt!.day.toString().padLeft(2, '0')}",
        "price": price,
        "interval": interval,
        "receipt_token": receiptToken,
        "is_cancelled": isCancelled,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}
