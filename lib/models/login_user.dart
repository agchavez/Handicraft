import 'dart:convert';

LoginAcountModel userAcountModelFromJson(String str) =>
    LoginAcountModel.fromJson(json.decode(str));

String loginAcountModelToJson(LoginAcountModel data) =>
    json.encode(data.toJson());

class LoginAcountModel {
  String? email;
  String? password;

  LoginAcountModel({
    this.email,
    this.password,
  });

  factory LoginAcountModel.fromJson(Map<String, dynamic> json) =>
      LoginAcountModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
