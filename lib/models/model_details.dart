import 'dart:convert';

import 'package:handicraft_app/models/model_comments.dart';

ProductInfoModel productInfoFromJson(String str) =>
    ProductInfoModel.fromJson(json.decode(str));

String productToJson(ProductInfoModel data) => json.encode(data.toJson());

class ProductInfoModel {
  ProductInfoModel({
    this.idProduct,
    this.idUser,
    this.name,
    this.email,
    this.profilePicture,
    this.verification,
    this.description,
    this.location,
    this.cost,
    this.calification,
    this.company,
    this.images,
    this.comments,
    this.idCompany,
    this.nameCompany,
    this.descCompany,
  });

  int idProduct;
  String idUser;
  String name;
  String email;
  String profilePicture;
  int verification;
  String description;
  String location;
  String cost;
  int calification;
  int company;
  List<dynamic> images;
  List<ProductCommentsModel> comments;
  int idCompany;
  String nameCompany;
  String descCompany;

  factory ProductInfoModel.fromJson(Map<dynamic, dynamic> json) =>
      ProductInfoModel(
        idProduct: json["idProduct"],
        idUser: json["idUser"],
        name: json["name"],
        email: json["email"],
        profilePicture: json["profilePicture"],
        verification: json["verification"],
        description: json["description"],
        location: json["location"],
        cost: json["cost"],
        calification: json["calification"],
        company: json["company"],
        images: json["images"],
        comments: List<ProductCommentsModel>.from(
            json["comments"].map((x) => ProductCommentsModel.fromJson(x))),
        idCompany: json["idCompany"],
        nameCompany: json["nameCompany"],
        descCompany: json["descCompany"],
      );
  Map<dynamic, dynamic> toJson() => {
        idProduct: "idProduct",
        idUser: "idUser",
        name: "name",
        email: "email",
        profilePicture: "profilePicture",
        verification: "verification",
        description: "description",
        location: "location",
        cost: "cost",
        calification: "calification",
        company: "company",
        images: "images",
        comments: "comments",
        idCompany: "idCompany",
        nameCompany: "nameCompany",
        descCompany: "descCompany"
      };
}
