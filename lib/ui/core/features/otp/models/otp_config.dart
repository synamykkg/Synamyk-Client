class OtpConfig {
  final String phone;

  /// Вызывается при вводе кода — сюда передаём нужный API метод
  final Future<void> Function(String code, String phone) onConfirm;

  /// Вызывается при нажатии "Отправить код заново"
  final Future<void> Function(String phone) onResend;

  /// Куда идти после успешного подтверждения
  final String successRoute;

  /// Опционально: extra для successRoute
  final Object? successExtra;

  const OtpConfig({
    required this.phone,
    required this.onConfirm,
    required this.onResend,
    required this.successRoute,
    this.successExtra,
  });
}