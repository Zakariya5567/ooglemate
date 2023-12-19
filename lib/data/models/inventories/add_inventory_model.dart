// To parse this JSON data, do
//
//     final addInventoryModel = addInventoryModelFromJson(jsonString);

import 'dart:convert';

AddInventoryModel? addInventoryModelFromJson(String str) =>
    AddInventoryModel.fromJson(json.decode(str));

String addInventoryModelToJson(AddInventoryModel? data) =>
    json.encode(data!.toJson());

class AddInventoryModel {
  AddInventoryModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory AddInventoryModel.fromJson(Map<String, dynamic> json) =>
      AddInventoryModel(
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
    this.id,
    this.adId,
    this.purchasePrice,
    this.sellingPrice,
    this.userId,
    this.type,
    this.updatedAt,
    this.createdAt,
  });

  int? id;
  int? adId;
  String? purchasePrice;
  String? sellingPrice;
  int? userId;
  String? type;
  DateTime? updatedAt;
  DateTime? createdAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        adId: json["ad_id"],
        purchasePrice: json["purchase_price"],
        sellingPrice: json["selling_price"],
        userId: json["user_id"],
        type: json["type"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ad_id": adId,
        "purchase_price": purchasePrice,
        "selling_price": sellingPrice,
        "user_id": userId,
        "type": type,
        "updatedAt": updatedAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
      };
}
