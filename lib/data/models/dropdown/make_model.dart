// To parse this JSON data, do
//
//     final makeModel = makeModelFromJson(jsonString);

import 'dart:convert';

MakeModel makeModelFromJson(String str) => MakeModel.fromJson(json.decode(str));

String makeModelToJson(MakeModel data) => json.encode(data.toJson());

class MakeModel {
  MakeModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory MakeModel.fromJson(Map<String, dynamic> json) => MakeModel(
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
  List<MakeMapData>? rows;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        rows: json["rows"] == null
            ? null
            : List<MakeMapData>.from(
                json["rows"].map((x) => MakeMapData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? null
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class MakeMapData {
  MakeMapData({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory MakeMapData.fromJson(Map<String, dynamic> json) => MakeMapData(
        id: json["make_id"],
        name: json["make"],
      );

  Map<String, dynamic> toJson() => {
        "make_id": id,
        "make": name,
      };
}
