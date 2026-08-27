import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synamyk/data/repositories/user/user_repository.dart';
import 'package:synamyk/domain/models/user/user_model.dart';
import 'package:synamyk/error/app_exception.dart';

class HiveUserRepositoryImpl implements UserRepository {
  static const String userBoxName = 'userBox';
  static const String userKey = 'currentUser';

  Future<Box<UserModel>> _getBox() async {
    if (Hive.isBoxOpen(userBoxName)) {
      return Hive.box<UserModel>(userBoxName);
    } else {
      try {
        return await Hive.openBox<UserModel>(userBoxName);
      } catch (e) {
        await Hive.deleteBoxFromDisk(userBoxName);
        return await Hive.openBox<UserModel>(userBoxName);
      }
    }
  }

  @override
  Future<UserModel?> saveUser(UserModel user) async {
    final box = await _getBox();
    await box.put(userKey, user);
    return box.get(userKey);
  }

  @override
  Future<UserModel?> updateUser({
    String? firstName,
    String? lastName,
    String? region,
    int? regionId,
    String? description,
    String? avatarPath,
  }) async {
    final box = await _getBox();
    final currentUser = box.get(userKey);

    if (currentUser == null) {
      throw throw AppException.unknown('Не удалось сохранить пользователя');
      
    }

    final updatedUser = currentUser.copyWith(
      firstName: firstName,
      lastName: lastName,
      region: region,
      description: description,
      avatarPath: avatarPath,
      regionId: regionId,
    );

    await box.put(userKey, updatedUser);
    return box.get(userKey);
  }

  @override
  Future<UserModel?> getUser() async {
    final box = await _getBox();
    return box.get(userKey);
  }

  @override
  Future<void> deleteUser() async {
    final box = await _getBox();
    await box.delete(userKey);
  }

  @override
  Future<String> saveUserAvatar(String sourcePath) async {
    // Implement saveUserAvatar logic here
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = sourcePath.split('/').last;
    final savedImage = await File(sourcePath).copy('${appDir.path}/$fileName');
    return savedImage.path;
  }
}
