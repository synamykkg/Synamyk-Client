import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:synamyk/data/services/app_token_storage.dart';
import 'package:synamyk/data/services/token_storage.dart';

enum TokenType { registration, auth }

class AuthInterceptor implements Interceptor {
  final TokenStorage tokenStorage;

  AuthInterceptor({required this.tokenStorage});

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final token = await tokenStorage.getToken();
    if (token != null) {
      final request = applyHeader(
        chain.request,
        'Authorization',
        'Bearer ${token.accessToken}',
      );
      return await chain.proceed(request);
    }
    
    return await chain.proceed(chain.request);
  }
}
