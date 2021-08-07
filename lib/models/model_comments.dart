import 'dart:convert';

Product_Comments_Model productCommentsFromJson(String str) =>
    Product_Comments_Model.fromJson(json.decode(str));

String productCommentsToJson(Product_Comments_Model data) =>
    json.encode(data.toJson());

class Product_Comments_Model {
  Product_Comments_Model({
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

  factory Product_Comments_Model.fromJson(Map<dynamic, dynamic> json) =>
      Product_Comments_Model(
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
