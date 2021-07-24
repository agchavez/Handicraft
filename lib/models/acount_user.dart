import 'dart:convert';

UserAccountModel userAccountModelFromJson(String str) =>
    UserAccountModel.fromJson(json.decode(str));

String userAccountModelToJson(UserAccountModel data) =>
    json.encode(data.toJson());

class UserAccountModel {
  String firstname;
  String lastname;
  String email;
  String password;
  String phone;

  UserAccountModel({
    this.firstname,
    this.lastname,
    this.email,
    this.password,
    this.phone,
  });

  factory UserAccountModel.fromJson(Map<String, dynamic> json) =>
      UserAccountModel(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"]
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "password": password,
        "phone": phone
      };
}
