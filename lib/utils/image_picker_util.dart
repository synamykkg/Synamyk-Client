import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pick() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    return file != null ? File(file.path) : null;
  }
}