// To parse this JSON data, do
//
//     final uploadCsvModel = uploadCsvModelFromJson(jsonString);

import 'dart:convert';

UploadCsvModel uploadCsvModelFromJson(String str) =>
    UploadCsvModel.fromJson(json.decode(str));

String uploadCsvModelToJson(UploadCsvModel data) => json.encode(data.toJson());

class UploadCsvModel {
  UploadCsvModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<String>? data;

  factory UploadCsvModel.fromJson(Map<String, dynamic> json) => UploadCsvModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x)),
      };
}
