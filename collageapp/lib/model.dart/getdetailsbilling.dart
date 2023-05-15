// To parse this JSON data, do
//
//     final getDetailBilling = getDetailBillingFromJson(jsonString);

import 'dart:convert';

GetDetailBilling getDetailBillingFromJson(String str) =>
    GetDetailBilling.fromJson(json.decode(str));

String getDetailBillingToJson(GetDetailBilling data) =>
    json.encode(data.toJson());

class GetDetailBilling {
  GetDetailBilling({
    this.rsId,
    this.rsAt,
    this.userFirstName,
    this.userLastName,
    this.userPhone,
    this.dpName,
    this.dpyYear,
    this.rsPrice,
  });

  int? rsId;
  DateTime? rsAt;
  String? userFirstName;
  String? userLastName;
  String? userPhone;
  String? dpName;
  int? dpyYear;
  int? rsPrice;

  factory GetDetailBilling.fromJson(Map<String, dynamic> json) =>
      GetDetailBilling(
        rsId: json["RS_ID"] == null ? null : json["RS_ID"],
        rsAt: json["RS_at"] == null ? null : DateTime.parse(json["RS_at"]),
        userFirstName:
            json["USER_FirstName"] == null ? null : json["USER_FirstName"],
        userLastName:
            json["USER_LastName"] == null ? null : json["USER_LastName"],
        userPhone: json["USER_Phone"] == null ? null : json["USER_Phone"],
        dpName: json["DP_Name"] == null ? null : json["DP_Name"],
        dpyYear: json["DPY_Year"] == null ? null : json["DPY_Year"],
        rsPrice: json["RS_Price"] == null ? null : json["RS_Price"],
      );

  Map<String, dynamic> toJson() => {
        "RS_ID": rsId == null ? null : rsId,
        "RS_at": rsAt == null ? null : rsAt!.toIso8601String(),
        "USER_FirstName": userFirstName == null ? null : userFirstName,
        "USER_LastName": userLastName == null ? null : userLastName,
        "USER_Phone": userPhone == null ? null : userPhone,
        "DP_Name": dpName == null ? null : dpName,
        "DPY_Year": dpyYear == null ? null : dpyYear,
        "RS_Price": rsPrice == null ? null : rsPrice,
      };
}
