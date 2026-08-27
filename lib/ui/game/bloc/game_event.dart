part of 'game_bloc.dart';

sealed class GameBlocEvent {}

/// User tapped "Play" on a game test — join the matchmaking queue.
class GameJoinRequested extends GameBlocEvent {
  GameJoinRequested({required this.gameTestId});
  final int gameTestId;
}

/// User cancelled matchmaking while still `WAITING`.
class GameLeaveQueueRequested extends GameBlocEvent {}

/// User tapped an answer option.
class GameAnswerSubmitted extends GameBlocEvent {
  GameAnswerSubmitted({required this.optionId});
  final int optionId;
}

/// User left the game screen — tear down the socket.
class GameExited extends GameBlocEvent {}

/// User tapped "Forfeit" during an in-progress game.
class GameForfeitRequested extends GameBlocEvent {}

/// Internal: a parsed event arrived over the WebSocket.
class _GameSocketEventReceived extends GameBlocEvent {
  _GameSocketEventReceived(this.event);
  final GameEvent event;
}

/// Internal: the WebSocket connection dropped.
class _GameSocketDisconnected extends GameBlocEvent {}
