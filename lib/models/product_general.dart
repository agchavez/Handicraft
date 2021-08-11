import 'dart:convert';

import 'package:handicraft_app/models/product.dart';

Product productModelFromJson(dynamic str) => Product.fromJson(str);

String productModelToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.data,
    this.message,
  });

  List<ProductModel> data;
  String message;

  factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
        data: List<ProductModel>.from(
            json["data"].map((x) => ProductModel.fromJson(x))),
        message: json["message"],
      );
  Map<dynamic, dynamic> toJson() => {
        data: "data",
        message: "message",
      };
}
