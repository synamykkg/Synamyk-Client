enum ExceptionType {
  // Сеть
  network,
  connectionTimeout,

  // Авторизация
  unauthorized,
  tokenExpired,

  // Сервер
  server,
  notFound,

  // Валидация
  validation,

  // Приложение
  unknown,

  // Контент
  noContent,
}

class AppException implements Exception {
  final ExceptionType type;

  /// Сырое сообщение от сервера (если пришло).
  /// Для отображения используй [AppExceptionLocalized.localizedMessage].
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? fieldErrors;

  const AppException({
    required this.type,
    this.message,
    this.statusCode,
    this.fieldErrors,
  });

  // ─── Сеть ────────────────────────────────────────────────

  factory AppException.network() => const AppException(
        type: ExceptionType.network,
      );

  factory AppException.connectionTimeout() => const AppException(
        type: ExceptionType.connectionTimeout,
      );

  // ─── Авторизация ─────────────────────────────────────────

  factory AppException.unauthorized({String? message}) => AppException(
        type: ExceptionType.unauthorized,
        message: message,
        statusCode: 401,
      );

  factory AppException.tokenExpired({String? message}) => AppException(
        type: ExceptionType.tokenExpired,
        message: message,
        statusCode: 401,
      );

  // ─── Сервер ──────────────────────────────────────────────

  factory AppException.server({String? message}) => AppException(
        type: ExceptionType.server,
        message: message,
        statusCode: 500,
      );

  factory AppException.notFound({String? message}) => AppException(
        type: ExceptionType.notFound,
        message: message,
        statusCode: 404,
      );

  // ─── Валидация ───────────────────────────────────────────

  factory AppException.validation({
    String? message,
    Map<String, dynamic>? fieldErrors,
  }) => AppException(
        type: ExceptionType.validation,
        message: message,
        statusCode: 400,
        fieldErrors: fieldErrors,
      );

  // ─── Приложение ──────────────────────────────────────────

  factory AppException.unknown([String? message]) => AppException(
        type: ExceptionType.unknown,
        message: message,
      );

  // ─── Контент ─────────────────────────────────────────────

  factory AppException.noContent([String? message]) => AppException(
        type: ExceptionType.noContent,
        message: message,
        statusCode: 204,
      );

  // ─── Хелперы ─────────────────────────────────────────────

  /// Ошибка по конкретному полю
  String? fieldError(String field) {
    final value = fieldErrors?[field];
    if (value is List && value.isNotEmpty) return value.first.toString();
    if (value != null) return value.toString();
    return null;
  }

  /// Требует ли ошибка выхода из аккаунта
  bool get requiresLogout =>
      [ExceptionType.unauthorized, ExceptionType.tokenExpired].contains(type);

  /// Проблема с сетью
  bool get isNetworkError =>
      [ExceptionType.network, ExceptionType.connectionTimeout].contains(type);

  /// Нет контента
  bool get isNoContent => type == ExceptionType.noContent;

  @override
  String toString() =>
      'AppException(type: $type, status: $statusCode, message: $message)';
}