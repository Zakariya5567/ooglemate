// To parse this JSON data, do
//
//     final inventoriesModel = inventoriesModelFromJson(jsonString);

import 'dart:convert';

InventoriesModel inventoriesModelFromJson(String str) =>
    InventoriesModel.fromJson(json.decode(str));

String inventoriesModelToJson(InventoriesModel data) =>
    json.encode(data.toJson());

class InventoriesModel {
  InventoriesModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory InventoriesModel.fromJson(Map<String, dynamic> json) =>
      InventoriesModel(
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
  List<RowData>? rows;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        rows: json["rows"] == null
            ? null
            : List<RowData>.from(json["rows"].map((x) => RowData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? null
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class RowData {
  RowData({
    this.id,
    this.sellingPrice,
    this.purchasePrice,
    this.adId,
    this.kmDriven,
    this.badge,
    this.year,
    this.image,
    this.url,
    this.series,
    this.title,
    this.make,
    this.model,
    this.fuelType,
    this.bodyType,
    this.source,
  });

  int? id;
  int? sellingPrice;
  int? purchasePrice;
  int? adId;
  int? year;
  int? kmDriven;
  String? badge;
  String? image;
  String? url;
  String? series;
  String? title;
  String? make;
  String? model;
  String? fuelType;
  String? bodyType;
  String? source;

  factory RowData.fromJson(Map<String, dynamic> json) => RowData(
        id: json["id"],
        sellingPrice: json["selling_price"],
        purchasePrice: json["purchase_price"],
        adId: json["ad_id"],
        kmDriven: json["km_driven"],
        badge: json["badge"],
        year: json["year"],
        image: json["IMAGE"],
        url: json["url"],
        series: json["series"],
        title: json["title"],
        make: json["make"],
        model: json["model"],
        fuelType: json["fuel_type"],
        bodyType: json["body_type"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "selling_price": sellingPrice,
        "purchase_price": purchasePrice,
        "ad_id": adId,
        "km_driven": kmDriven,
        "badge": badge,
        "year": year,
        "IMAGE": image,
        "url": url,
        "series": series,
        "title": title,
        "make": make,
        "model": model,
        "fuel_type": fuelType,
        "body_type": bodyType,
        "source": source,
      };
}
