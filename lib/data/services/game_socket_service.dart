import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:synamyk/config/app_config.dart';
import 'package:synamyk/data/services/app_token_storage.dart';
import 'package:synamyk/domain/models/game/game_event.dart';

/// Wraps a STOMP-over-WebSocket connection to the quiz-duel game room.
///
/// Backend contract: connect to `/ws` with the JWT in the STOMP CONNECT
/// header (browsers can't set custom WebSocket headers, so it must travel in
/// `stompConnectHeaders`, not `webSocketConnectHeaders`). Subscribe to
/// `/topic/game/{roomId}` (shared events) and
/// `/topic/game/{roomId}/answers/{userId}` (private answer results) right
/// after connecting, before `GAME_STARTED` arrives.
class GameSocketService {
  GameSocketService({required AppTokenStorage tokenStorage})
    : _tokenStorage = tokenStorage;

  final AppTokenStorage _tokenStorage;

  StompClient? _client;
  StreamController<GameEvent>? _eventsController;
  StompUnsubscribe? _unsubscribeTopic;
  StompUnsubscribe? _unsubscribeAnswers;

  Stream<GameEvent> get events =>
      _eventsController?.stream ?? const Stream.empty();

  bool get isConnected => _client?.connected ?? false;

  static String get _wsUrl {
    final base = AppConfig.baseUrl;
    final wsBase = base
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://');
    return '$wsBase/ws';
  }

  Future<void> connect({
    required int roomId,
    required int myUserId,
    void Function()? onReconnected,
  }) async {
    await disconnect();

    final token = await _tokenStorage.getToken();
    final controller = StreamController<GameEvent>.broadcast();
    _eventsController = controller;

    final completer = Completer<void>();
    var hasConnectedOnce = false;

    final client = StompClient(
      config: StompConfig(
        url: _wsUrl,
        stompConnectHeaders: {
          if (token != null) 'Authorization': 'Bearer ${token.accessToken}',
        },
        connectionTimeout: const Duration(seconds: 10),
        onConnect: (frame) {
          _unsubscribeTopic = _client?.subscribe(
            destination: '/topic/game/$roomId',
            callback: (f) => _handleFrame(f, controller),
          );
          _unsubscribeAnswers = _client?.subscribe(
            destination: '/topic/game/$roomId/answers/$myUserId',
            callback: (f) => _handleFrame(f, controller),
          );
          if (!completer.isCompleted) {
            completer.complete();
          } else if (hasConnectedOnce) {
            onReconnected?.call();
          }
          hasConnectedOnce = true;
        },
        onWebSocketError: (dynamic error) {
          if (!completer.isCompleted) completer.completeError(error);
        },
        onStompError: (frame) {
          if (!completer.isCompleted) {
            completer.completeError(
              StateError(frame.body ?? 'STOMP error'),
            );
          }
        },
      ),
    );

    _client = client;
    client.activate();

    return completer.future;
  }

  void _handleFrame(StompFrame frame, StreamController<GameEvent> controller) {
    final body = frame.body;
    if (body == null || body.isEmpty) return;

    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final event = GameEvent.fromJson(json);
      if (event != null && !controller.isClosed) controller.add(event);
    } catch (_) {
      // Ignore malformed frames.
    }
  }

  void sendAnswer({required int roomId, required int optionId}) {
    _client?.send(
      destination: '/app/game/$roomId/answer',
      body: jsonEncode({'optionId': optionId}),
    );
  }

  Future<void> disconnect() async {
    _unsubscribeTopic?.call();
    _unsubscribeAnswers?.call();
    _unsubscribeTopic = null;
    _unsubscribeAnswers = null;

    _client?.deactivate();
    _client = null;

    await _eventsController?.close();
    _eventsController = null;
  }
}
