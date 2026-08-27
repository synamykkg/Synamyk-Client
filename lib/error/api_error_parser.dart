import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/error/exceptions.dart';

// AppException parseApiError(Map<String, dynamic> body) {
//   if (body.containsKey('message')) {
//     return AlreadyRegisteredException(body['message'] as String);
//   }

//   if (body.containsKey('phone')) {
//     return PhoneValidationException(body['phone'] as String);
//   }
//   return const AppException('Неизвестная ошибка');
// }

class ExceptionParser {
  static AppException parse(dynamic error) {
    if (error is DioException) return _parseDio(error);
    if (error is AppException) return error;
    return AppException.unknown(error.toString());
  }

  // ─── Swagger ────────────────────────────────────────────────
  static AppException parseResponse(int? statusCode, dynamic data) {
    return _parseResponse(statusCode, data);
  }

  // ─── Dio ────────────────────────────────────────────────
  static AppException _parseDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionError:
        return AppException.network();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return AppException.connectionTimeout();
      default:
        break;
    }

    final response = error.response;
    if (response == null) return AppException.unknown();

    return _parseResponse(response.statusCode, response.data);
  }

  // ─── Парсинг по статус коду ──────────────────────────────
  static AppException _parseResponse(int? statusCode, dynamic data) {
    if (data is String) {
      try {
        data = jsonDecode(data);
      } catch (_) {}
    }

    // Достаём message и fieldErrors прямо с сервера
    final message = _extractMessage(data);
    final fields = _extractFieldErrors(data);

    return switch (statusCode) {
      400        => AppException.validation(message: message, fieldErrors: fields),
      401        => _parse401(data, message),
      403        => AppException.unauthorized(message: message),
      404        => AppException.notFound(message: message),
      int s when s >= 500     => AppException.server(message: message),
      _          => AppException.unknown(message),
    };
  }

  // ─── 401 — токен или авторизация ─────────────────────────
  static AppException _parse401(dynamic data, String? message) {
    // Если сервер явно говорит что токен истёк
    if (data is Map) {
      final code = data['code']?.toString().toUpperCase();
      if (code == 'TOKEN_EXPIRED') return AppException.tokenExpired(message: message);
    }
    return AppException.unauthorized(message: message);
  }

  // ─── Хелперы ─────────────────────────────────────────────
  static String? _extractMessage(dynamic data) {
    if (data == null) return null;
    if (data is String) return data;
    if (data is Map) {
      if (data['message'] is String) return data['message'];
      return null;
    }
    return null;
  }

  static Map<String, dynamic>? _extractFieldErrors(dynamic data) {
    if (data is! Map) return null;
    
    if (data['message'] is Map) {
      return Map<String, dynamic>.from(data['message']);
    }

    final errors = data['errors'] ?? data['fields'] ?? data['validation'];
    if (errors is Map) return Map<String, dynamic>.from(errors);
    
    if (!data.containsKey('message') && !data.containsKey('errors')) {
      return Map<String, dynamic>.from(data);
    }

    return null;
  }
}
