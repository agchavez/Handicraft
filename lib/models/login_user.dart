import 'dart:convert';

LoginAccountModel loginAccountModelFromJson(String str) =>
    LoginAccountModel.fromJson(json.decode(str));

String loginAccountModelToJson(LoginAccountModel data) =>
    json.encode(data.toJson());

class LoginAccountModel {
  String email;
  String password;

  LoginAccountModel({
    this.email,
    this.password,
  });

  factory LoginAccountModel.fromJson(Map<String, dynamic> json) =>
      LoginAccountModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
