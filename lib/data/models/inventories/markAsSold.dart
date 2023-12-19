// To parse this JSON data, do
//
//     final markAsSoldModel = markAsSoldModelFromJson(jsonString);

import 'dart:convert';

MarkAsSoldModel markAsSoldModelFromJson(String str) =>
    MarkAsSoldModel.fromJson(json.decode(str));

String markAsSoldModelToJson(MarkAsSoldModel data) =>
    json.encode(data.toJson());

class MarkAsSoldModel {
  MarkAsSoldModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<dynamic>? data;

  factory MarkAsSoldModel.fromJson(Map<String, dynamic> json) =>
      MarkAsSoldModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x)),
      };
}
