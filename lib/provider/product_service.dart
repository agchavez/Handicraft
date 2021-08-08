import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:handicraft_app/models/model_Product_Infor.dart';
import 'package:handicraft_app/models/model_details.dart';
import 'package:handicraft_app/models/product.dart';
import 'package:handicraft_app/models/product_general.dart';
import 'package:handicraft_app/models/product_stock.dart';
import 'package:handicraft_app/models/product_stock_model.dart';

import 'package:handicraft_app/pages/login_page.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:handicraft_app/provider/storage_service.dart';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:handicraft_app/global/enviroment.dart';
import 'package:handicraft_app/models/location_model.dart';
import 'package:handicraft_app/models/locationresponse_model.dart';

List<dynamic> data = [];
int cont = 0;

class ProductService with ChangeNotifier {
  final dio = Dio();
  final uuid = Uuid();
  final AuthService authService = AuthService();

  Future<bool> addProduct(List<File> imges, Map<String, dynamic> body) async {
    final idUser = await StorageService().getValue("uid");
    List<String> imgUrl = [];
    try {
      for (var image in imges) {
        if (image != null) {
          imgUrl.add(await uploadImg(image));
        }
      }
      body["images"] = imgUrl;
      Response response = await dio.post('${Enviroment.apiurl}/product/$idUser',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(body));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> uploadImg(File img) async {
    //Guardar imagenes en firebase y retornar el url
    String namImg = uuid.v4();
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('image')
          .child('productImg')
          .child(namImg)
          .putFile(img);
      String url = await downloadURLExample(namImg);
      return url;
    } catch (e) {
      return "";
    }
  }

  Future<String> downloadURLExample(String name) async {
    // Obtener el URL de la imagen almacenada en firebase
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('image')
        .child('productImg')
        .child(name);
    String url = (await ref.getDownloadURL()).toString();
    return url;
  }

  Future<List<LocationModel>> getCategories() async {
    /*
        /app/categories
    */
    List<LocationModel> list = [];
    Response response = await dio.get(
      '${Enviroment.apiurl}/app/categories',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
    );
    if (response.statusCode == 200) {
      list = LocationResponse.fromJson(response.data).data;
      return list;
    } else {
      return list;
    }
  }

  Future<List<dynamic>> getCategoriesSuscribe() async {
    String token = await authService.refreshUserToken();
    try {
      Response resp = await dio.get('${Enviroment.apiurl}/user/categories',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            'token': token
          }));
      return resp.data["data"];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> suscribeCategorie(int id) async {
    try {
      String token = await authService.refreshUserToken();
      Response resp = await dio.post(
          '${Enviroment.apiurl}/user/category/$id/subscribe',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            'token': token
          }));
      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeSuscribeCategorie(int id) async {
    try {
      String token = await authService.refreshUserToken();
      Response resp = await dio.delete(
          '${Enviroment.apiurl}/user/category/$id/unsubscribe',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            'token': token
          }));
      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<LocationModel>> getCoins() async {
    /*
        /app/coines
    */

    List<LocationModel> list = [];
    Response response = await dio.get(
      '${Enviroment.apiurl}/app/coines',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
    );
    if (response.statusCode == 200) {
      list = LocationResponse.fromJson(response.data).data;
      return list;
    } else {
      return list;
    }
  }

  //Obtener productos sin logearse
  Future<List<Product_Model>> getPosts(int cont) async {
    // print(endArray);
    String uid = await StorageService().getValue("uid");
    print("uid == $uid");
    if (uid == null || uid == "") {
      final response = await http.get(Uri.parse(
          "https://hechoencasa-backend.herokuapp.com/product/getAllProducts/$cont/12"));
      final resp = productModelFromJson(jsonDecode(response.body)).data;
      if (cont != 0) {
        dat2 = [...dat2, ...resp];
        return dat2;
      } else {
        dat2 = resp;
        return resp;
      }
    } else {
      final response = await http.get(Uri.parse(
          "https://hechoencasa-backend.herokuapp.com/product/getAllProducts/$uid/$cont/12"));
      final resp = productModelFromJson(jsonDecode(response.body)).data;
      if (cont != 0) {
        dat2 = [...dat2, ...resp];
        return dat2;
      } else {
        dat2 = resp;
        return resp;
      }
    }
  }

  Future<List<Product_Info_Model>> getPostsDetail(int idProduct) async {
    // print(endArray);
    List<Product_Info_Model> detail = [];
    final response = await http.get(Uri.parse(
        "https://hechoencasa-backend.herokuapp.com/product/getInfo/${idProduct}"));
    print(response.body);
    final resp = productInforModelFromJson(response.body).data;
    detail.add(resp);

    return detail;
  }

  Future<List<Product_Model>> getProductsofUser() async {
    Product resp;
    try {
      String token = await authService.refreshUserToken();
      print(token);
      Response response = await dio.get(
        '${Enviroment.apiurl}/user/product',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "token": token
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

  Future<List<ProductStock>> getHistoryProductUser() async {
    Product_Stock resp;
    try {
      String token = await authService.refreshUserToken();
      print(token);
      Response response = await dio.get(
        '${Enviroment.apiurl}/user/products-history',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "token": token
        }),
      );
      resp = productStockModelFromJson(response.data);
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
