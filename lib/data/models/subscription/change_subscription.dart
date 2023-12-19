// To parse this JSON data, do
//
//     final changeSubscriptionModel = changeSubscriptionModelFromJson(jsonString);

import 'dart:convert';

ChangeSubscriptionModel changeSubscriptionModelFromJson(String str) =>
    ChangeSubscriptionModel.fromJson(json.decode(str));

String changeSubscriptionModelToJson(ChangeSubscriptionModel data) =>
    json.encode(data.toJson());

class ChangeSubscriptionModel {
  ChangeSubscriptionModel({
    this.error,
    this.message,
    this.errors,
  });

  bool? error;
  String? message;
  String? errors;

  factory ChangeSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      ChangeSubscriptionModel(
        error: json["error"],
        message: json["message"],
        errors: json["errors"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "errors": errors,
      };
}
