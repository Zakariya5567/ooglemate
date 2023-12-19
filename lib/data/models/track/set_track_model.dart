// To parse this JSON data, do
//
//     final setTrackModel = setTrackModelFromJson(jsonString);

import 'dart:convert';

SetTrackModel setTrackModelFromJson(String str) =>
    SetTrackModel.fromJson(json.decode(str));

String setTrackModelToJson(SetTrackModel data) => json.encode(data.toJson());

class SetTrackModel {
  SetTrackModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<dynamic>? data;

  factory SetTrackModel.fromJson(Map<String, dynamic> json) => SetTrackModel(
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
