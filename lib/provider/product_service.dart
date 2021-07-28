import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:handicraft_app/models/product_general.dart';
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

  Future<bool> addProduct(List<File> imges, Map<String, dynamic> body) async {
    List<String> imgUrl = [];
    try {
      for (var image in imges) {
        if (image != null) {
          imgUrl.add(await uploadImg(image));
        }
      }
      body["images"] = imgUrl;
      print(body);
      Response response = await dio.post(
          '${Enviroment.apiurl}/product/6htb1oKY61M8PXeVTtmY9ni8GUg2',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(body));
      if (response.statusCode == 200) {
        print(response.data);
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
    print(namImg);
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
  Future<List<dynamic>> getPosts() async {
    // print(endArray);
    data = [];
    final response = await http.get(Uri.parse(
        "https://hechoencasa-backend.herokuapp.com/product/getAllProducts/0/12"));
    final resp = productModelFromJson(response.body).data;

    data.addAll(resp);
    cont = cont + 6;

    return data;
  }
}
