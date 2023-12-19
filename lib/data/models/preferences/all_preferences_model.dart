// To parse this JSON data, do
//
//     final allPreferencesModel = allPreferencesModelFromJson(jsonString);

import 'dart:convert';

AllPreferencesModel allPreferencesModelFromJson(String str) =>
    AllPreferencesModel.fromJson(json.decode(str));

String allPreferencesModelToJson(AllPreferencesModel data) =>
    json.encode(data.toJson());

class AllPreferencesModel {
  AllPreferencesModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory AllPreferencesModel.fromJson(Map<String, dynamic> json) =>
      AllPreferencesModel(
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
    this.count,
    this.rows,
  });

  int? count;
  List<Row>? rows;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        rows: json["rows"] == null
            ? null
            : List<Row>.from(json["rows"].map((x) => Row.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? null
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class Row {
  Row({
    this.id,
    this.isEnabled,
    this.badge,
    this.maximumPurchasePrice,
    this.minimumPurchasePrice,
    this.maximumSalePrice,
    this.minimumSalePrice,
    this.year,
    this.totalCars,
    this.make,
    this.model,
    this.bodyType,
    this.fuelType,
    this.transmission,
  });

  int? id;
  int? isEnabled;
  List<dynamic>? badge;
  int? maximumPurchasePrice;
  int? minimumPurchasePrice;
  int? maximumSalePrice;
  int? minimumSalePrice;
  int? year;
  int? totalCars;
  List<dynamic>? make;
  List<dynamic>? model;
  List<dynamic>? bodyType;
  List<dynamic>? fuelType;
  List<dynamic>? transmission;

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        id: json["id"],
        isEnabled: json["is_enabled"],
        badge: json["badge"] == null
            ? null
            : List<dynamic>.from(json["badge"].map((x) => x)),
        maximumPurchasePrice: json["maximum_purchase_price"],
        minimumPurchasePrice: json["minimum_purchase_price"],
        maximumSalePrice: json["maximum_sale_price"],
        minimumSalePrice: json["minimum_sale_price"],
        year: json["year"],
        totalCars: json["total_cars"],
        make: json["make"] == null
            ? null
            : List<dynamic>.from(json["make"].map((x) => x)),
        model: json["model"] == null
            ? null
            : List<dynamic>.from(json["model"].map((x) => x)),
        bodyType: json["body_type"] == null
            ? null
            : List<dynamic>.from(json["body_type"].map((x) => x)),
        fuelType: json["fuel_type"] == null
            ? null
            : List<dynamic>.from(json["fuel_type"].map((x) => x)),
        transmission: json["transmission"] == null
            ? null
            : List<dynamic>.from(json["transmission"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_enabled": isEnabled,
        "badge":
            badge == null ? null : List<dynamic>.from(badge!.map((x) => x)),
        "maximum_purchase_price": maximumPurchasePrice,
        "minimum_purchase_price": minimumPurchasePrice,
        "maximum_sale_price": maximumSalePrice,
        "minimum_sale_price": minimumSalePrice,
        "year": year,
        "total_cars": totalCars,
        "make": make == null ? null : List<dynamic>.from(make!.map((x) => x)),
        "model":
            model == null ? null : List<dynamic>.from(model!.map((x) => x)),
        "body_type": bodyType == null
            ? null
            : List<dynamic>.from(bodyType!.map((x) => x)),
        "fuel_type": fuelType == null
            ? null
            : List<dynamic>.from(fuelType!.map((x) => x)),
        "transmission": transmission == null
            ? null
            : List<dynamic>.from(transmission!.map((x) => x)),
      };
}
