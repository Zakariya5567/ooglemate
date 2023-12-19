// To parse this JSON data, do
//
//     final enableDisableModel = enableDisableModelFromJson(jsonString);

import 'dart:convert';

DeleteModel enableDisableModelFromJson(String str) =>
    DeleteModel.fromJson(json.decode(str));

String enableDisableModelToJson(DeleteModel data) => json.encode(data.toJson());

class DeleteModel {
  DeleteModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<dynamic>? data;

  factory DeleteModel.fromJson(Map<String, dynamic> json) => DeleteModel(
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
