import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:handicraft_app/models/acount_user.dart';
import 'package:handicraft_app/provider/storage_service.dart';

class AuthService with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = new StorageService();

  Future<bool> login(String email, String password) async {
    return true;
  }

  Future<bool> register(UserAcountModel user) async {
    print(user.toString());
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return true;
  }
}
