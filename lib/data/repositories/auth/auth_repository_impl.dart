import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:synamyk/config/app_config.dart';
import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/interceptor/auth_interceptor.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/data/repositories/user/user_repository.dart';
import 'package:synamyk/data/services/image_storage.dart';
import 'package:synamyk/data/services/registration_token_storage.dart';
import 'package:synamyk/data/services/app_token_storage.dart';
import 'package:synamyk/domain/enums/app_language.dart';
import 'package:synamyk/domain/enums/otp_type.dart';
import 'package:synamyk/domain/models/auth/auth_token.dart';
import 'package:synamyk/domain/models/auth/registration_info.dart';
import 'package:synamyk/domain/models/user/user_model.dart';
import 'package:synamyk/error/api_error_parser.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/error/exceptions.dart';
import 'package:synamyk/utils/auth/phone_input_formatter.dart';
import 'package:synamyk/utils/image_picker_util.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AppTokenStorage _tokenStorage;
  final UserRepository _userRepository;
  final ImageStorage _imagePicker;
  final RegistrationTokenStorage _registrationTokenStorage;
  final SynamykApiClient synamykApi;
  final String policyUrl;
  final String termsOfService;

  AuthRepositoryImpl({
    AppTokenStorage? tokenStorage,
    UserRepository? userRepository,
    ImageStorage? imageStorage,
    required RegistrationTokenStorage registrationTokenStorage,
    required this.synamykApi, required this.policyUrl, required this.termsOfService,
  }) : _tokenStorage = tokenStorage ?? AppTokenStorage(),
       _userRepository = userRepository ?? GetIt.I<UserRepository>(),
       _imagePicker = imageStorage ?? ImageStorage(),
       _registrationTokenStorage = registrationTokenStorage;

  @override
  Future<AuthToken> signIn(String phone, String password) async {
    try {
      final result = await synamykApi.public.apiAuthLoginPost(
        body: LoginRequest(
          password: password,
          phone: normalizePhoneForApi(phone),
        ),
      );

      if (!result.isSuccessful) {
        throw ExceptionParser.parseResponse(result.statusCode, result.error);
      }

      final userData = result.body;
      if (userData == null)
        throw AppException.unknown('Сервер не отправил данные');
      if (userData.token == null || userData.refreshToken == null) {
        throw AppException.unknown('Не удалось получить токен');
      }

      final token = AuthToken(
        accessToken: userData.token!,
        refreshToken: userData.refreshToken!,
      );

      await _tokenStorage.saveToken(token);
      return token;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<bool> sendOtpSms(String phone, OtpType type, AppLanguage lang) async {
    try {
      final result = await synamykApi.public.apiAuthSendOtpPost(
        phone: normalizePhoneForApi(phone),
        lang: lang.apiCode,
        type: type.value,
      );

      if (!result.isSuccessful) {
        debugPrint(result.error.toString());
        throw ExceptionParser.parseResponse(result.statusCode, result.error);
      }

      final body = result.body;
      if (body == null) throw AppException.unknown('Пустой ответ');
      if (body.token == null) throw AppException.unknown('Токен не получен');

      await _registrationTokenStorage.saveToken(
        AuthToken(accessToken: body.token!, refreshToken: ''),
      );

      return body.success ?? false;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<bool> resendOtpSms(
    String phone,
    OtpType type,
    AppLanguage lang,
  ) async {
    try {
      final result = await synamykApi.public.apiAuthResendOtpPost(
        phone: normalizePhoneForApi(phone),
        lang: lang.apiCode,
        type: type.value,
      );

      if (!result.isSuccessful) {
        throw ExceptionParser.parseResponse(result.statusCode, result.error);
      }

      final body = result.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      return body.success ?? false;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<OtpVerifyResponse> confirmSignUp(String code, String phone) async {
    return _verifyOtp(
      code: code,
      phone: phone,
      type: VerifyOtpRequestType.registration,
    );
  }

  @override
  Future<OtpVerifyResponse> confirmResetPassword(
    String phone,
    String code,
  ) async {
    return _verifyOtp(
      code: code,
      phone: phone,
      type: VerifyOtpRequestType.passwordReset,
    );
  }

  @override
  Future<OtpVerifyResponse> verifyResetPasswordCode(
    String phone,
    String code,
  ) async {
    return _verifyOtp(
      code: code,
      phone: phone,
      type: VerifyOtpRequestType.registration,
    );
  }

  // confirmResetPassword, confirmSignUp, verifyResetPasswordCode — одна логика
  Future<OtpVerifyResponse> _verifyOtp({
    required String code,
    required String phone,
    required VerifyOtpRequestType type,
  }) async {
    try {
      final result = await synamykApi.public.apiAuthVerifyOtpPost(
        body: VerifyOtpRequest(
          type: type,
          code: code,
          phone: normalizePhoneForApi(phone),
        ),
      );

      if (!result.isSuccessful) {
        debugPrint('Phone: $phone, Code: $code');
        debugPrint(result.error.toString());
        throw ExceptionParser.parseResponse(result.statusCode, result.error);
      }

      final body = result.body;
      if (body == null) throw AppException.unknown('Пустой ответ');
      if (body.success != true) throw AppException.unknown('Неверный код');

      return body;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<AuthResponse> signUp(String phone, String password) async {
    try {
      final result = await synamykApi.public.apiAuthRegisterPost(
        body: RegisterRequest(
          phone: normalizePhoneForApi(phone),
          password: password,
          confirmPassword: password,
        ),
      );

      if (!result.isSuccessful) {
        debugPrint(result.body.toString());
        debugPrint(result.error.toString());
        throw ExceptionParser.parseResponse(result.statusCode, result.error);
      }

      final body = result.body;
      if (body == null) throw AppException.unknown('Пустой ответ');
      if (body.token == null || body.refreshToken == null) {
        throw AppException.unknown('Регистрация не удалась');
      }

      await _registrationTokenStorage.saveToken(
        AuthToken(accessToken: body.token!, refreshToken: body.refreshToken!),
      );

      return body;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<AuthResponse> saveUserInfo(RegistrationInfo info) async {
    try {
      final token = await _registrationTokenStorage.getToken();
      if (token == null)
        throw AppException.unknown('Токен регистрации не найден');

      final result = await synamykApi.registration.apiAuthCompleteProfilePost(
        body: CompleteProfileRequest(
          regionId: info.region,
          firstName: info.firstName,
          lastName: info.lastName,
        ),
      );

      if (!result.isSuccessful) {
        throw ExceptionParser.parseResponse(result.statusCode, result.error);
      }

      final body = result.body;
      if (body == null) throw AppException.unknown('Пустой ответ');
      if (body.token == null || body.refreshToken == null) {
        throw AppException.unknown('Ошибка регистрации');
      }

      await _tokenStorage.saveToken(
        AuthToken(accessToken: body.token!, refreshToken: body.refreshToken!),
      );

      return body;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<AuthToken> refreshSession() async {
    try {
      final currentToken = await _tokenStorage.getToken();
      if (currentToken == null) throw AppException.tokenExpired();

      final result = await synamykApi.auth.apiAuthRefreshPost(
        body: RefreshRequest(refreshToken: currentToken.refreshToken),
      );

      if (!result.isSuccessful) {
        throw ExceptionParser.parseResponse(result.statusCode, result.error);
      }

      final body = result.body;
      if (body == null || body.token == null || body.refreshToken == null) {
        throw AppException.tokenExpired();
      }

      final newToken = AuthToken(
        accessToken: body.token!,
        refreshToken: body.refreshToken!,
      );

      await _tokenStorage.saveToken(newToken);
      return newToken;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<AuthToken?> getSavedSession() async {
    try {
      return await _tokenStorage.getToken();
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await synamykApi.auth.apiAuthLogoutPost();
      await _tokenStorage.clearToken();
    } catch (e) {
      // Даже если запрос упал — чистим токен локально
      await _tokenStorage.clearToken();
    }
  }

  @override
  Future<File?> pickAndSaveAvatar() async {
    try {
      final picked = await ImagePickerUtil.pick();
      if (picked == null) return null;
      return _imagePicker.saveAvatar(picked);
    } catch (e) {
      throw AppException.unknown('Не удалось выбрать аватар');
    }
  }

  @override
  Future<void> setNewPassword(
    String resetToken,
    String newPassword,
    String confirmPassword,
  ) async {
    // TODO: реализовать
  }

  @override
  Future<void> changePhoneNumber(String oldPhone, String newPhone) async {
    // TODO: реализовать
  }

  @override
  Future<bool> sendSignUpPhoneConfirmationSms(String phone, AppLanguage lang) =>
      sendOtpSms(phone, OtpType.registration, lang); // 👈 дублирует sendOtpSms

  @override
  Future<void> openPrivacyPolicy() async {
    final uri = Uri.parse(policyUrl);
    final canLaunch = await canLaunchUrl(uri);

    if (!canLaunch) {
      throw Exception('Не удалось открыть ссылку');
    }

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw  Exception('Не удалось открыть ссылку');
    }

  }

  @override
  Future<void> openTermsOfService() async {
    final uri = Uri.parse(termsOfService);
    final canLaunch = await canLaunchUrl(uri);

    if (!canLaunch) {
      throw Exception('Не удалось открыть ссылку');
    }

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw  Exception('Не удалось открыть ссылку');
    }

  }
  
  
  
}
