import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:handicraft_app/global/enviroment.dart';
import 'package:handicraft_app/models/product.dart';
import 'package:handicraft_app/models/product_general.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:handicraft_app/provider/storage_service.dart';

class UserService with ChangeNotifier {
  StorageService storage = new StorageService();
  final dio = Dio();
  AuthService authService = AuthService();

  Future<String> getLikesById(String id) async {
    if (id == "uid") {
      id = await StorageService().getValue("uid");
    }
    try {
      String token = await authService.refreshUserToken();

      Response responseInfoUser = await dio.get(
          '${Enviroment.apiurl}/quali/likesUser/$id',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "token": token
          }));
      Map<String, dynamic> userData = responseInfoUser.data;
      return userData["data"][0]["likes"].toString();
    } catch (e) {
      return "0";
    }
  }

  Future<bool> addLike(String id) async {
    try {
      String token = await authService.refreshUserToken();

      Response responseInfoUser = await dio.post(
          '${Enviroment.apiurl}/quali/giveLike/$id',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "token": token
          }));
      if (responseInfoUser.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeLike(String id) async {
    print(id);
    try {
      String token = await authService.refreshUserToken();
      Response responseInfoUser = await dio.post(
          '${Enviroment.apiurl}/quali/disLike/$id',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "token": token
          }));
      if (responseInfoUser.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyLike(String id) async {
    try {
      String token = await authService.refreshUserToken();
      Response responseInfoUser = await dio.get(
          '${Enviroment.apiurl}/quali/verifyLike/$id',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "token": token
          }));
      final data = responseInfoUser.data["data"][0]["likes"];
      if (data == 0) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<ProductModel>> getProductsSeller(String id) async {
    Product resp;
    try {
      Response response = await dio.get(
        '${Enviroment.apiurl}/user/product-public/$id',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      resp = productModelFromJson(response.data);
      if (response.statusCode == 200) {
        return resp.data;
      } else {
        return resp.data;
      }
    } catch (e) {
      print("Error al obtener los productos de un usuario $e");
      return [];
    }
  }
}
