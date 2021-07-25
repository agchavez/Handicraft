import 'dart:convert';

Product productModelFromJson(String str) => Product.fromJson(json.decode(str));

String productModelToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.data,
    this.message,
  });

  List<dynamic> data;
  String message;

  factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
        data: json["data"],
        message: json["message"],
      );
  Map<dynamic, dynamic> toJson() => {
        data: "data",
        message: "message",
      };
}
