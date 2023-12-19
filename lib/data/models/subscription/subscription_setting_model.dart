// To parse this JSON data, do
//
//     final subscriptionSettingModel = subscriptionSettingModelFromJson(jsonString);

import 'dart:convert';

SubscriptionSettingModel subscriptionSettingModelFromJson(String str) =>
    SubscriptionSettingModel.fromJson(json.decode(str));

String subscriptionSettingModelToJson(SubscriptionSettingModel data) =>
    json.encode(data.toJson());

class SubscriptionSettingModel {
  SubscriptionSettingModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory SubscriptionSettingModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionSettingModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.subscriptionEnabled,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? subscriptionEnabled;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        subscriptionEnabled: json["subscription_enabled"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subscription_enabled": subscriptionEnabled,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
