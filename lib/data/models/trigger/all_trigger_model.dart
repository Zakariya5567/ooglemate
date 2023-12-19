// To parse this JSON data, do
//
//     final allTriggerModel = allTriggerModelFromJson(jsonString);

import 'dart:convert';

AllTriggerModel allTriggerModelFromJson(String str) =>
    AllTriggerModel.fromJson(json.decode(str));

String allTriggerModelToJson(AllTriggerModel data) =>
    json.encode(data.toJson());

class AllTriggerModel {
  AllTriggerModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory AllTriggerModel.fromJson(Map<String, dynamic> json) =>
      AllTriggerModel(
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
    this.keyWord,
    this.totalCars,
    this.badge,
    this.make,
    this.model,
    this.fuelType,
    this.makeNames,
    this.modelNames,
    this.fuelTypeNames,
  });

  int? id;
  String? keyWord;
  int? totalCars;
  List<dynamic>? badge;
  List<dynamic>? make;
  List<dynamic>? model;
  List<dynamic>? fuelType;
  List<dynamic>? makeNames;
  List<dynamic>? modelNames;
  List<dynamic>? fuelTypeNames;

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        id: json["id"],
        keyWord: json["key_word"],
        totalCars: json["total_cars"],
        badge: json["badge"] == null
            ? null
            : List<dynamic>.from(json["badge"].map((x) => x)),
        make: json["make"] == null
            ? null
            : List<dynamic>.from(json["make"].map((x) => x)),
        model: json["model"] == null
            ? null
            : List<dynamic>.from(json["model"].map((x) => x)),
        fuelType: json["fuel_type"] == null
            ? null
            : List<dynamic>.from(json["fuel_type"].map((x) => x)),
        makeNames: json["make_names"] == null
            ? null
            : List<dynamic>.from(json["make_names"].map((x) => x)),
        modelNames: json["model_names"] == null
            ? null
            : List<dynamic>.from(json["model_names"].map((x) => x)),
        fuelTypeNames: json["fuel_type_names"] == null
            ? null
            : List<dynamic>.from(json["fuel_type_names"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key_word": keyWord,
        "total_cars": totalCars,
        "badge":
            badge == null ? null : List<dynamic>.from(badge!.map((x) => x)),
        "make": make == null ? null : List<dynamic>.from(make!.map((x) => x)),
        "model":
            model == null ? null : List<dynamic>.from(model!.map((x) => x)),
        "fuel_type": fuelType == null
            ? null
            : List<dynamic>.from(fuelType!.map((x) => x)),
        "make_names": makeNames == null
            ? null
            : List<dynamic>.from(makeNames!.map((x) => x)),
        "model_names": modelNames == null
            ? null
            : List<dynamic>.from(modelNames!.map((x) => x)),
        "fuel_type_names": fuelTypeNames == null
            ? null
            : List<dynamic>.from(fuelTypeNames!.map((x) => x)),
      };
}
