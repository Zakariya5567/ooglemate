// To parse this JSON data, do
//
//     final downloadCsvModel = downloadCsvModelFromJson(jsonString);

import 'dart:convert';

DownloadCsvModel downloadCsvModelFromJson(String str) =>
    DownloadCsvModel.fromJson(json.decode(str));

String downloadCsvModelToJson(DownloadCsvModel data) =>
    json.encode(data.toJson());

class DownloadCsvModel {
  DownloadCsvModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory DownloadCsvModel.fromJson(Map<String, dynamic> json) =>
      DownloadCsvModel(
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
    this.sampleCsv,
  });

  String? sampleCsv;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        sampleCsv: json["sample_csv"],
      );

  Map<String, dynamic> toJson() => {
        "sample_csv": sampleCsv,
      };
}
