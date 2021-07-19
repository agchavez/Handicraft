import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/pages/register_page.dart' as register;
//import 'package:handicraft_app/widgets/image.dart' as imageWid;

// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

List<PickedFile> tempimageFileList;
set imageFile(PickedFile value) {
  tempimageFileList = value == null ? null : [value];
  //print(tempimageFileList);
}

File image;
final picker = ImagePicker();

Widget previewImages() {
  if (tempimageFileList != null) {
    return Container(
        decoration: BoxDecoration(
            //shape: BoxShape.circle,
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(50)),
        child: Semantics(
            image: true,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(),
              key: UniqueKey(),
              itemBuilder: (context, index) {
                // Why network for web?
                // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
                print(image);
                return Semantics(
                    label: 'image_picker_example_picked_image',
                    // child: CircleAvatar(),
                    child: ClipOval(
                        child: new SizedBox(
                      width: 100,
                      height: 110,
                      child: Image.file(
                        image,
                        fit: BoxFit.fill,
                      ),
                    )));
              },
              itemCount: tempimageFileList.length,
            ),
            label: 'image_picker_example_picked_images'));
  } else {
    return const Text(
      'You have not yet picked an image.',
      textAlign: TextAlign.center,
    );
  }
}

Future<File> cropImage() async {
  File croppedFile = await ImageCropper.cropImage(
      sourcePath: tempimageFileList[0].path,
      cropStyle: CropStyle.circle,
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
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(title: 'Cropper', minimumAspectRatio: 1.0));
  print(croppedFile);
  return croppedFile;
}
