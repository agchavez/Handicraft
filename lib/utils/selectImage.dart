import 'dart:io';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

final picker = ImagePicker();
@override
Widget build(BuildContext context) {
  return Container(
    child: null,
  );
}

_imgFromCamera() async {
  final pickedFile =
      await picker.getImage(source: ImageSource.camera, imageQuality: 50);
  return pickedFile.path;
}

_imgFromGallery() async {
  final pickedFile =
      await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
  return pickedFile.path;
}

Future<String> showPicker(context) async {
  String _image;
  await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(
                      Icons.photo_library_outlined,
                      color: Colors.black,
                    ),
                    title: new Text(
                      'Galeria',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () async {
                      _image = await _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(
                    Icons.photo_camera_outlined,
                    color: Colors.black,
                  ),
                  title: new Text(
                    'Camara',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () async {
                    _image = await _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      });

  return _image;
}

Future<File> cropImage(String path) async {
  File croppedFile = await ImageCropper.cropImage(
      sourcePath: path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
            ]
          : [
              CropAspectRatioPreset.square,
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Recortar',
          toolbarColor: Colors.black,
          activeControlsWidgetColor: Colors.grey,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          backgroundColor: Colors.black,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        title: 'Recortar',
      ));

  return croppedFile;
}
