// To parse this JSON data, do
//
//     final markModel = markModelFromJson(jsonString);

import 'dart:convert';

MarkModel markModelFromJson(String str) => MarkModel.fromJson(json.decode(str));

String markModelToJson(MarkModel data) => json.encode(data.toJson());

class MarkModel {
  MarkModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<dynamic>? data;

  factory MarkModel.fromJson(Map<String, dynamic> json) => MarkModel(
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
