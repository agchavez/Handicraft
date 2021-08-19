import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:handicraft_app/global/enviroment.dart';
import 'package:handicraft_app/pages/allComments.dart';
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

  Future<List> getReportProduct() async {
    try {
      final resp = await dio.get("${Enviroment.apiurl}/report/products",
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

  Future<bool> postReportUser(int idReport, dynamic idUser) async {
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

      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> postReportProduct(int idReport, dynamic idProduct) async {
    final body = {
      'idReport': idReport,
      'description': '',
    };
    try {
      String token = await authService.refreshUserToken();
      final resp = await dio.post(
          "${Enviroment.apiurl}/complaint/product/$idProduct",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "token": token
          }),
          data: body);
      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> findOutReportUser(dynamic idUser) async {
    try {
      String token = await authService.refreshUserToken();

      final resp = await dio.get(
        "${Enviroment.apiurl}/complaint/verifyComplaintUser/$idUser",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "token": token
        }),
      );

      if (resp.statusCode == 200) {
        print(resp.data);
        if (resp.data["data"][0]["complaint"] == 1) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } catch (e) {
      return true;
    }
  }

  Future<bool> findOutReportProduct(dynamic idProduct) async {
    try {
      String token = await authService.refreshUserToken();

      final resp = await dio.get(
        "${Enviroment.apiurl}/complaint/verifyComplaintProduct/$idProduct",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "token": token
        }),
      );

      if (resp.statusCode == 200) {
        print(resp.data);
        if (resp.data["data"][0]["complaint"] == 1) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } catch (e) {
      return true;
    }
  }
}
