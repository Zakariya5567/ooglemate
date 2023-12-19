// To parse this JSON data, do
//
//     final recommendedModel = recommendedModelFromJson(jsonString);

import 'dart:convert';

AllMatchesModel recommendedModelFromJson(String str) =>
    AllMatchesModel.fromJson(json.decode(str));

String recommendedModelToJson(AllMatchesModel data) =>
    json.encode(data.toJson());

class AllMatchesModel {
  AllMatchesModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory AllMatchesModel.fromJson(Map<String, dynamic> json) =>
      AllMatchesModel(
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
    this.ratePrediction,
    this.isTracked,
    this.isFavourite,
    this.userPreferenceId,
    this.isPurchase,
  });

  int? id;
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
  int? ratePrediction;
  int? isTracked;
  int? isFavourite;
  int? userPreferenceId;
  int? isPurchase;

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        id: json["id"],
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
        ratePrediction: json["rate_prediction"],
        isTracked: json["is_tracked"],
        isFavourite: json["is_favourite"],
        userPreferenceId: json["user_preference_id"],
        isPurchase: json["is_purchased"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "rate_prediction": ratePrediction,
        "is_tracked": isTracked,
        "is_favourite": isFavourite,
        "user_preference_id": userPreferenceId,
        "is_purchased": isFavourite,
      };
}
