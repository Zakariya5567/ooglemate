// To parse this JSON data, do
//
//     final bodyModel = bodyModelFromJson(jsonString);

import 'dart:convert';

BodyModel bodyModelFromJson(String str) => BodyModel.fromJson(json.decode(str));

String bodyModelToJson(BodyModel data) => json.encode(data.toJson());

class BodyModel {
  BodyModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory BodyModel.fromJson(Map<String, dynamic> json) => BodyModel(
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
  List<BodyMapData>? rows;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        rows: json["rows"] == null
            ? null
            : List<BodyMapData>.from(
                json["rows"].map((x) => BodyMapData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? null
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class BodyMapData {
  BodyMapData({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory BodyMapData.fromJson(Map<String, dynamic> json) => BodyMapData(
        id: json["body_type_id"],
        name: json["body_type"],
      );

  Map<String, dynamic> toJson() => {
        "body_type_id": id,
        "body_type": name,
      };
}
