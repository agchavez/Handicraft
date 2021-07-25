import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';

import 'package:handicraft_app/global/enviroment.dart';
import 'package:handicraft_app/models/location_model.dart';
import 'package:handicraft_app/models/locationresponse_model.dart';

class ProductService with ChangeNotifier {
  final dio = Dio();

  Future<bool> addProduct(List<File> imges, Map<String, dynamic> body) async {
    List<String> imgUrl = [];
    try {
      for (var image in imges) {
        if (image != null) {
          imgUrl.add(await uploadImg(image));
        }
      }
      body["images"] = imgUrl;
      Response response = await dio.post('${Enviroment.apiurl}/product/1',
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
    final namImg = new DateTime.now();
    print(namImg);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('image')
          .child('productImg')
          .child(namImg.toIso8601String())
          .putFile(img);
      String url = await downloadURLExample(namImg.toIso8601String());
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
}
