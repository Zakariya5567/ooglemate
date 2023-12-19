// To parse this JSON data, do
//
//     final carDetailModel = carDetailModelFromJson(jsonString);

import 'dart:convert';

CarDetailModel carDetailModelFromJson(String str) =>
    CarDetailModel.fromJson(json.decode(str));

String carDetailModelToJson(CarDetailModel data) => json.encode(data.toJson());

class CarDetailModel {
  CarDetailModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory CarDetailModel.fromJson(Map<String, dynamic> json) => CarDetailModel(
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
    this.adId,
    this.kmDriven,
    this.badge,
    this.image,
    this.url,
    this.series,
    this.title,
    this.price,
    this.dateTime,
    this.power,
    this.year,
    this.make,
    this.model,
    this.fuelType,
    this.bodyType,
    this.source,
    this.isTracked,
    this.isFavourite,
    this.isPurchase,
    this.isSold,
  });

  int? adId;
  int? kmDriven;
  String? badge;
  String? image;
  String? url;
  String? series;
  String? title;
  int? price;
  DateTime? dateTime;
  String? power;
  int? year;
  String? make;
  String? model;
  String? fuelType;
  String? bodyType;
  String? source;
  int? isTracked;
  int? isFavourite;
  int? isPurchase;
  int? isSold;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        adId: json["ad_id"],
        kmDriven: json["km_driven"],
        badge: json["badge"],
        image: json["IMAGE"],
        url: json["url"],
        series: json["series"],
        title: json["title"],
        price: json["price"],
        dateTime: json["date_time"] == null
            ? null
            : DateTime.parse(json["date_time"]),
        power: json["power"],
        year: json["year"],
        make: json["make"],
        model: json["model"],
        fuelType: json["fuel_type"],
        bodyType: json["body_type"],
        source: json["source"],
        isTracked: json["is_tracked"],
        isFavourite: json["is_favourite"],
        isPurchase: json["is_purchased"],
        isSold: json["is_sold"],
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
        "date_time": dateTime == null ? null : dateTime!.toIso8601String(),
        "power": power,
        "year": year,
        "make": make,
        "model": model,
        "fuel_type": fuelType,
        "body_type": bodyType,
        "source": source,
        "is_tracked": isTracked,
        "is_favourite": isFavourite,
        "is_purchased": isFavourite,
        "is_sold": isFavourite,
      };
}
