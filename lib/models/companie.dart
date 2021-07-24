import 'dart:convert';

CompanieAccountModel compannieAccountModelFromJson(String str) =>
    CompanieAccountModel.fromJson(json.decode(str));

String companieAccountModelToJson(CompanieAccountModel data) =>
    json.encode(data.toJson());

class CompanieAccountModel {
  String name;
  int country;
  int province;
  int city;

  CompanieAccountModel({
    this.name,
    this.country,
    this.province,
    this.city
  });

  factory CompanieAccountModel.fromJson( Map<String, dynamic> json ) =>
  CompanieAccountModel(
    name: json['name'],
    country: json['country'],
    province: json['province'],
    city: json['city'],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "country": country,
    "province": province,
    "city": city,
  };
}