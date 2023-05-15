// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  UserProfile({
    this.userId,
    this.userFirstName,
    this.userLastName,
    this.userPhone,
    this.userPassword,
    this.userProfile,
    this.userDisnable,
    this.userYear,
    this.createAt,
    this.userLastLogin,
  });

  int? userId;
  String? userFirstName;
  String? userLastName;
  String? userPhone;
  String? userPassword;
  dynamic? userProfile;
  String? userDisnable;
  int? userYear;
  DateTime? createAt;
  DateTime? userLastLogin;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userId: json["USER_ID"] == null ? null : json["USER_ID"],
        userFirstName:
            json["USER_FirstName"] == null ? null : json["USER_FirstName"],
        userLastName:
            json["USER_LastName"] == null ? null : json["USER_LastName"],
        userPhone: json["USER_Phone"] == null ? null : json["USER_Phone"],
        userPassword:
            json["USER_Password"] == null ? null : json["USER_Password"],
        userProfile: json["USER_Profile"],
        userDisnable:
            json["USER_Disnable"] == null ? null : json["USER_Disnable"],
        userYear: json["USER_Year"] == null ? null : json["USER_Year"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        userLastLogin: json["USER_LastLogin"] == null
            ? null
            : DateTime.parse(json["USER_LastLogin"]),
      );

  Map<String, dynamic> toJson() => {
        "USER_ID": userId == null ? null : userId,
        "USER_FirstName": userFirstName == null ? null : userFirstName,
        "USER_LastName": userLastName == null ? null : userLastName,
        "USER_Phone": userPhone == null ? null : userPhone,
        "USER_Password": userPassword == null ? null : userPassword,
        "USER_Profile": userProfile,
        "USER_Disnable": userDisnable == null ? null : userDisnable,
        "USER_Year": userYear == null ? null : userYear,
        "create_at": createAt == null ? null : createAt!.toIso8601String(),
        "USER_LastLogin":
            userLastLogin == null ? null : userLastLogin!.toIso8601String(),
      };
}
