import 'dart:convert';

Product_Info_Model productInfoFromJson(String str) =>
    Product_Info_Model.fromJson(json.decode(str));

String productToJson(Product_Info_Model data) => json.encode(data.toJson());

class Product_Info_Model {
  Product_Info_Model({
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
  List<dynamic> comments;
  int idCompany;
  String nameCompany;
  String descCompany;

  factory Product_Info_Model.fromJson(Map<dynamic, dynamic> json) =>
      Product_Info_Model(
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
        comments: json["comments"],
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
