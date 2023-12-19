// To parse this JSON data, do
//
//     final enableDisableModel = enableDisableModelFromJson(jsonString);

import 'dart:convert';

EnableDisableModel enableDisableModelFromJson(String str) =>
    EnableDisableModel.fromJson(json.decode(str));

String enableDisableModelToJson(EnableDisableModel data) =>
    json.encode(data.toJson());

class EnableDisableModel {
  EnableDisableModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<dynamic>? data;

  factory EnableDisableModel.fromJson(Map<String, dynamic> json) =>
      EnableDisableModel(
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
