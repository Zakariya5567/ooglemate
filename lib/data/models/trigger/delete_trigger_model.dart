// To parse this JSON data, do
//
//     final enableDisableModel = enableDisableModelFromJson(jsonString);

import 'dart:convert';

DeleteTriggerModel enableDisableModelFromJson(String str) =>
    DeleteTriggerModel.fromJson(json.decode(str));

String enableDisableModelToJson(DeleteTriggerModel data) =>
    json.encode(data.toJson());

class DeleteTriggerModel {
  DeleteTriggerModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<dynamic>? data;

  factory DeleteTriggerModel.fromJson(Map<String, dynamic> json) =>
      DeleteTriggerModel(
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
