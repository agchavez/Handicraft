// To parse this JSON data, do
//
//     final UserAcountModel = UserAcountModelFromJson(jsonString);

import 'dart:convert';

UserAcountModel userAcountModelFromJson(String str) =>
    UserAcountModel.fromJson(json.decode(str));

String userAcountModelToJson(UserAcountModel data) =>
    json.encode(data.toJson());

class UserAcountModel {
  String firstname;
  String lastname;
  String email;
  String password;

  UserAcountModel({
    this.firstname,
    this.lastname,
    this.email,
    this.password,
  });

  factory UserAcountModel.fromJson(Map<String, dynamic> json) =>
      UserAcountModel(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "password": password,
      };
}
