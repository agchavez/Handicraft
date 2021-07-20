import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  Future<bool> register(UserAcountModel user) async {
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
}
