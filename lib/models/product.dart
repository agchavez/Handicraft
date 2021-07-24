import 'dart:convert';

Product_Model productFromJson(String str) =>
    Product_Model.fromJson(json.decode(str));

String productToJson(Product_Model data) => json.encode(data.toJson());

class Product_Model {
  Product_Model(
      {this.idProduct,
      this.idUser,
      this.name,
      this.location,
      this.cost,
      this.urlImage,
      this.datep});

  String idProduct;
  String idUser;
  String name;
  String location;
  String cost;
  String urlImage;
  String datep;

  factory Product_Model.fromJson(Map<dynamic, dynamic> json) => Product_Model(
        idProduct: json["idUser"],
        idUser: json["idUser"],
        name: json["name"],
        location: json["location"],
        cost: json["cost"],
        urlImage: json["urlImage"],
        datep: json["datep"],
      );
  Map<dynamic, dynamic> toJson() => {
        idProduct: "idProduct",
        idUser: "idUser",
        name: "name",
        location: "location",
        cost: "cost",
        urlImage: "urlImage",
        datep: "datep"
      };
}
