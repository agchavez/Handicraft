import 'dart:convert';

CompanieAccountModel compannieAccountModelFromJson(String str) =>
    CompanieAccountModel.fromJson(json.decode(str));

String companieAccountModelToJson(CompanieAccountModel data) =>
    json.encode(data.toJson());

class CompanieAccountModel {
  String name;
  String description;

  CompanieAccountModel({
    this.name,
    this.description
  });

  factory CompanieAccountModel.fromJson( Map<String, dynamic> json ) =>
  CompanieAccountModel(
    name: json['name'],
    description: json['description']
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
  };
}