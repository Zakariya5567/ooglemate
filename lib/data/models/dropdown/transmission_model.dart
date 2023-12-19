// To parse this JSON data, do
//
//     final transmissionModel = transmissionModelFromJson(jsonString);

import 'dart:convert';

TransmissionModel transmissionModelFromJson(String str) =>
    TransmissionModel.fromJson(json.decode(str));

String transmissionModelToJson(TransmissionModel data) =>
    json.encode(data.toJson());

class TransmissionModel {
  TransmissionModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory TransmissionModel.fromJson(Map<String, dynamic> json) =>
      TransmissionModel(
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
  List<TransmissionMapData>? rows;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        rows: json["rows"] == null
            ? null
            : List<TransmissionMapData>.from(
                json["rows"].map((x) => TransmissionMapData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? null
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class TransmissionMapData {
  TransmissionMapData({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory TransmissionMapData.fromJson(Map<String, dynamic> json) =>
      TransmissionMapData(
        id: json["transmission_id"],
        name: json["transmission"],
      );

  Map<String, dynamic> toJson() => {
        "transmission_id": id,
        "transmission": name,
      };
}
