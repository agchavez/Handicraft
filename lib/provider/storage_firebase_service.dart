import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorageService with ChangeNotifier {

  Future<String> uploadImg(File img, String uid) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('image')
          .child('profile_pictures/user_$uid')
          .child('uid_$uid')
          .putFile(img);
      String url = await downloadURLExample('uid_$uid', uid);
      return url;
    } catch (e) {
      return "";
    }
  }

  Future<String> downloadURLExample(String name, String uid) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('image')
        .child('profile_pictures/user_$uid')
        .child(name);
    String url = (await ref.getDownloadURL()).toString();
    return url;
  }

}
