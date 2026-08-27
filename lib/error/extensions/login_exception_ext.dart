import 'package:synamyk/error/app_exception.dart';

extension LoginFieldErrorX on AppException {

  String? get phoneFieldError {
    final msg = message?.toLowerCase();
    if (msg == null) return null;

    if (msg.contains('phone') ||
        msg.contains('номер') ||
        msg.contains('телефон')) {
      return message;
    }
    return null;
  }

  String? get passwordFieldError {
    final msg = message?.toLowerCase();
    if (msg == null) return null;

    if (msg.contains('password') ||
        msg.contains('пароль') ||
        msg.contains('credentials')) {
      return message;
    }
    return null;
  }

  bool get isFieldError => phoneFieldError != null || passwordFieldError != null;
}