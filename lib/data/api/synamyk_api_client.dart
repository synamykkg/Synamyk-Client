import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/data/interceptor/auth_interceptor.dart';
import 'package:synamyk/data/services/app_token_storage.dart';
import 'package:synamyk/data/services/registration_token_storage.dart';

class SynamykApiClient {
  // Без токена — для публичных эндпоинтов
  late final SynamykApi _publicApi;

  // Токен для регистрации
  late final SynamykApi _registrationApi;

  // Токен для логина
  late final SynamykApi _authApi;

  // Тоен для сброса пароля
  late final SynamykApi _resetPasswordApi;

  SynamykApiClient({
    required AppTokenStorage appTokenStorage,
    required RegistrationTokenStorage registrationTokenStorage,
    required Uri baseUrl,
  }) {
    _publicApi = SynamykApi.create(
      interceptors: [],
      baseUrl: baseUrl
    );

    _registrationApi = SynamykApi.create(
      interceptors: [AuthInterceptor(tokenStorage: registrationTokenStorage)],
      baseUrl: baseUrl
    );

    _authApi = SynamykApi.create(
      interceptors: [AuthInterceptor(tokenStorage: appTokenStorage)],
      baseUrl: baseUrl
    );

    _resetPasswordApi = SynamykApi.create(
      interceptors: [AuthInterceptor(tokenStorage: appTokenStorage)],
      baseUrl: baseUrl
    );
  }

  SynamykApi get public => _publicApi;
  SynamykApi get registration => _registrationApi;
  SynamykApi get auth => _authApi;
}
