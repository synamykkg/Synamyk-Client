import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/services/app_token_storage.dart';
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
    final token = await _tokenStorage.getToken();
    final baseUrl = _synamykApi.auth.client.baseUrl.toString();

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        jpegBytes,
        filename: 'avatar.jpg',
        contentType: MediaType('image', 'jpeg'),
      ),
    });

    try {
      final response = await _dio.post(
        '$baseUrl/api/profile/avatar',
        data: formData,
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer ${token.accessToken}',
          },
        ),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw AppException.unknown('Некорректный ответ сервера');
      }
      return data;
    } on DioException catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
