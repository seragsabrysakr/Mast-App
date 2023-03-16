// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

enum PickImageFromEnum { camera, gallery }

class DocumentHelper {
  static final ImagePicker _imagepicker = ImagePicker();
  static final FilePicker _fileicker = FilePicker.platform;

  static File? pickedFile;
  static File? pickedImage;
  static bool isValid = true;
  static Future<File?> pickFile() async {
    FilePickerResult? filePickerResult = await _fileicker.pickFiles(
      type: FileType.any,
    );
    if (filePickerResult == null) {
      return null;
    } else {
      pickedFile = File(filePickerResult.files.single.path!);
      var ext = pickedFile?.path.split('.').last;
      print(ext);
      bool wrongExt =
          ext != 'jpg' && ext != 'pdf' && ext != 'png' && ext != 'jpeg';
      if (wrongExt) {
        isValid = false;
        return null;
      } else {
        bool isImage = ext == 'jpg' || ext == 'png' || ext == 'jpeg';
        if (isImage) {
          isValid = true;
          pickedFile = pickedFile;
          // pickedFile = await compressFile(filePath: filePickerResult.files.single.path!);
        }

        return pickedFile;
      }
    }
  }

  static Future<File> compressFile({required String filePath}) async {
    File compressedFile = await FlutterNativeImage.compressImage(filePath,
        quality: 50, percentage: 20);
    print(compressedFile.path);
    var compressedImage = await compressedFile.readAsBytes();
    var picked = await File(filePath).readAsBytes();
    print(compressedImage.length);
    print(picked.length);
    return compressedFile;
  }

  static Future<File?> pickImage(
      PickImageFromEnum type, BuildContext context) async {
    final XFile? photo;
    if (type == PickImageFromEnum.camera) {
      photo = await _imagepicker.pickImage(source: ImageSource.camera);
    } else {
      photo = await _imagepicker.pickImage(source: ImageSource.gallery);
    }
    if (photo == null) {
      return null;
    } else {
      pickedFile = File(photo.path);

      // pickedImage = await compressFile(filePath: photo.path);
      pickedImage = pickedFile;
      Navigator.of(context, rootNavigator: false).pop();

      return pickedImage;
    }
  }

  static void endUploadFile() {
    pickedFile = null;
    pickedImage = null;
  }
}
