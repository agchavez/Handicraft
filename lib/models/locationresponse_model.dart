// To parse this JSON data, do
//
//     final locationResponse = locationResponseFromJson(jsonString);

import 'dart:convert';

import 'package:handicraft_app/models/location_model.dart';

LocationResponse locationResponseFromJson(String str) =>
    LocationResponse.fromJson(json.decode(str));

String locationResponseToJson(LocationResponse data) =>
    json.encode(data.toJson());

class LocationResponse {
  LocationResponse({
    this.data,
  });

  List<LocationModel> data;

  factory LocationResponse.fromJson(Map<String, dynamic> json) =>
      LocationResponse(
        data: List<LocationModel>.from(
            json["data"].map((x) => LocationModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
