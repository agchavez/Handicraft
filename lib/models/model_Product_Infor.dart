import 'dart:convert';

import 'package:handicraft_app/models/model_details.dart';

ProductInfor productInforModelFromJson(String str) =>
    ProductInfor.fromJson(json.decode(str));

String productInforModelToJson(ProductInfor data) => json.encode(data.toJson());

class ProductInfor {
  ProductInfor({
    this.data,
    this.message,
  });

  Product_Info_Model data;
  String message;

  factory ProductInfor.fromJson(Map<dynamic, dynamic> json) => ProductInfor(
        data: Product_Info_Model.fromJson(json["data"]),
        message: json["message"],
      );
  Map<dynamic, dynamic> toJson() => {
        data: "data",
        message: "message",
      };
}