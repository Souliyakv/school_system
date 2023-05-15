// To parse this JSON data, do
//
//     final getListOfRegistration = getListOfRegistrationFromJson(jsonString);

import 'dart:convert';

List<GetListOfRegistration> getListOfRegistrationFromJson(String str) =>
    List<GetListOfRegistration>.from(
        json.decode(str).map((x) => GetListOfRegistration.fromJson(x)));

String getListOfRegistrationToJson(List<GetListOfRegistration> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetListOfRegistration {
  GetListOfRegistration({
    this.rsId,
    this.rsPrice,
    this.dpName,
    this.dpyYear,
    this.rsAt,
  });

  int? rsId;
  int? rsPrice;
  String? dpName;
  int? dpyYear;
  DateTime? rsAt;

  factory GetListOfRegistration.fromJson(Map<String, dynamic> json) =>
      GetListOfRegistration(
        rsId: json["RS_ID"] == null ? null : json["RS_ID"],
        rsPrice: json["RS_Price"] == null ? null : json["RS_Price"],
        dpName: json["DP_Name"] == null ? null : json["DP_Name"],
        dpyYear: json["DPY_Year"] == null ? null : json["DPY_Year"],
        rsAt: json["RS_at"] == null ? null : DateTime.parse(json["RS_at"]),
      );

  Map<String, dynamic> toJson() => {
        "RS_ID": rsId == null ? null : rsId,
        "RS_Price": rsPrice == null ? null : rsPrice,
        "DP_Name": dpName == null ? null : dpName,
        "DPY_Year": dpyYear == null ? null : dpyYear,
        "RS_at": rsAt == null ? null : rsAt!.toIso8601String(),
      };
}
