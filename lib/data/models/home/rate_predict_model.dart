// To parse this JSON data, do
//
//     final ratePredictModel = ratePredictModelFromJson(jsonString);

import 'dart:convert';

RatePredictModel ratePredictModelFromJson(String str) =>
    RatePredictModel.fromJson(json.decode(str));

String ratePredictModelToJson(RatePredictModel data) =>
    json.encode(data.toJson());

class RatePredictModel {
  RatePredictModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<dynamic>? data;

  factory RatePredictModel.fromJson(Map<String, dynamic> json) =>
      RatePredictModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x)),
      };
}
