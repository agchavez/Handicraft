import 'dart:convert';
import 'package:handicraft_app/models/product_stock.dart';

Product_Stock productStockModelFromJson(dynamic str) =>
    Product_Stock.fromJson(str);

String productStockModelToJson(Product_Stock data) =>
    json.encode(data.toJson());

class Product_Stock {
  Product_Stock({
    this.data,
    this.message,
  });

  List<ProductStock> data;
  String message;

  factory Product_Stock.fromJson(Map<dynamic, dynamic> json) => Product_Stock(
        data: List<ProductStock>.from(
            json["data"].map((x) => ProductStock.fromJson(x))),
        message: json["message"],
      );
  Map<dynamic, dynamic> toJson() => {
        data: "data",
        message: "message",
      };
}
