import 'package:synamyk/domain/models/game/game_question.dart';

/// Snapshot of a game room, used to resync the screen after a WebSocket
/// reconnect (`GET /api/game/{roomId}/state`).
sealed class RoomState {
  const RoomState({required this.roomId});

  final int roomId;

  static RoomState fromJson(Map<String, dynamic> json) {
    return switch (json['status']) {
      'IN_PROGRESS' => RoomStateInProgress.fromJson(json),
      'FINISHED' => RoomStateFinished.fromJson(json),
      'ABANDONED' => RoomStateAbandoned(roomId: json['roomId'] as int),
      _ => RoomStateWaiting(roomId: json['roomId'] as int),
    };
  }
}

class RoomStateWaiting extends RoomState {
  const RoomStateWaiting({required super.roomId});
}

class RoomStateInProgress extends RoomState {
  const RoomStateInProgress({
    required super.roomId,
    required this.player1Id,
    required this.player2Id,
    required this.player1Name,
    required this.player2Name,
    required this.player1Avatar,
    required this.player2Avatar,
    required this.player1Score,
    required this.player2Score,
    required this.questionIndex,
    required this.totalQuestions,
    required this.question,
    required this.remainingSeconds,
    required this.youAnswered,
    required this.yourAnswerCorrect,
  });

  final int player1Id;
  final int player2Id;
  final String player1Name;
  final String player2Name;
  final String? player1Avatar;
  final String? player2Avatar;
  final int player1Score;
  final int player2Score;
  final int questionIndex;
  final int totalQuestions;
  final GameQuestion question;
  final int remainingSeconds;
  final bool youAnswered;
  final bool? yourAnswerCorrect;

  factory RoomStateInProgress.fromJson(Map<String, dynamic> json) {
    return RoomStateInProgress(
      roomId: json['roomId'] as int,
      player1Id: json['player1Id'] as int,
      player2Id: json['player2Id'] as int,
      player1Name: json['player1Name'] as String? ?? '',
      player2Name: json['player2Name'] as String? ?? '',
      player1Avatar: json['player1Avatar'] as String?,
      player2Avatar: json['player2Avatar'] as String?,
      player1Score: json['player1Score'] as int? ?? 0,
      player2Score: json['player2Score'] as int? ?? 0,
      questionIndex: json['questionIndex'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      question: GameQuestion.fromJson(
        json['question'] as Map<String, dynamic>,
      ),
      remainingSeconds: json['remainingSeconds'] as int? ?? 0,
      youAnswered: json['youAnswered'] as bool? ?? false,
      yourAnswerCorrect: json['yourAnswerCorrect'] as bool?,
    );
  }
}

class RoomStateFinished extends RoomState {
  const RoomStateFinished({
    required super.roomId,
    required this.player1Score,
    required this.player2Score,
    required this.winnerId,
  });

  final int player1Score;
  final int player2Score;
  final int? winnerId;

  factory RoomStateFinished.fromJson(Map<String, dynamic> json) {
    return RoomStateFinished(
      roomId: json['roomId'] as int,
      player1Score: json['player1Score'] as int? ?? 0,
      player2Score: json['player2Score'] as int? ?? 0,
      winnerId: json['winnerId'] as int?,
    );
  }
}

class RoomStateAbandoned extends RoomState {
  const RoomStateAbandoned({required super.roomId});
}
