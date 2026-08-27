import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:synamyk/data/api/dio/upload_data_source.dart';
import 'package:synamyk/data/api/swagger/generated/synamyk_api.enums.swagger.dart'
    as enums;
import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/helper/network/network_info.dart';
import 'package:synamyk/data/repositories/profile/profile_repository.dart';
import 'package:synamyk/data/repositories/regions/regions_repository.dart';
import 'package:synamyk/data/repositories/user/user_repository.dart';
import 'package:synamyk/data/services/registration_token_storage.dart';
import 'package:synamyk/domain/models/auth/auth_token.dart';
import 'package:synamyk/domain/models/region/region_model.dart';
import 'package:synamyk/domain/models/user/user_model.dart';
import 'package:synamyk/error/api_error_parser.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' show MultipartFile;
import 'package:path_provider/path_provider.dart';
import 'package:synamyk/utils/url_utils.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final SynamykApiClient synamykApi;
  final UserRepository userRepository;
  final NetworkInfo networkInfo;
  final RegionsRepository regionsRepository;
  final UploadDataSource uploadDataSource;
  final RegistrationTokenStorage registrationTokenStorage;

  ProfileRepositoryImpl({
    required this.synamykApi,
    required this.userRepository,
    required this.networkInfo,
    required this.regionsRepository,
    required this.uploadDataSource,
    required this.registrationTokenStorage,
  });

  Future<UserModel> _mergeIntoLocalUser(ProfileResponse profileResult) async {
    final localUser = await userRepository.getUser();
    final merged = UserModel(
      firstName: profileResult.firstName ?? localUser?.firstName ?? '',
      lastName: profileResult.lastName ?? localUser?.lastName ?? '',
      region: profileResult.regionName ?? localUser?.region ?? '',
      description: profileResult.bio ?? localUser?.description ?? '',
      avatarPath: profileResult.avatarUrl,
      regionId: profileResult.regionId ?? localUser?.regionId ?? -1,
      completedTests:
          profileResult.completedTests ?? localUser?.completedTests ?? 0,
      totalScore: profileResult.totalScore ?? localUser?.totalScore ?? 0,
    );
    final saved = await userRepository.saveUser(merged);
    return saved ?? merged;
  }

  @override
  Future<UserModel> uploadAvatar(Uint8List bytes) async {
    try {
      final json = await uploadDataSource.uploadProfileAvatar(bytes);
      return await _mergeIntoLocalUser(ProfileResponse.fromJson(json));
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<UserModel> deleteAvatar() async {
    try {
      final response = await synamykApi.auth.apiProfileAvatarDelete();
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(
          response.statusCode,
          response.error,
        );
      }
      final body = response.body;
      if (body == null) throw AppException.unknown('Пустой ответ');
      return await _mergeIntoLocalUser(body);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<ProfileResponse> getUserInfo() async {
    final authApi = synamykApi.auth;

    try {
      final profileApiResult = await authApi.apiProfileGet();

      debugPrint(profileApiResult.error.toString());

      if (profileApiResult.isSuccessful) {
        final profileResult = profileApiResult.body;
        if (profileResult == null) {
          throw AppException.unknown();
        }

        // изменение Antigravity баг
        // if (profileResult.avatarUrl != null &&
        //    (profileResult.avatarUrl!.contains('/home/user/') || profileResult.avatarUrl!.contains('%3F'))) {
        //    await authApi.apiProfilePut(
        //      body: UpdateProfileRequest(
        //        firstName: profileResult.firstName,
        //        lastName: profileResult.lastName,
        //        bio: profileResult.bio,
        //        avatarUrl: null,
        //      )
        //    );
        //    return await getUserInfo(); // Refetch clean profile
        // }

        await _mergeIntoLocalUser(profileResult);

        return profileResult;
      } else {
        debugPrint(profileApiResult.error.toString());

        throw ExceptionParser.parseResponse(400, profileApiResult.error);
      }
    } catch (e) {
      try {
        final localUser = await userRepository.getUser();
        if (localUser != null) {
          return ProfileResponse(
            firstName: localUser.firstName,
            lastName: localUser.lastName,
            bio: localUser.description,
            avatarUrl: localUser.avatarPath,
            // Остальные поля (id, phone, regionName и др.) недоступны в UserModel
          );
        }
      } catch (_) {}

      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<UserModel> changeUserProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? avatarUrl,
  }) async {
    final authApi = synamykApi.auth;
    String? finalAvatarUrl;

    try {
      if (avatarUrl == null) {
        finalAvatarUrl = null;
      } else if (avatarUrl.startsWith('http')) {
        finalAvatarUrl = avatarUrl;
      } else {
        finalAvatarUrl = await uploadDataSource.uploadAvatar(avatarUrl);
      }

      debugPrint('Final avatar URL: $finalAvatarUrl');

      final profileApiRequest = await authApi.apiProfilePut(
        body: UpdateProfileRequest(
          firstName: firstName,
          lastName: lastName,
          bio: bio,
          avatarUrl: finalAvatarUrl,
        ),
      );

      if (!profileApiRequest.isSuccessful) {
        throw ExceptionParser.parseResponse(
          profileApiRequest.statusCode,
          profileApiRequest.error,
        );
      }

      final profileResult = profileApiRequest.body;
      if (profileResult == null) {
        throw AppException.unknown();
      }

      final localUser = await userRepository.getUser();
      if (localUser == null) {
        throw AppException.unknown();
      }

      final updatedUser = await userRepository.saveUser(
        localUser.copyWith(
          firstName: profileResult.firstName,
          lastName: profileResult.lastName,
          description: profileResult.bio,
          avatarPath: profileResult.avatarUrl,
        ),
      );

      if (updatedUser == null) {
        throw AppException.unknown('Не удалось сохранить данные');
      }

      return updatedUser;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<MessageResponse> changeLanguage(String language) async {
    try {
      final result = await synamykApi.auth.apiProfileLanguagePut(
        body: ChangeLanguageRequest(language: language.toUpperCase()),
      );
      debugPrint(result.error.toString());
      debugPrint(result.body.toString());
      if (result.isSuccessful) {
        final body = result.body;
        if (body == null) throw AppException.unknown('Пустой ответ');
        return body;
      }

      throw ExceptionParser.parseResponse(result.statusCode, result.error);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<bool> changePhone(String oldPhone, String newPhone) async {
    try {
      final token = await registrationTokenStorage.getToken();
      final result = await synamykApi.auth.apiProfileChangePhoneRequestPost(
        body: ChangePhoneRequest(newPhone: newPhone, oldPhone: oldPhone),
      );

      if (!result.isSuccessful) {
        throw ExceptionParser.parseResponse(result.statusCode, result.error);
      }

      final body = result.body;
      if (body == null) throw AppException.unknown('Пустой ответ');
      if (token == null) throw AppException.unknown('Токен не найден');

      if (body.success == true) {
        await registrationTokenStorage.saveToken(
          token.copyWith(accessToken: body.token),
        );
        return true;
      }

      throw ExceptionParser.parseResponse(result.statusCode, result.error);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<MessageResponse> changePhoneConfirm(
    String newPhone,
    String code,
  ) async {
    try {
      final result = await synamykApi.registration
          .apiProfileChangePhoneConfirmPost(
            body: ConfirmPhoneChangeRequest(newPhone: newPhone, code: code),
          );

      if (!result.isSuccessful) {
        throw ExceptionParser.parseResponse(result.statusCode, result.error);
      }

      final body = result.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      return body;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<UserModel> changeRegion(int regionId, List<Region> regions) async {
    try {
      final result = await synamykApi.auth.apiProfileChangeRegionPut(
        body: ChangeRegionRequest(regionId: regionId),
      );

      if (!result.isSuccessful) {
        throw ExceptionParser.parseResponse(result.statusCode, result.error);
      }

      final body = result.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      final region = regions.firstWhere(
        (r) => r.id == regionId,
        orElse: () => throw AppException.unknown('Регион не найден'),
      );

      final user = await userRepository.updateUser(
        region: region.name,
        regionId: regionId,
      );
      if (user == null)
        throw AppException.unknown('Не удалось сохранить данные');

      return user;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<MessageResponse> changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      final result = await synamykApi.auth.apiProfileChangePasswordPut(
        body: ChangePasswordRequest(
          oldPassword: oldPassword,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        ),
      );

      if (!result.isSuccessful) {
        throw ExceptionParser.parseResponse(result.statusCode, result.error);
      }

      final body = result.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      return body;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<MessageResponse> deleteAccount() async {
    try {
      final result = await synamykApi.auth.apiProfileDelete();

      if (!result.isSuccessful) {
        throw ExceptionParser.parseResponse(result.statusCode, result.error);
      }

      final body = result.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      await userRepository.deleteUser();
      return body;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
