// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.count,
    this.rows,
  });

  int? count;
  List<Row>? rows;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        rows: json["rows"] == null
            ? []
            : List<Row>.from(json["rows"]!.map((x) => Row.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class Row {
  Row({
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.adId,
    this.carTitle,
    this.carImage,
    this.type,
  });

  String? title;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? userId;
  int? adId;
  String? carTitle;
  String? carImage;
  String? type;

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        title: json["title"],
        description: json["description"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        userId: json["user_id"],
        adId: json["ad_id"],
        carTitle: json["car_title"],
        carImage: json["car_image"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user_id": userId,
        "ad_id": adId,
        "car_title": carTitle,
        "car_image": carImage,
        "type": type,
      };
}
