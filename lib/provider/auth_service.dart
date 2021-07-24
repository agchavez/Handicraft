import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/models/acount_user.dart';
import 'package:handicraft_app/models/login_user.dart';
import 'package:handicraft_app/provider/storage_service.dart';

class AuthService with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = new StorageService();

  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(userCredential.user);
      if (userCredential.user != null) {
        storage.setValue(userCredential.user.uid, "uid");
        return true;
      } else {
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
        storage.setValue(userCredential.user.uid, "uid");
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

  Widget get photoURL {
    if ( FirebaseAuth.instance.currentUser.photoURL != null ) {
      return CircleAvatar(
        maxRadius: 18,
        backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
      );
    } else {
      String displayName = ( FirebaseAuth.instance.currentUser.displayName != null ) ? FirebaseAuth.instance.currentUser.displayName : 'Hc';
      List names  = displayName.split(' ');
      String initials = names[0][0] + names[1][0];
      return CircleAvatar(
        maxRadius: 18,
        child: Text( initials ,
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      );
    }
  }

  Future<bool> stateAuth() async {
    User user = FirebaseAuth.instance.currentUser;
    if ( user == null ) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
