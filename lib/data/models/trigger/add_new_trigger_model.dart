// To parse this JSON data, do
//
//     final newTriggerModel = newTriggerModelFromJson(jsonString);

import 'dart:convert';

NewTriggerModel newTriggerModelFromJson(String str) =>
    NewTriggerModel.fromJson(json.decode(str));

String newTriggerModelToJson(NewTriggerModel data) =>
    json.encode(data.toJson());

class NewTriggerModel {
  NewTriggerModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory NewTriggerModel.fromJson(Map<String, dynamic> json) =>
      NewTriggerModel(
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
    this.isEnabled,
    this.id,
    this.make,
    this.model,
    this.transmission,
    this.bodyType,
    this.fuelType,
    this.badge,
    this.fromYear,
    this.toYear,
    this.minimumPurchasePrice,
    this.maximumPurchasePrice,
    this.minimumKm,
    this.maximumKm,
    this.keyWord,
    this.userId,
    this.type,
    this.triggerPriceTag,
    this.updatedAt,
    this.createdAt,
  });

  int? isEnabled;
  int? id;
  List<int>? make;
  List<int>? model;
  List<int>? transmission;
  List<int>? bodyType;
  List<int>? fuelType;
  List<String>? badge;
  String? fromYear;
  String? toYear;
  String? minimumPurchasePrice;
  String? maximumPurchasePrice;
  String? minimumKm;
  String? maximumKm;
  String? keyWord;
  int? userId;
  String? type;
  List<String>? triggerPriceTag;
  DateTime? updatedAt;
  DateTime? createdAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isEnabled: json["is_enabled"],
        id: json["id"],
        make: json["make"] == null
            ? null
            : List<int>.from(json["make"].map((x) => x)),
        model: json["model"] == null
            ? null
            : List<int>.from(json["model"].map((x) => x)),
        transmission: json["transmission"] == null
            ? null
            : List<int>.from(json["transmission"].map((x) => x)),
        bodyType: json["body_type"] == null
            ? null
            : List<int>.from(json["body_type"].map((x) => x)),
        fuelType: json["fuel_type"] == null
            ? null
            : List<int>.from(json["fuel_type"].map((x) => x)),
        badge: json["badge"] == null
            ? null
            : List<String>.from(json["badge"].map((x) => x)),
        fromYear: json["from_year"],
        toYear: json["to_year"],
        minimumPurchasePrice: json["minimum_purchase_price"],
        maximumPurchasePrice: json["maximum_purchase_price"],
        minimumKm: json["minimum_km"],
        maximumKm: json["maximum_km"],
        keyWord: json["key_word"],
        userId: json["user_id"],
        type: json["type"],
        triggerPriceTag: json["trigger_price_tag"] == null
            ? null
            : List<String>.from(json["trigger_price_tag"].map((x) => x)),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "is_enabled": isEnabled,
        "id": id,
        "make": make == null ? null : List<dynamic>.from(make!.map((x) => x)),
        "model":
            model == null ? null : List<dynamic>.from(model!.map((x) => x)),
        "transmission": transmission == null
            ? null
            : List<dynamic>.from(transmission!.map((x) => x)),
        "body_type": bodyType == null
            ? null
            : List<dynamic>.from(bodyType!.map((x) => x)),
        "fuel_type": fuelType == null
            ? null
            : List<dynamic>.from(fuelType!.map((x) => x)),
        "badge":
            badge == null ? null : List<dynamic>.from(badge!.map((x) => x)),
        "from_year": fromYear,
        "to_year": toYear,
        "minimum_purchase_price": minimumPurchasePrice,
        "maximum_purchase_price": maximumPurchasePrice,
        "minimum_km": minimumKm,
        "maximum_km": maximumKm,
        "key_word": keyWord,
        "user_id": userId,
        "type": type,
        "trigger_price_tag": triggerPriceTag == null
            ? null
            : List<dynamic>.from(triggerPriceTag!.map((x) => x)),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
      };
}
