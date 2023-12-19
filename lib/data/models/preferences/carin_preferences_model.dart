// To parse this JSON data, do
//
//     final carinPreferencesModel = carinPreferencesModelFromJson(jsonString);

import 'dart:convert';

CarinPreferencesModel carinPreferencesModelFromJson(String str) =>
    CarinPreferencesModel.fromJson(json.decode(str));

String carinPreferencesModelToJson(CarinPreferencesModel data) =>
    json.encode(data.toJson());

class CarinPreferencesModel {
  CarinPreferencesModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory CarinPreferencesModel.fromJson(Map<String, dynamic> json) =>
      CarinPreferencesModel(
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
    this.adId,
    this.kmDriven,
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

  int? adId;
  int? kmDriven;
  Badge? badge;
  String? image;
  String? url;
  Series? series;
  Series? title;
  int? price;
  String? make;
  String? model;
  String? fuelType;
  String? bodyType;
  String? source;

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        adId: json["ad_id"],
        kmDriven: json["km_driven"],
        badge: json["badge"] == null ? null : badgeValues.map![json["badge"]],
        image: json["IMAGE"],
        url: json["url"],
        series:
            json["series"] == null ? null : seriesValues.map![json["series"]],
        title: json["title"] == null ? null : seriesValues.map![json["title"]],
        price: json["price"],
        make: json["make"],
        model: json["model"],
        fuelType: json["fuel_type"],
        bodyType: json["body_type"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "ad_id": adId,
        "km_driven": kmDriven,
        "badge": badge == null ? null : badgeValues.reverse[badge],
        "IMAGE": image,
        "url": url,
        "series": series == null ? null : seriesValues.reverse[series],
        "title": title == null ? null : seriesValues.reverse[title],
        "price": price,
        "make": make,
        "model": model,
        "fuel_type": fuelType,
        "body_type": bodyType,
        "source": source,
      };
}

enum Badge { NONE }

final badgeValues = EnumValues({"NONE": Badge.NONE});

enum Series { SIMULATION }

final seriesValues = EnumValues({"SIMULATION": Series.SIMULATION});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
