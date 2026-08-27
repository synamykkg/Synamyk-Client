import 'dart:typed_data';

import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/domain/models/region/region_model.dart';
import 'package:synamyk/domain/models/user/user_model.dart';

abstract class ProfileRepository {
  Future<ProfileResponse> getUserInfo();

  /// Uploads (or replaces) the current user's avatar in one request
  /// (`bytes` is expected to already be a compressed JPEG) and returns the
  /// resulting local [UserModel] with the fresh presigned `avatarUrl`
  /// (valid ~1 hour).
  Future<UserModel> uploadAvatar(Uint8List bytes);

  Future<UserModel> deleteAvatar();

  Future<UserModel> changeUserProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? avatarUrl,
  });

  Future<MessageResponse> changeLanguage(String language);

  Future<UserModel> changeRegion(int regionId, List<Region> regions);

  Future<MessageResponse> changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  );

  Future<bool> changePhone(String oldPhone, String newPhone);

  Future<MessageResponse> changePhoneConfirm(String newPhone, String code);

  Future<MessageResponse> deleteAccount();
}
