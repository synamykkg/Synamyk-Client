import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/game/game_history_entry.dart';
import 'package:synamyk/domain/models/game/game_rating.dart';
import 'package:synamyk/domain/models/game/game_test_model.dart';
import 'package:synamyk/domain/models/game/join_game_result.dart';
import 'package:synamyk/domain/models/game/room_state.dart';

abstract class GameRepository {
  Future<List<GameTestModel>> getGameTests({bool unplayedOnly = false});

  Future<JoinGameResult> joinGame(int gameTestId);

  Future<void> leaveQueue(int gameTestId);

  Future<RoomState> getRoomState(int roomId);

  /// Forfeits an in-progress game. Only valid while the room is IN_PROGRESS —
  /// use [leaveQueue] instead while still WAITING for an opponent.
  Future<void> forfeit(int roomId);

  Future<List<GameHistoryEntry>> getHistory();

  /// The current user's Elo rating, league and streak.
  Future<GameRating> getMyRating();

  /// Players with at least one game, by rating descending.
  Future<PagedResult<GameRating>> getLeaderboard({int page = 0, int size = 50});
}
