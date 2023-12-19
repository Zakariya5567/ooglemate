// To parse this JSON data, do
//
//     final signupModel = signupModelFromJson(jsonString);

import 'dart:convert';

SignupModel signupModelFromJson(String str) =>
    SignupModel.fromJson(json.decode(str));

String signupModelToJson(SignupModel data) => json.encode(data.toJson());

class SignupModel {
  SignupModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  factory SignupModel.fromJson(Map<String, dynamic> json) => SignupModel(
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
    this.id,
    this.name,
    this.email,
    this.socialMediaPlatform,
    this.fcmToken,
    this.stripeCustomerId,
    this.preferenceCsv,
    this.photo,
    this.phone,
    this.gender,
    this.dob,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  int? id;
  String? name;
  String? email;
  String? socialMediaPlatform;
  String? fcmToken;
  String? stripeCustomerId;
  String? preferenceCsv;
  String? photo;
  String? phone;
  String? gender;
  String? dob;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        socialMediaPlatform: json["social_media_platform"],
        fcmToken: json["fcm_token"],
        stripeCustomerId: json["stripe_customer_id"],
        preferenceCsv: json["preference_csv"],
        photo: json["photo"],
        phone: json["phone"],
        gender: json["gender"],
        dob: json["dob"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "social_media_platform": socialMediaPlatform,
        "fcm_token": fcmToken,
        "stripe_customer_id": stripeCustomerId,
        "preference_csv": preferenceCsv,
        "photo": photo,
        "phone": phone,
        "gender": gender,
        "dob": dob,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "token": token,
      };
}
