// To parse this JSON data, do
//
//     final getPlanModel = getPlanModelFromJson(jsonString);

import 'dart:convert';

GetPlanModel getPlanModelFromJson(String str) =>
    GetPlanModel.fromJson(json.decode(str));

String getPlanModelToJson(GetPlanModel data) => json.encode(data.toJson());

class GetPlanModel {
  GetPlanModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<Datum>? data;

  factory GetPlanModel.fromJson(Map<String, dynamic> json) => GetPlanModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.description,
    this.price,
    this.interval,
    this.stripePriceId,
    this.appleMetaContent,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? description;
  int? price;
  String? interval;
  String? stripePriceId;
  String? appleMetaContent;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        interval: json["interval"],
        stripePriceId: json["stripe_price_id"],
        appleMetaContent: json["apple_meta_content"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "interval": interval,
        "stripe_price_id": stripePriceId,
        "apple_meta_content": appleMetaContent,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}
