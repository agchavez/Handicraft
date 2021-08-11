import 'dart:convert';

List<ProductModel> dat2 = [];
ProductModel productFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel(
      {this.idProduct,
      this.idUser,
      this.name,
      this.location,
      this.cost,
      this.urlImage,
      this.datep});

  int idProduct;
  String idUser;
  String name;
  String location;
  String cost;
  String urlImage;
  String datep;

  factory ProductModel.fromJson(Map<dynamic, dynamic> json) => ProductModel(
        idProduct: json["idProduct"],
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
