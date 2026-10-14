import 'package:dio/dio.dart';
import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/services/app_token_storage.dart';
import 'package:synamyk/data/services/token_storage.dart';
import 'package:synamyk/domain/models/auth/auth_token.dart';
import 'package:synamyk/error/api_error_parser.dart';
import 'package:synamyk/error/app_exception.dart';

/// Raw JSON response of [SynamykRestClient]: `data` is `null` for 204.
class RestResponse {
  const RestResponse(this.statusCode, this.data);

  final int statusCode;
  final dynamic data;

  bool get isNoContent => statusCode == 204 || data == null || data == '';

  Map<String, dynamic> get map {
    final d = data;
    if (d is Map<String, dynamic>) return d;
    throw AppException.unknown('Некорректный ответ сервера');
  }

  List<dynamic> get list {
    final d = data;
    if (d is List) return d;
    throw AppException.unknown('Некорректный ответ сервера');
  }
}

/// Dio client for the endpoints that aren't in the generated OpenAPI client
/// yet (full ОРТ attempts, products, schools, referrals, game rating).
///
/// Unlike the one-off raw Dio calls elsewhere, it refreshes an expired access
/// token once and retries, and turns every failure into an [AppException]
/// whose `message` is the server's localized text.
class SynamykRestClient {
  SynamykRestClient({
    required Dio dio,
    required AppTokenStorage tokenStorage,
    required SynamykApiClient synamykApi,
    String Function()? languageCode,
  }) : _languageCode = languageCode,
       _dio = dio,
       _tokenStorage = tokenStorage,
       _synamykApi = synamykApi;

  final Dio _dio;
  final AppTokenStorage _tokenStorage;
  final SynamykApiClient _synamykApi;

  /// `ru` / `ky` — lets the server localize errors on public endpoints,
  /// where it can't read the language from the user's profile.
  final String Function()? _languageCode;

  String get _baseUrl {
    final url = _synamykApi.auth.client.baseUrl.toString();
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  Future<RestResponse> get(
    String path, {
    Map<String, dynamic>? query,
    bool auth = true,
  }) => _send('GET', path, query: query, auth: auth);

  Future<RestResponse> post(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    bool auth = true,
    TokenStorage? tokenStorage,
  }) => _send(
    'POST',
    path,
    body: body,
    query: query,
    auth: auth,
    tokenStorage: tokenStorage,
  );

  Future<RestResponse> put(String path, {Object? body}) =>
      _send('PUT', path, body: body);

  Future<RestResponse> _send(
    String method,
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    bool auth = true,
    TokenStorage? tokenStorage,
  }) async {
    final storage = tokenStorage ?? _tokenStorage;
    final cleanQuery = query == null
        ? null
        : (Map.of(query)..removeWhere((_, v) => v == null));

    Future<Response<dynamic>> attempt(String? accessToken) {
      return _dio.request<dynamic>(
        '$_baseUrl$path',
        data: body,
        queryParameters: cleanQuery,
        options: Options(
          method: method,
          headers: {
            if (accessToken != null) 'Authorization': 'Bearer $accessToken',
            if (_languageCode != null) 'Accept-Language': _languageCode(),
          },
        ),
      );
    }

    try {
      final token = auth ? await storage.getToken() : null;
      Response<dynamic> response;
      try {
        response = await attempt(token?.accessToken);
      } on DioException catch (e) {
        // Only the main app token can be refreshed; a registration token
        // that expired means the sign-up flow has to start over anyway.
        final canRefresh =
            e.response?.statusCode == 401 &&
            token != null &&
            identical(storage, _tokenStorage);
        if (!canRefresh) rethrow;
        final refreshed = await _refreshToken(token.refreshToken);
        if (refreshed == null) rethrow;
        await _tokenStorage.saveToken(refreshed);
        response = await attempt(refreshed.accessToken);
      }
      return RestResponse(response.statusCode ?? 200, response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  Future<AuthToken?> _refreshToken(String refreshToken) async {
    try {
      final result = await _synamykApi.auth.apiAuthRefreshPost(
        body: RefreshRequest(refreshToken: refreshToken),
      );
      final body = result.body;
      if (!result.isSuccessful ||
          body == null ||
          body.token == null ||
          body.refreshToken == null) {
        return null;
      }
      return AuthToken(
        accessToken: body.token!,
        refreshToken: body.refreshToken!,
      );
    } catch (_) {
      return null;
    }
  }
}
