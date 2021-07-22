import 'dart:io';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

List<PickedFile> _tempimageFileList;
File _image;
final picker = ImagePicker();
@override
Widget build(BuildContext context) {
  return Container(
    child: null,
  );
}

set _imageFile(PickedFile value) {
  _tempimageFileList = value == null ? null : [value];
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
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () async {
                      _image = await _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
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
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          backgroundColor: Colors.black,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ));

  return croppedFile;
}
