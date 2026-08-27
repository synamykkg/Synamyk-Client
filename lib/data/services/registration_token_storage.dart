import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synamyk/data/services/token_storage.dart';
import 'package:synamyk/domain/models/auth/auth_token.dart';

class RegistrationTokenStorage implements TokenStorage {
  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  RegistrationTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> saveToken(AuthToken token) async {
    await _storage.write(key: _accessTokenKey, value: token.accessToken);
    await _storage.write(key: _refreshTokenKey, value: token.refreshToken);
  }

  @override
  Future<AuthToken?> getToken() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    final refreshToken = await _storage.read(key: _refreshTokenKey);

    if (accessToken != null && refreshToken != null) {
      return AuthToken(accessToken: accessToken, refreshToken: refreshToken);
    }
    return null;
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
