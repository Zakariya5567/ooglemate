// To parse this JSON data, do
//
//     final fuelTypeModel = fuelTypeModelFromJson(jsonString);

import 'dart:convert';

FuelTypeModel fuelTypeModelFromJson(String str) =>
    FuelTypeModel.fromJson(json.decode(str));

String fuelTypeModelToJson(FuelTypeModel data) => json.encode(data.toJson());

class FuelTypeModel {
  FuelTypeModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory FuelTypeModel.fromJson(Map<String, dynamic> json) => FuelTypeModel(
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
  List<FuelMapData>? rows;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        rows: json["rows"] == null
            ? null
            : List<FuelMapData>.from(
                json["rows"].map((x) => FuelMapData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? null
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class FuelMapData {
  FuelMapData({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory FuelMapData.fromJson(Map<String, dynamic> json) => FuelMapData(
        id: json["fuel_type_id"],
        name: json["fuel_type"],
      );

  Map<String, dynamic> toJson() => {
        "fuel_type_id": id,
        "fuel_type": name,
      };
}
