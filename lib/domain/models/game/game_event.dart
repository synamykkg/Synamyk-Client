import 'package:synamyk/domain/models/game/game_question.dart';

/// Real-time events pushed over the `/topic/game/{roomId}` and
/// `/topic/game/{roomId}/answers/{userId}` STOMP topics.
sealed class GameEvent {
  const GameEvent({required this.roomId});

  final int roomId;

  static GameEvent? fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      'GAME_STARTED' => GameStartedEvent.fromJson(json),
      'NEXT_QUESTION' => NextQuestionEvent.fromJson(json),
      'ANSWER_RESULT' => AnswerResultEvent.fromJson(json),
      'GAME_OVER' => GameOverEvent.fromJson(json),
      _ => null,
    };
  }
}

class GameStartedEvent extends GameEvent {
  const GameStartedEvent({
    required super.roomId,
    required this.player1Id,
    required this.player2Id,
    required this.player1Name,
    required this.player2Name,
    required this.player1Avatar,
    required this.player2Avatar,
    required this.player1Score,
    required this.player2Score,
  });

  final int player1Id;
  final int player2Id;
  final String player1Name;
  final String player2Name;
  final String? player1Avatar;
  final String? player2Avatar;
  final int player1Score;
  final int player2Score;

  bool get opponentIsBot => player2Id == -1;

  factory GameStartedEvent.fromJson(Map<String, dynamic> json) {
    return GameStartedEvent(
      roomId: json['roomId'] as int,
      player1Id: json['player1Id'] as int,
      player2Id: json['player2Id'] as int,
      player1Name: json['player1Name'] as String? ?? '',
      player2Name: json['player2Name'] as String? ?? '',
      player1Avatar: json['player1Avatar'] as String?,
      player2Avatar: json['player2Avatar'] as String?,
      player1Score: json['player1Score'] as int? ?? 0,
      player2Score: json['player2Score'] as int? ?? 0,
    );
  }
}

class NextQuestionEvent extends GameEvent {
  const NextQuestionEvent({
    required super.roomId,
    required this.questionIndex,
    required this.totalQuestions,
    required this.timeLimitSeconds,
    required this.question,
    required this.player1Score,
    required this.player2Score,
  });

  final int questionIndex;
  final int totalQuestions;
  final int timeLimitSeconds;
  final GameQuestion question;
  final int player1Score;
  final int player2Score;

  factory NextQuestionEvent.fromJson(Map<String, dynamic> json) {
    return NextQuestionEvent(
      roomId: json['roomId'] as int,
      questionIndex: json['questionIndex'] as int,
      totalQuestions: json['totalQuestions'] as int,
      timeLimitSeconds: json['timeLimitSeconds'] as int,
      question: GameQuestion.fromJson(
        json['question'] as Map<String, dynamic>,
      ),
      player1Score: json['player1Score'] as int? ?? 0,
      player2Score: json['player2Score'] as int? ?? 0,
    );
  }
}

class AnswerResultEvent extends GameEvent {
  const AnswerResultEvent({
    required super.roomId,
    required this.correct,
    required this.player1Score,
    required this.player2Score,
  });

  final bool correct;
  final int player1Score;
  final int player2Score;

  factory AnswerResultEvent.fromJson(Map<String, dynamic> json) {
    return AnswerResultEvent(
      roomId: json['roomId'] as int,
      correct: json['correct'] as bool? ?? false,
      player1Score: json['player1Score'] as int? ?? 0,
      player2Score: json['player2Score'] as int? ?? 0,
    );
  }
}

class GameOverEvent extends GameEvent {
  const GameOverEvent({
    required super.roomId,
    required this.player1Score,
    required this.player2Score,
    required this.winnerId,
    this.forfeitedBy,
  });

  final int player1Score;
  final int player2Score;

  /// `null` means a draw.
  final int? winnerId;

  /// Id of the player who forfeited, if the game ended that way.
  final int? forfeitedBy;

  factory GameOverEvent.fromJson(Map<String, dynamic> json) {
    return GameOverEvent(
      roomId: json['roomId'] as int,
      player1Score: json['player1Score'] as int? ?? 0,
      player2Score: json['player2Score'] as int? ?? 0,
      winnerId: json['winnerId'] as int?,
      forfeitedBy: json['forfeitedBy'] as int?,
    );
  }
}
