import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ImageStorage {
  static final ImageStorage _instance = ImageStorage._internal();
  factory ImageStorage() => _instance;

  ImageStorage._internal();

  Future<File> saveAvatar(File file) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/avatar.jpg';

    return file.copy(path);
  }
}
