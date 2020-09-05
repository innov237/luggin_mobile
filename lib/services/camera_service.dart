import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CameraService {
  Future pickImage(ImageSource source) async {
    var picture = await ImagePicker.pickImage(source: source);
    return picture;
  }

  //Cropper image
  Future cropImage(file) async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: file.path,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Color(0xFF45C5F8),
        toolbarTitle: "Editer l'image",
        activeControlsWidgetColor: Color(0xFF45C5F8),
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: false,
        hideBottomControls: true,
      ),
    );

    file = cropped ?? file;
    return file;
  }

  String createFileName() {
    var d = new DateTime.now().millisecondsSinceEpoch.abs(),
        newFileName = d.toString() + ".jpg";
    return newFileName;
  }
}
