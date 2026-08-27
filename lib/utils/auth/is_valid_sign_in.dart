class ValidationChecker {
  static bool isValidSignIn(String phone, String password, bool deal) {
    return phone.isNotEmpty && password.isNotEmpty && deal;
  }

  static bool isValidResetPassword(
    String phone,
    String password,
    String newPassword,
  ) {
    return phone.isNotEmpty && password.isNotEmpty && newPassword.isNotEmpty;
  }
}
