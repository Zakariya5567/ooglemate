// To parse this JSON data, do
//
//     final sourceModel = sourceModelFromJson(jsonString);

import 'dart:convert';

SourceModel sourceModelFromJson(String str) =>
    SourceModel.fromJson(json.decode(str));

String sourceModelToJson(SourceModel data) => json.encode(data.toJson());

class SourceModel {
  SourceModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<Datum>? data;

  factory SourceModel.fromJson(Map<String, dynamic> json) => SourceModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.sourceId,
    this.source,
  });

  int? sourceId;
  String? source;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        sourceId: json["source_id"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "source_id": sourceId,
        "source": source,
      };
}
