enum OtpType {
  registration,
  passwordReset;

  String get value => switch (this) {
    OtpType.registration => 'REGISTRATION',
    OtpType.passwordReset => 'PASSWORD_RESET',
  };
}
