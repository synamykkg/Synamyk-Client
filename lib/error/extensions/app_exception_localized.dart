import 'package:synamyk/l10n/generated/app_localizations.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/generated/l10n.dart';

import 'package:synamyk/error/app_exception.dart';

extension AppExceptionLocalized on AppException {
  /// Возвращает локализованное сообщение для отображения пользователю.
  ///
  /// Приоритет:
  /// 1. Сырое сообщение от сервера [message] (если не пустое)
  /// 2. Локализованный дефолт по [type]
  String localizedMessage(S l10n) {
    if (message != null && message!.isNotEmpty) return message!;

    return switch (type) {
      ExceptionType.network => l10n.errorNetwork,
      ExceptionType.connectionTimeout => l10n.errorConnectionTimeout,
      ExceptionType.unauthorized => l10n.errorUnauthorized,
      ExceptionType.tokenExpired => l10n.errorTokenExpired,
      ExceptionType.server => l10n.errorServer,
      ExceptionType.notFound => l10n.errorNotFound,
      ExceptionType.validation => l10n.errorValidation,
      ExceptionType.noContent => l10n.errorNoContent,
      ExceptionType.unknown => l10n.errorUnknown,
    };
  }
}
