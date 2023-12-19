// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'dart:convert';

HistoryModel historyModelFromJson(String str) =>
    HistoryModel.fromJson(json.decode(str));

String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
  HistoryModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data == null ? null : data!.toJson(),
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
            ? null
            : List<Row>.from(json["rows"].map((x) => Row.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? null
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class Row {
  Row({
    this.id,
    this.userSubscriptionId,
    this.userId,
    this.startAt,
    this.endAt,
    this.price,
    this.interval,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userSubscriptionId;
  int? userId;
  DateTime? startAt;
  DateTime? endAt;
  String? price;
  String? interval;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        id: json["id"],
        userSubscriptionId: json["user_subscription_id"],
        userId: json["user_id"],
        startAt:
            json["start_at"] == null ? null : DateTime.parse(json["start_at"]),
        endAt: json["end_at"] == null ? null : DateTime.parse(json["end_at"]),
        price: json["price"],
        interval: json["interval"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_subscription_id": userSubscriptionId,
        "user_id": userId,
        "start_at": startAt == null
            ? null
            : "${startAt!.year.toString().padLeft(4, '0')}-${startAt!.month.toString().padLeft(2, '0')}-${startAt!.day.toString().padLeft(2, '0')}",
        "end_at": endAt == null
            ? null
            : "${endAt!.year.toString().padLeft(4, '0')}-${endAt!.month.toString().padLeft(2, '0')}-${endAt!.day.toString().padLeft(2, '0')}",
        "price": price,
        "interval": interval,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}
