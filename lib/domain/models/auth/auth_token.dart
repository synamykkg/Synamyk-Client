class AuthToken {
  final String accessToken;
  final String refreshToken;

  AuthToken({
    required this.accessToken,
    required this.refreshToken,
  });

  AuthToken copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthToken(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}