import 'dart:convert';

ProductCommentsModel productCommentsFromJson(String str) =>
    ProductCommentsModel.fromJson(json.decode(str));

String productCommentsToJson(ProductCommentsModel data) =>
    json.encode(data.toJson());

class ProductCommentsModel {
  ProductCommentsModel({
    this.idUser,
    this.name,
    this.photoProfile,
    this.idComentary,
    this.comentary,
    this.date,
    this.time,
  });

  String idUser;
  String name;
  String photoProfile;
  int idComentary;
  String comentary;
  String date;
  String time;

  factory ProductCommentsModel.fromJson(Map<dynamic, dynamic> json) =>
      ProductCommentsModel(
        idUser: json["idUser"],
        name: json["name"],
        photoProfile: json["photoProfile"],
        idComentary: json["idComentary"],
        comentary: json["comentary"],
        date: json["date"],
        time: json["time"],
      );
  Map<dynamic, dynamic> toJson() => {
        idUser: "idUser",
        name: "name",
        photoProfile: "photoProfile",
        idComentary: "idComentary",
        comentary: "comentary",
        date: "date",
        time: "time",
      };
}
