import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:handicraft_app/global/enviroment.dart';
import 'package:handicraft_app/models/location_model.dart';
import 'package:handicraft_app/models/locationresponse_model.dart';

class LocationService with ChangeNotifier {
  final dio = Dio();
  Future<List<LocationModel>> getContries() async {
    /*
        /app/countries
    */
    Response response = await dio.get(
      '${Enviroment.apiurl}/app/countries',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
    );
    if (response.statusCode == 200) {
      final locations = LocationResponse.fromJson(response.data);
      return locations.data;
    } else {
      return null;
    }
  }

  Future<List<LocationModel>> getProvinces(int idContrie) async {
    /* 
        /app/provinces/1
    */
    Response response = await dio.get(
      '${Enviroment.apiurl}/app/provinces/$idContrie',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
    );
    if (response.statusCode == 200) {
      final locations = LocationResponse.fromJson(response.data);
      return locations.data;
    } else {
      return null;
    }
  }

  Future<List<LocationModel>> getCity(int idContrie, int idProvince) async {
    /* 
        /app/cities/1/1
    */
    Response response = await dio.get(
      '${Enviroment.apiurl}/app/cities/$idContrie/$idProvince',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
    );
    if (response.statusCode == 200) {
      final locations = LocationResponse.fromJson(response.data);
      return locations.data;
    } else {
      return null;
    }
  }
}
