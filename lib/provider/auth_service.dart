import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/models/acount_user.dart';
import 'package:handicraft_app/provider/storage_service.dart';

class AuthService with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool authState = false;
  Widget navbarProfile;
  final dio = Dio();

  Future<bool> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      final user = auth.currentUser;
      if ( user.emailVerified ) {
        if (user != null) {
          return true;
        } else {
          return false;
        }
      } else {
        print('Usuario no verificado por correo');
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(UserAccountModel user) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      if (userCredential.user != null) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Widget> get photoURL async {
    if ( await StorageService().getValue('photoProfile') != null) {
      return CircleAvatar(
        maxRadius: 18,
        backgroundImage:
            NetworkImage(await StorageService().getValue('photoProfile')),
      );
    } else {
      String name = await StorageService().getValue('displayName');
      String displayName = ( name != null ) ? name : 'H C';
      List names  = displayName.split(' ');
      String initials = names[0][0] + names[1][0];
      return CircleAvatar(
        maxRadius: 18,
        child: Text( initials,
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor:
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
      );
    }
    print('eject');
    notifyListeners();
  }

  Future<void> stateAuth() async {
    final user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      authState = true;
    } else {
      authState = false;
    }
    notifyListeners();
  }

  Future<bool> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> sendEmailVerification() async {
    if ( auth.currentUser != null ) {
      await auth.currentUser.sendEmailVerification();
      return true;
    }
  }

  Future<bool> setUserStorage() async {
    Response responseInfoUser = await dio.get('http://192.168.1.106:5000/user/${auth.currentUser.uid}');
    Map<String, dynamic> userData = jsonDecode(responseInfoUser.toString());
    await StorageService().deleteAll();
    await StorageService().setValue(userData['data']['idUser'], 'uid');
    await StorageService().setValue('${userData['data']['name']} ${userData['data']['lastName']}', 'displayName');
    await StorageService().setValue(userData['data']['email'], 'email');
    await StorageService().setValue(userData['data']['photoProfile'], 'photoProfile');
    await StorageService().setValue(userData['data']['phone'], 'phone');
    print( userData['data']['photoProfile'] );
    return true;
  }
}
