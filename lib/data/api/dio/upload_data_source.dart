import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/services/app_token_storage.dart';
import 'package:synamyk/domain/models/auth/auth_token.dart';
import 'package:synamyk/error/api_error_parser.dart';
import 'package:synamyk/error/app_exception.dart';

class UploadDataSource {
  final Dio _dio;
  final AppTokenStorage _tokenStorage;
  final SynamykApiClient _synamykApi;

  UploadDataSource({
    required Dio dio,
    required AppTokenStorage tokenStorage,
    required SynamykApiClient synamykApi,
  }) : _dio = dio,
       _tokenStorage = tokenStorage,
       _synamykApi = synamykApi;

  Future<String> uploadAvatar(String filePath) async {
    final token = await _tokenStorage.getToken();
    final baseUrl = _synamykApi.auth.client.baseUrl.toString();
    final file = File(filePath);

    if (!await file.exists()) {
      throw AppException.unknown('Avatar file not found');
    }

    final tempDir = await getTemporaryDirectory();
    final ext = p.extension(filePath);
    final cleanFile = await file.copy('${tempDir.path}/avatar$ext');

    final formData = FormData.fromMap({
      'type': 'AVATAR', // ← исправлено
      'file': await MultipartFile.fromFile(
        cleanFile.path,
        filename: 'avatar$ext',
      ),
    });

    debugPrint('=== UPLOAD REQUEST ===');
    debugPrint('URL: $baseUrl/api/upload');
    debugPrint('Token: ${token?.accessToken}');
    debugPrint('File path: ${cleanFile.path}');
    debugPrint('File exists: ${await cleanFile.exists()}');
    debugPrint('File size: ${await cleanFile.length()} bytes');
    debugPrint('Form fields: ${formData.fields}');
    debugPrint('Form files: ${formData.files.map((f) => f.value.filename)}');

    try {
      final response = await _dio.post(
        '$baseUrl/api/upload',
        data: formData,
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer ${token.accessToken}',
          },
        ),
      );

      debugPrint('=== UPLOAD RESPONSE ===');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Data: ${response.data}');

      final url = response.data?['url'] as String?;
      if (url == null || !url.startsWith('http')) {
        throw AppException.unknown('Server returned invalid avatar URL');
      }

      return url;
    } on DioException catch (e) {
      debugPrint('=== UPLOAD ERROR ===');
      debugPrint('Status: ${e.response?.statusCode}');
      debugPrint('Response data: ${e.response?.data}');
      debugPrint('Message: ${e.message}');

      rethrow;
    }
  }

  /// New dedicated avatar endpoint (`POST /api/profile/avatar`) — one
  /// request, returns the full updated profile. Uses raw Dio (rather than
  /// the swagger-generated `apiProfileAvatarPost`) because chopper's
  /// `@PartFile()` codegen sends the bytes via `MultipartFile.fromBytes`
  /// with no filename/content-type, which some servers reject as "not an
  /// image".
  Future<Map<String, dynamic>> uploadProfileAvatar(Uint8List jpegBytes) async {
    final baseUrl = _synamykApi.auth.client.baseUrl.toString();

    Future<Response> attempt(String? accessToken) {
      // FormData holds a single-use byte stream, so it must be rebuilt for
      // every attempt (a retry can't reuse the one from the first try).
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          jpegBytes,
          filename: 'avatar.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      });
      return _dio.post(
        '$baseUrl/api/profile/avatar',
        data: formData,
        options: Options(
          headers: {
            if (accessToken != null) 'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    }

    try {
      final token = await _tokenStorage.getToken();
      Response response;
      try {
        response = await attempt(token?.accessToken);
      } on DioException catch (e) {
        // This request goes through raw Dio (not the chopper client with
        // its auth interceptor), so it's the one call in the app with no
        // built-in access-token refresh. A stale token here otherwise
        // surfaces as an opaque "не удалось обновить фото" — refresh once
        // and retry before giving up.
        if (e.response?.statusCode == 401 && token != null) {
          final refreshed = await _refreshToken(token.refreshToken);
          if (refreshed == null) rethrow;
          await _tokenStorage.saveToken(refreshed);
          response = await attempt(refreshed.accessToken);
        } else {
          rethrow;
        }
      }

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw AppException.unknown('Некорректный ответ сервера');
      }
      return data;
    } on DioException catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  Future<AuthToken?> _refreshToken(String refreshToken) async {
    try {
      final result = await _synamykApi.auth.apiAuthRefreshPost(
        body: RefreshRequest(refreshToken: refreshToken),
      );
      final body = result.body;
      if (!result.isSuccessful ||
          body == null ||
          body.token == null ||
          body.refreshToken == null) {
        return null;
      }
      return AuthToken(accessToken: body.token!, refreshToken: body.refreshToken!);
    } catch (_) {
      return null;
    }
  }
}
