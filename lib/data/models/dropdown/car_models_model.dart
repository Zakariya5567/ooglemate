// To parse this JSON data, do
//
//     final carModelsModel = carModelsModelFromJson(jsonString);

import 'dart:convert';

CarModelsModel carModelsModelFromJson(String str) =>
    CarModelsModel.fromJson(json.decode(str));

String carModelsModelToJson(CarModelsModel data) => json.encode(data.toJson());

class CarModelsModel {
  CarModelsModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory CarModelsModel.fromJson(Map<String, dynamic> json) => CarModelsModel(
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
  List<ModelMapData>? rows;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        rows: json["rows"] == null
            ? null
            : List<ModelMapData>.from(
                json["rows"].map((x) => ModelMapData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? null
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class ModelMapData {
  ModelMapData({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory ModelMapData.fromJson(Map<String, dynamic> json) => ModelMapData(
        id: json["model_id"],
        name: json["model"],
      );

  Map<String, dynamic> toJson() => {
        "model_id": id,
        "model": name,
      };
}
