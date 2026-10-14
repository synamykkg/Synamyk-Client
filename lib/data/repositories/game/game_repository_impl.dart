import 'package:dio/dio.dart';
import 'package:synamyk/config/app_config.dart';
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/repositories/game/game_repository.dart';
import 'package:synamyk/data/services/app_token_storage.dart';
import 'package:synamyk/domain/models/common/json_read.dart';
import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/game/game_history_entry.dart';
import 'package:synamyk/domain/models/game/game_rating.dart';
import 'package:synamyk/domain/models/game/game_test_model.dart';
import 'package:synamyk/domain/models/game/join_game_result.dart';
import 'package:synamyk/domain/models/game/room_state.dart';
import 'package:synamyk/error/api_error_parser.dart';
import 'package:synamyk/error/app_exception.dart';

/// Most `/api/game/**` endpoints are still raw-Dio because they weren't in
/// the OpenAPI spec when this repository was written. `getGameTests` is the
/// exception — `/api/game/tests` is now in the spec, so it goes through the
/// generated swagger client like the rest of the app.
class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl({
    required Dio dio,
    required AppTokenStorage tokenStorage,
    required SynamykApiClient synamykApi,
  }) : _dio = dio,
       _tokenStorage = tokenStorage,
       _synamykApi = synamykApi;

  final Dio _dio;
  final AppTokenStorage _tokenStorage;
  final SynamykApiClient _synamykApi;

  Future<Options> _authOptions() async {
    final token = await _tokenStorage.getToken();
    return Options(
      headers: {
        if (token != null) 'Authorization': 'Bearer ${token.accessToken}',
      },
    );
  }

  @override
  Future<List<GameTestModel>> getGameTests({bool unplayedOnly = false}) async {
    try {
      final response = await _synamykApi.auth.apiGameTestsGet(
        unplayedOnly: unplayedOnly,
      );
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(response.statusCode, response.error);
      }
      final body = response.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      return body
          .map(
            (e) => GameTestModel(
              id: e.id ?? (throw AppException.unknown()),
              title: e.title ?? '',
              description: e.description ?? '',
              timeLimitSeconds: e.timeLimitSeconds ?? 0,
              questionsPerGame: e.questionsPerGame ?? 0,
              questionCount: e.questionCount ?? 0,
              played: e.played ?? false,
              myBestScore: e.myBestScore,
              lastPlayedAt: e.lastPlayedAt,
              playCount: e.playCount ?? 0,
            ),
          )
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<JoinGameResult> joinGame(int gameTestId) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}/api/game/join/$gameTestId',
        options: await _authOptions(),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw AppException.unknown('Пустой ответ');
      }

      return JoinGameResult.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<void> leaveQueue(int gameTestId) async {
    try {
      await _dio.delete(
        '${AppConfig.baseUrl}/api/game/queue/$gameTestId',
        options: await _authOptions(),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<RoomState> getRoomState(int roomId) async {
    try {
      final response = await _dio.get(
        '${AppConfig.baseUrl}/api/game/$roomId/state',
        options: await _authOptions(),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw AppException.unknown('Пустой ответ');
      }

      return RoomState.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<void> forfeit(int roomId) async {
    try {
      await _dio.post(
        '${AppConfig.baseUrl}/api/game/$roomId/forfeit',
        options: await _authOptions(),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<List<GameHistoryEntry>> getHistory() async {
    try {
      final response = await _dio.get(
        '${AppConfig.baseUrl}/api/game/history',
        options: await _authOptions(),
      );
      final data = response.data;
      if (data is! List) throw AppException.unknown('Пустой ответ');

      return data
          .map((e) => GameHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<GameRating> getMyRating() async {
    try {
      final response = await _dio.get(
        '${AppConfig.baseUrl}/api/game/rating/me',
        options: await _authOptions(),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw AppException.unknown('Пустой ответ');
      }
      return GameRating.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<PagedResult<GameRating>> getLeaderboard({
    int page = 0,
    int size = 50,
  }) async {
    try {
      final response = await _dio.get(
        '${AppConfig.baseUrl}/api/game/leaderboard',
        queryParameters: {'page': page, 'size': size},
        options: await _authOptions(),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw AppException.unknown('Пустой ответ');
      }
      return readPage(data, GameRating.fromJson, page);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
