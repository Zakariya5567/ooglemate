// To parse this JSON data, do
//
//     final csvMappingModel = csvMappingModelFromJson(jsonString);

import 'dart:convert';

CsvMappingModel csvMappingModelFromJson(String str) =>
    CsvMappingModel.fromJson(json.decode(str));

String csvMappingModelToJson(CsvMappingModel data) =>
    json.encode(data.toJson());

class CsvMappingModel {
  CsvMappingModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<Datum>? data;

  factory CsvMappingModel.fromJson(Map<String, dynamic> json) =>
      CsvMappingModel(
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
    this.make,
    this.model,
    this.badge,
    this.year,
    this.transmission,
    this.fuelType,
    this.bodyType,
    this.purchasePrice,
    this.sellPrice,
  });

  String? make;
  String? model;
  String? badge;
  String? year;
  String? transmission;
  String? fuelType;
  String? bodyType;
  String? purchasePrice;
  String? sellPrice;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        make: json["make"],
        model: json["model"],
        badge: json["badge"],
        year: json["year"],
        transmission: json["transmission"],
        fuelType: json["fuel_type"],
        bodyType: json["body_type"],
        purchasePrice: json["purchase_price"],
        sellPrice: json["sell_price"],
      );

  Map<String, dynamic> toJson() => {
        "make": make,
        "model": model,
        "badge": badge,
        "year": year,
        "transmission": transmission,
        "fuel_type": fuelType,
        "body_type": bodyType,
        "purchase_price": purchasePrice,
        "sell_price": sellPrice,
      };
}
