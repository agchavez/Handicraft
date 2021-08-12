// To parse this JSON data, do
//
//     final productStock = productStockFromJson(jsonString);

import 'dart:convert';

ProductStock productStockFromJson(String str) =>
    ProductStock.fromJson(json.decode(str));

String productStockToJson(ProductStock data) => json.encode(data.toJson());

class ProductStock {
  ProductStock({
    this.idProduct,
    this.idUser,
    this.name,
    this.location,
    this.cost,
    this.urlImage,
    this.datep,
    this.status,
  });

  int idProduct;
  String idUser;
  String name;
  String location;
  String cost;
  String urlImage;
  DateTime datep;
  int status;

  factory ProductStock.fromJson(Map<String, dynamic> json) => ProductStock(
        idProduct: json["idProduct"],
        idUser: json["idUser"],
        name: json["name"],
        location: json["location"],
        cost: json["cost"],
        urlImage: json["urlImage"],
        datep: DateTime.parse(json["datep"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "idProduct": idProduct,
        "idUser": idUser,
        "name": name,
        "location": location,
        "cost": cost,
        "urlImage": urlImage,
        "datep":
            "${datep.year.toString().padLeft(4, '0')}-${datep.month.toString().padLeft(2, '0')}-${datep.day.toString().padLeft(2, '0')}",
        "status": status,
      };
}
