import 'dart:io';

abstract class ImageRepository {
  Future<File?> pickAvatar();
  Future<File> saveAvatar(File file);
}
