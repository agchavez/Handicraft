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
  StorageService storage = new StorageService();
  final dio = Dio();

  Future<bool> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      final user = auth.currentUser;
      if (user.emailVerified) {
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
    if (await storage.getValue('photoProfile') != null) {
      return CircleAvatar(
        maxRadius: 18,
        backgroundImage: NetworkImage(await storage.getValue('photoProfile')),
      );
    } else {
      String name = await storage.getValue('displayName');
      String displayName = (name != null) ? name : 'H C';
      List names = displayName.split(' ');
      String initials = names[0][0] + names[1][0];
      return CircleAvatar(
        maxRadius: 18,
        child: Text(initials,
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor:
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
      );
    }
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
    try {
      await FirebaseAuth.instance.signOut();
      await stateAuth();
      await storage.deleteAll();
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendEmailVerification() async {
    if (auth.currentUser != null) {
      await auth.currentUser.sendEmailVerification();
      return true;
    }
    return false;
  }

  Future<bool> setUserStorage(Map<dynamic, dynamic> user) async {
    user = user['data'];
    await storage.deleteAll();
    if (user['idCompany'] != null) {
      await storage.setValue(user["idUser"], 'uid');
      await storage.setValue('${user["name"]} ${user['lastName']}', 'displayName');
      await storage.setValue(user["email"], 'email');
      await storage.setValue(user["photoProfile"], 'photoProfile');
      await storage.setValue(user['State_idState'], 'state');
      await storage.setValue(user["phone"], 'phone');
    } else {
      await storage.setValue(user["idUser"], 'uid');
      await storage.setValue(user["idCompany"], 'idCompany');
      await storage.setValue(user["nameCompany"], 'displayName');
      await storage.setValue(user["email"], 'email');
      await storage.setValue(user['State_idState'], 'state');
      await storage.setValue(user["description"], "companyDescription");
      await storage.setValue(user["photoProfile"], 'photoProfile');
      await storage.setValue(user["phone"], 'phone');
    }

    return true;
  }

  Future<String> refreshUserToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String idToken = await FirebaseAuth.instance.currentUser.getIdToken(true);
      return idToken;
    }
    return "";
  }
}
