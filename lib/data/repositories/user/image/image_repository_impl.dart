import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synamyk/data/repositories/user/image/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  @override
  Future<File?> pickAvatar() async {
    final xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    return xfile != null ? File(xfile.path) : null;
  }

  @override
  Future<File> saveAvatar(File file) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final newFile = File('${dir.path}/$fileName');
    return file.copy(newFile.path);
  }
}
