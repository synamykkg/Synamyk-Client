import 'package:synamyk/domain/models/game/game_history_entry.dart';
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
}
