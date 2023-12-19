// To parse this JSON data, do
//
//     final allTrackedCarModel = allTrackedCarModelFromJson(jsonString);

import 'dart:convert';

AllTrackedCarModel allTrackedCarModelFromJson(String str) =>
    AllTrackedCarModel.fromJson(json.decode(str));

String allTrackedCarModelToJson(AllTrackedCarModel data) =>
    json.encode(data.toJson());

class AllTrackedCarModel {
  AllTrackedCarModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory AllTrackedCarModel.fromJson(Map<String, dynamic> json) =>
      AllTrackedCarModel(
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
    this.adId,
    this.kmDriven,
    this.year,
    this.badge,
    this.image,
    this.url,
    this.series,
    this.title,
    this.price,
    this.make,
    this.model,
    this.fuelType,
    this.bodyType,
    this.source,
  });

  int? id;
  int? adId;
  int? kmDriven;
  int? price;
  int? year;
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

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        id: json["id"],
        adId: json["ad_id"],
        kmDriven: json["km_driven"],
        year: json["year"],
        badge: json["badge"],
        image: json["IMAGE"],
        url: json["url"],
        series: json["series"],
        title: json["title"],
        price: json["price"],
        make: json["make"],
        model: json["model"],
        fuelType: json["fuel_type"],
        bodyType: json["body_type"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ad_id": adId,
        "km_driven": kmDriven,
        "year": year,
        "badge": badge,
        "IMAGE": image,
        "url": url,
        "series": series,
        "title": title,
        "price": price,
        "make": make,
        "model": model,
        "fuel_type": fuelType,
        "body_type": bodyType,
        "source": source,
      };
}
