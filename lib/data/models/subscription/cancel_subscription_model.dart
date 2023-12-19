// To parse this JSON data, do
//
//     final cancelSubscriptionModel = cancelSubscriptionModelFromJson(jsonString);

import 'dart:convert';

CancelSubscriptionModel cancelSubscriptionModelFromJson(String str) =>
    CancelSubscriptionModel.fromJson(json.decode(str));

String cancelSubscriptionModelToJson(CancelSubscriptionModel data) =>
    json.encode(data.toJson());

class CancelSubscriptionModel {
  CancelSubscriptionModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<dynamic>? data;

  factory CancelSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      CancelSubscriptionModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x)),
      };
}
