// To parse this JSON data, do
//
//     final appNotificationModel = appNotificationModelFromJson(jsonString);

import 'dart:convert';

AppNotificationModel? appNotificationModelFromJson(String str) =>
    AppNotificationModel.fromJson(json.decode(str));

String appNotificationModelToJson(AppNotificationModel? data) =>
    json.encode(data!.toJson());

class AppNotificationModel {
  AppNotificationModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<dynamic>? data;

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) =>
      AppNotificationModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<dynamic>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}
