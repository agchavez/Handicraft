import 'dart:convert';
import 'package:handicraft_app/models/product_stock.dart';

ProductStockModel productStockModelFromJson(dynamic str) =>
    ProductStockModel.fromJson(str);

String productStockModelToJson(ProductStockModel data) =>
    json.encode(data.toJson());

class ProductStockModel {
  ProductStockModel({
    this.data,
    this.message,
  });

  List<ProductStock> data;
  String message;

  factory ProductStockModel.fromJson(Map<dynamic, dynamic> json) =>
      ProductStockModel(
        data: List<ProductStock>.from(
            json["data"].map((x) => ProductStock.fromJson(x))),
        message: json["message"],
      );
  Map<dynamic, dynamic> toJson() => {
        data: "data",
        message: "message",
      };
}
