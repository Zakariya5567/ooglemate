// To parse this JSON data, do
//
//     final addNewPreferencesModel = addNewPreferencesModelFromJson(jsonString);

import 'dart:convert';

AddNewPreferencesModel addNewPreferencesModelFromJson(String str) =>
    AddNewPreferencesModel.fromJson(json.decode(str));

String addNewPreferencesModelToJson(AddNewPreferencesModel data) =>
    json.encode(data.toJson());

class AddNewPreferencesModel {
  AddNewPreferencesModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory AddNewPreferencesModel.fromJson(Map<String, dynamic> json) =>
      AddNewPreferencesModel(
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
    this.minimumSalePrice,
    this.maximumSalePrice,
    this.userId,
    this.type,
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
  String? minimumSalePrice;
  String? maximumSalePrice;
  int? userId;
  String? type;
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
        minimumSalePrice: json["minimum_sale_price"],
        maximumSalePrice: json["maximum_sale_price"],
        userId: json["user_id"],
        type: json["type"],
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
        "minimum_sale_price": minimumSalePrice,
        "maximum_sale_price": maximumSalePrice,
        "user_id": userId,
        "type": type,
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
      };
}
