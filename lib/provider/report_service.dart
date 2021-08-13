import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:handicraft_app/global/enviroment.dart';
import 'package:handicraft_app/provider/auth_service.dart';

class ReportService with ChangeNotifier {
  Dio dio = Dio();
  AuthService authService;

  Future<List> getReportSeller() async {
    try {
      final resp = await dio.get("${Enviroment.apiurl}/report/users",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (resp.statusCode == 200) {
        final data = resp.data["data"];
        return data;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> postReportUser(int id) async {
    print("here");
    try {
      String token = await authService.refreshUserToken();
      final resp = await dio.post("${Enviroment.apiurl}/complaint/user/$id",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "token": token
          }));
      print(resp);

      if (resp.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
