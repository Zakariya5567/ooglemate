// To parse this JSON data, do
//
//     final colorModel = colorModelFromJson(jsonString);

import 'dart:convert';

ColorModel colorModelFromJson(String str) =>
    ColorModel.fromJson(json.decode(str));

String colorModelToJson(ColorModel data) => json.encode(data.toJson());

class ColorModel {
  ColorModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory ColorModel.fromJson(Map<String, dynamic> json) => ColorModel(
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
  List<ColorMapData>? rows;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        rows: json["rows"] == null
            ? null
            : List<ColorMapData>.from(
                json["rows"].map((x) => ColorMapData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? null
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class ColorMapData {
  ColorMapData({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory ColorMapData.fromJson(Map<String, dynamic> json) => ColorMapData(
        id: json["exterior_color_id"],
        name: json["exterior_color"],
      );

  Map<String, dynamic> toJson() => {
        "exterior_color_id": id,
        "exterior_color": name,
      };
}
