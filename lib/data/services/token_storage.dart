import 'package:synamyk/domain/models/auth/auth_token.dart';

abstract class TokenStorage {
  Future<void> saveToken(AuthToken token);

  Future<AuthToken?> getToken();

  Future<void> clearToken();
}
