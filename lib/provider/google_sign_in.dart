import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:handicraft_app/global/enviroment.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:handicraft_app/provider/storage_service.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final dio = Dio();
  GoogleSignInAccount _user;

  GoogleSignInAccount get user => _user;

  Future<bool> googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      notifyListeners();
      if (credential != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveUser(AuthService auth) async {
    if (FirebaseAuth.instance.currentUser != null) {
      final user = FirebaseAuth.instance.currentUser;

      List names = user.displayName.split(' ');
      Map<String, dynamic> body = {
        'idUser': user.uid,
        'firstName': names[0],
        'lastName': names[1],
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'photoProfile': user.photoURL
      };

      Response response = await dio.post("${Enviroment.apiurl}/user",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(body));

      if (response.statusCode == 200) {
        Map<String, dynamic> userdata = jsonDecode(response.toString());
        await auth.setUserStorage(userdata);
        return true;
      } else {
        return false;
      }
    }
  }
}
