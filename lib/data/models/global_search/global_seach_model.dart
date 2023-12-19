// To parse this JSON data, do
//
//     final davidRecommendationModel = davidRecommendationModelFromJson(jsonString);

import 'dart:convert';

GlobalSearchModel globalSearchModelFromJson(String str) =>
    GlobalSearchModel.fromJson(json.decode(str));

String globalSearchModelToJson(GlobalSearchModel data) =>
    json.encode(data.toJson());

class GlobalSearchModel {
  GlobalSearchModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory GlobalSearchModel.fromJson(Map<String, dynamic> json) =>
      GlobalSearchModel(
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
    this.count,
    this.rows,
  });

  int? count;
  List<Row>? rows;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        rows: json["rows"] == null
            ? []
            : List<Row>.from(json["rows"]!.map((x) => Row.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class Row {
  Row({
    this.adId,
    this.kmDriven,
    this.badge,
    this.image,
    this.url,
    this.series,
    this.title,
    this.price,
    this.year,
    this.make,
    this.model,
    this.fuelType,
    this.bodyType,
    this.source,
    this.isTracked,
    this.isFavourite,
    this.isPurchased,
    this.isSold,
    this.dateTime,
  });

  int? adId;
  int? kmDriven;
  String? badge;
  String? image;
  String? url;
  String? series;
  String? title;
  int? price;
  int? year;
  String? make;
  String? model;
  String? fuelType;
  String? bodyType;
  String? source;
  int? isTracked;
  int? isFavourite;
  int? isPurchased;
  int? isSold;
  DateTime? dateTime;

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        adId: json["ad_id"],
        kmDriven: json["km_driven"],
        badge: json["badge"],
        image: json["IMAGE"],
        url: json["url"],
        series: json["series"],
        title: json["title"],
        price: json["price"],
        year: json["year"],
        make: json["make"],
        model: json["model"],
        fuelType: json["fuel_type"],
        bodyType: json["body_type"],
        source: json["source"],
        isTracked: json["is_tracked"],
        isFavourite: json["is_favourite"],
        isPurchased: json["is_purchased"],
        isSold: json["is_sold"],
        dateTime: json["date_time"] == null
            ? null
            : DateTime.parse(json["date_time"]),
      );

  Map<String, dynamic> toJson() => {
        "ad_id": adId,
        "km_driven": kmDriven,
        "badge": badge,
        "IMAGE": image,
        "url": url,
        "series": series,
        "title": title,
        "price": price,
        "year": year,
        "make": make,
        "model": model,
        "fuel_type": fuelType,
        "body_type": bodyType,
        "source": source,
        "is_tracked": isTracked,
        "is_favourite": isFavourite,
        "is_purchased": isPurchased,
        "is_sold": isSold,
        "date_time": dateTime == null ? null : dateTime!.toIso8601String(),
      };
}
