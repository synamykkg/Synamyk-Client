import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/game/game_repository.dart';
import 'package:synamyk/data/repositories/profile/profile_repository.dart';
import 'package:synamyk/data/services/game_socket_service.dart';
import 'package:synamyk/domain/models/game/game_event.dart';
import 'package:synamyk/domain/models/game/game_question.dart';
import 'package:synamyk/domain/models/game/join_game_result.dart';
import 'package:synamyk/domain/models/game/room_state.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameBlocEvent, GameBlocState> {
  GameBloc({
    required GameRepository gameRepository,
    required ProfileRepository profileRepository,
    required GameSocketService socketService,
  }) : _gameRepository = gameRepository,
       _profileRepository = profileRepository,
       _socketService = socketService,
       super(const GameIdle()) {
    on<GameJoinRequested>(_onJoinRequested);
    on<GameLeaveQueueRequested>(_onLeaveQueueRequested);
    on<GameAnswerSubmitted>(_onAnswerSubmitted);
    on<GameExited>(_onExited);
    on<GameForfeitRequested>(_onForfeitRequested);
    on<_GameSocketEventReceived>(_onSocketEvent);
    on<_GameSocketDisconnected>(_onSocketDisconnected);
  }

  final GameRepository _gameRepository;
  final ProfileRepository _profileRepository;
  final GameSocketService _socketService;

  StreamSubscription<GameEvent>? _socketSubscription;
  int? _gameTestId;
  int? _myUserId;
  bool _amIPlayer1 = true;
  String _myName = '';
  String _opponentName = '';
  String? _opponentAvatar;
  bool _opponentIsBot = false;

  /// Tears down the socket and (best-effort) leaves the matchmaking queue.
  ///
  /// The UI awaits this directly — rather than dispatching an event and
  /// popping the route right after — so the old socket is fully deactivated
  /// before a new one can be created for another room. Racing those two
  /// left two STOMP clients alive at once, which the server then bounced
  /// into a tight reconnect loop.
  Future<void> leaveRoom() async {
    final gameTestId = _gameTestId;
    await _teardownSocket();
    if (gameTestId != null) {
      try {
        await _gameRepository.leaveQueue(gameTestId);
      } catch (_) {
        // Best-effort — the room will time out server-side regardless.
      }
    }
  }

  Future<void> _onJoinRequested(
    GameJoinRequested event,
    Emitter<GameBlocState> emit,
  ) async {
    emit(const GameJoining());
    _gameTestId = event.gameTestId;

    try {
      _myUserId ??= (await _profileRepository.getUserInfo()).id;
      final myUserId = _myUserId;
      if (myUserId == null) {
        emit(const GameFailure(message: 'Не удалось определить пользователя'));
        return;
      }

      final JoinGameResult joinResult = await _gameRepository.joinGame(
        event.gameTestId,
      );

      await _socketService.connect(
        roomId: joinResult.roomId,
        myUserId: myUserId,
        onReconnected: () => _resyncRoom(joinResult.roomId),
      );

      await _socketSubscription?.cancel();
      _socketSubscription = _socketService.events.listen(
        (e) => add(_GameSocketEventReceived(e)),
        onDone: () => add(_GameSocketDisconnected()),
      );

      emit(
        GameWaitingForOpponent(
          roomId: joinResult.roomId,
          message: joinResult.message,
        ),
      );
    } catch (e) {
      emit(GameFailure(message: 'Не удалось подключиться к игре'));
    }
  }

  Future<void> _resyncRoom(int roomId) async {
    // Fire-and-forget: the resulting snapshot arrives through the same
    // event pipeline as a synthetic re-entry, so we just re-request state
    // and let the normal handlers below react to it directly.
    try {
      final state = await _gameRepository.getRoomState(roomId);
      switch (state) {
        case RoomStateInProgress s:
          _opponentIsBot = s.player1Id == -1 || s.player2Id == -1;
          _amIPlayer1 = s.player1Id == _myUserId;
          _myName = _amIPlayer1 ? s.player1Name : s.player2Name;
          _opponentName = _amIPlayer1 ? s.player2Name : s.player1Name;
          _opponentAvatar = _amIPlayer1 ? s.player2Avatar : s.player1Avatar;
          add(
            _GameSocketEventReceived(
              NextQuestionEvent(
                roomId: s.roomId,
                questionIndex: s.questionIndex,
                totalQuestions: s.totalQuestions,
                timeLimitSeconds: s.remainingSeconds,
                question: s.question,
                player1Score: s.player1Score,
                player2Score: s.player2Score,
              ),
            ),
          );
        case RoomStateFinished s:
          add(
            _GameSocketEventReceived(
              GameOverEvent(
                roomId: s.roomId,
                player1Score: s.player1Score,
                player2Score: s.player2Score,
                winnerId: s.winnerId,
              ),
            ),
          );
        case RoomStateAbandoned _:
          add(_GameSocketDisconnected());
        case RoomStateWaiting _:
          break;
      }
    } catch (_) {
      // Keep whatever is currently on screen; the next successful poll or
      // socket event will correct it.
    }
  }

  Future<void> _onLeaveQueueRequested(
    GameLeaveQueueRequested event,
    Emitter<GameBlocState> emit,
  ) async {
    await leaveRoom();
    emit(const GameIdle());
  }

  void _onAnswerSubmitted(
    GameAnswerSubmitted event,
    Emitter<GameBlocState> emit,
  ) {
    final current = state;
    if (current is! GameInProgress || current.selectedOptionId != null) {
      return;
    }

    emit(current.copyWith(selectedOptionId: event.optionId));
    _socketService.sendAnswer(
      roomId: current.roomId,
      optionId: event.optionId,
    );
  }

  Future<void> _onExited(
    GameExited event,
    Emitter<GameBlocState> emit,
  ) async {
    await _teardownSocket();
    emit(const GameIdle());
  }

  Future<void> _onForfeitRequested(
    GameForfeitRequested event,
    Emitter<GameBlocState> emit,
  ) async {
    final current = state;
    if (current is! GameInProgress) return;

    try {
      await _gameRepository.forfeit(current.roomId);
    } catch (_) {
      // GAME_OVER still arrives over the socket if the server accepted the
      // call; if the request itself failed, the user can just try again.
    }
  }

  void _onSocketEvent(
    _GameSocketEventReceived event,
    Emitter<GameBlocState> emit,
  ) {
    final myUserId = _myUserId;
    if (myUserId == null) return;

    switch (event.event) {
      case GameStartedEvent e:
        _amIPlayer1 = e.player1Id == myUserId;
        _myName = _amIPlayer1 ? e.player1Name : e.player2Name;
        _opponentName = _amIPlayer1 ? e.player2Name : e.player1Name;
        _opponentAvatar = _amIPlayer1 ? e.player2Avatar : e.player1Avatar;
        _opponentIsBot = e.opponentIsBot;
        emit(
          GameWaitingForOpponent(
            roomId: e.roomId,
            message: 'Игра начинается…',
          ),
        );

      case NextQuestionEvent e:
        final myScore = _amIPlayer1 ? e.player1Score : e.player2Score;
        final opponentScore = _amIPlayer1 ? e.player2Score : e.player1Score;
        emit(
          GameInProgress(
            roomId: e.roomId,
            myName: _myName,
            opponentName: _opponentName,
            opponentAvatar: _opponentAvatar,
            opponentIsBot: _opponentIsBot,
            myScore: myScore,
            opponentScore: opponentScore,
            question: e.question,
            questionIndex: e.questionIndex,
            totalQuestions: e.totalQuestions,
            timeLimitSeconds: e.timeLimitSeconds,
            questionStartedAt: DateTime.now(),
          ),
        );

      case AnswerResultEvent e:
        final current = state;
        if (current is GameInProgress && current.roomId == e.roomId) {
          final myScore = _amIPlayer1 ? e.player1Score : e.player2Score;
          final opponentScore =
              _amIPlayer1 ? e.player2Score : e.player1Score;
          emit(
            current.copyWith(
              myScore: myScore,
              opponentScore: opponentScore,
              lastAnswerCorrect: e.correct,
            ),
          );
        }

      case GameOverEvent e:
        final myScore = _amIPlayer1 ? e.player1Score : e.player2Score;
        final opponentScore = _amIPlayer1 ? e.player2Score : e.player1Score;
        final won = e.winnerId != null && e.winnerId == myUserId;
        final draw = e.winnerId == null && e.forfeitedBy == null;
        final forfeitedByMe =
            e.forfeitedBy != null && e.forfeitedBy == myUserId;
        final forfeitedByOpponent =
            e.forfeitedBy != null && e.forfeitedBy != myUserId;
        emit(
          GameFinished(
            myScore: myScore,
            opponentScore: opponentScore,
            won: won,
            draw: draw,
            forfeitedByMe: forfeitedByMe,
            forfeitedByOpponent: forfeitedByOpponent,
            ratingChange:
                _amIPlayer1 ? e.player1RatingChange : e.player2RatingChange,
            newRating: _amIPlayer1 ? e.player1Rating : e.player2Rating,
          ),
        );
        unawaited(_teardownSocket());
    }
  }

  void _onSocketDisconnected(
    _GameSocketDisconnected event,
    Emitter<GameBlocState> emit,
  ) {
    // stomp_dart_client retries the underlying connection on its own; we
    // just wait for the next successful reconnect (which triggers a resync)
    // instead of failing the screen outright.
  }

  Future<void> _teardownSocket() async {
    await _socketSubscription?.cancel();
    _socketSubscription = null;
    await _socketService.disconnect();
  }

  @override
  Future<void> close() async {
    await _teardownSocket();
    return super.close();
  }
}
