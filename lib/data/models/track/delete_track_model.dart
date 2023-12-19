// To parse this JSON data, do
//
//     final deleteTrackModel = deleteTrackModelFromJson(jsonString);

import 'dart:convert';

DeleteTrackModel deleteTrackModelFromJson(String str) =>
    DeleteTrackModel.fromJson(json.decode(str));

String deleteTrackModelToJson(DeleteTrackModel data) =>
    json.encode(data.toJson());

class DeleteTrackModel {
  DeleteTrackModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  List<dynamic>? data;

  factory DeleteTrackModel.fromJson(Map<String, dynamic> json) =>
      DeleteTrackModel(
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
