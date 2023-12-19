// To parse this JSON data, do
//
//     final uploadInventoryModel = uploadInventoryModelFromJson(jsonString);

import 'dart:convert';

UploadInventoryModel? uploadInventoryModelFromJson(String str) =>
    UploadInventoryModel.fromJson(json.decode(str));

String uploadInventoryModelToJson(UploadInventoryModel? data) =>
    json.encode(data!.toJson());

class UploadInventoryModel {
  UploadInventoryModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<String?>? data;

  factory UploadInventoryModel.fromJson(Map<String, dynamic> json) =>
      UploadInventoryModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<String?>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}
