// To parse this JSON data, do
//
//     final inventoryMappingModel = inventoryMappingModelFromJson(jsonString);

import 'dart:convert';

InventoryMappingModel? inventoryMappingModelFromJson(String str) =>
    InventoryMappingModel.fromJson(json.decode(str));

String inventoryMappingModelToJson(InventoryMappingModel? data) =>
    json.encode(data!.toJson());

class InventoryMappingModel {
  InventoryMappingModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<Datum?>? data;

  factory InventoryMappingModel.fromJson(Map<String, dynamic> json) =>
      InventoryMappingModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum?>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
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
    this.exteriorColor,
    this.purchasePrice,
    this.sellPrice,
    this.kmDriven,
    this.keyWord,
  });

  String? make;
  String? model;
  String? badge;
  String? year;
  String? transmission;
  String? fuelType;
  String? bodyType;
  String? exteriorColor;
  String? purchasePrice;
  String? sellPrice;
  String? kmDriven;
  String? keyWord;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        make: json["make"],
        model: json["model"],
        badge: json["badge"],
        year: json["year"],
        transmission: json["transmission"],
        fuelType: json["fuel_type"],
        bodyType: json["body_type"],
        exteriorColor: json["exterior_color"],
        purchasePrice: json["purchase_price"],
        sellPrice: json["sell_price"],
        kmDriven: json["km_driven"],
        keyWord: json["key_word"],
      );

  Map<String, dynamic> toJson() => {
        "make": make,
        "model": model,
        "badge": badge,
        "year": year,
        "transmission": transmission,
        "fuel_type": fuelType,
        "body_type": bodyType,
        "exterior_color": exteriorColor,
        "purchase_price": purchasePrice,
        "sell_price": sellPrice,
        "km_driven": kmDriven,
        "key_word": keyWord,
      };
}
