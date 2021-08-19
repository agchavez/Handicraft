import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:handicraft_app/global/enviroment.dart';
import 'package:handicraft_app/provider/auth_service.dart';

class ReportService with ChangeNotifier {
  Dio dio = Dio();
  final AuthService authService = AuthService();

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

  Future<bool> postReportUser(int idReport, String idUser) async {
    final body = {
      'description': '',
      'idReport': idReport,
    };
    try {
      String token = await authService.refreshUserToken();
      final resp = await dio.post("${Enviroment.apiurl}/complaint/user/$idUser",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "token": token
          }),
          data: body);
      print(resp);

      if (resp.statusCode == 200) {
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
