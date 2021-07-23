import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import 'package:handicraft_app/global/enviroment.dart';

class ProductService with ChangeNotifier {
  final dio = Dio();

  Future<bool> addProduct(List<File> imges, Map<String, dynamic> body) async {
    List<String> imgUrl = [];
    try {
      for (var image in imges) {
        imgUrl.add(await uploadImg(image));
      }
      body["images"] = imgUrl;
      print(body);
      Response response = await dio.post('${Enviroment.apiurl}/poduct',
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
}
