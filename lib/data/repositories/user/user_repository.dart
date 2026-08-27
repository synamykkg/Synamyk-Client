import 'package:synamyk/domain/models/user/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> saveUser(UserModel user);
  Future<UserModel?> updateUser({
    String? firstName,
    String? lastName,
    String? region,
    int? regionId,
    String? description,
    String? avatarPath,
  });
  Future<UserModel?> getUser();
  Future<void> deleteUser();
  Future<String> saveUserAvatar(String sourcePath);
}
