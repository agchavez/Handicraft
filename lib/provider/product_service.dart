import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import 'package:handicraft_app/global/enviroment.dart';

class ProductService with ChangeNotifier {
  Future<bool> addProduct(body) async {
    final dio = Dio();

    FormData formData = new FormData.fromMap({
      "name": body["name"],
      "image1": await MultipartFile.fromFile(body["image1"], filename: 'image1')
    });
    final resp =
        await dio.post('${Enviroment.apiurl}/api/user', data: formData);
    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
