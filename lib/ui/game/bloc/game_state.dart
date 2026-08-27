part of 'game_bloc.dart';

sealed class GameBlocState extends Equatable {
  const GameBlocState();

  @override
  List<Object?> get props => [];
}

class GameIdle extends GameBlocState {
  const GameIdle();
}

class GameJoining extends GameBlocState {
  const GameJoining();
}

class GameWaitingForOpponent extends GameBlocState {
  const GameWaitingForOpponent({required this.roomId, required this.message});

  final int roomId;
  final String message;

  @override
  List<Object?> get props => [roomId, message];
}

class GameInProgress extends GameBlocState {
  const GameInProgress({
    required this.roomId,
    required this.myName,
    required this.opponentName,
    required this.opponentAvatar,
    required this.opponentIsBot,
    required this.myScore,
    required this.opponentScore,
    required this.question,
    required this.questionIndex,
    required this.totalQuestions,
    required this.timeLimitSeconds,
    required this.questionStartedAt,
    this.selectedOptionId,
    this.lastAnswerCorrect,
  });

  final int roomId;
  final String myName;
  final String opponentName;
  final String? opponentAvatar;
  final bool opponentIsBot;
  final int myScore;
  final int opponentScore;
  final GameQuestion question;
  final int questionIndex;
  final int totalQuestions;
  final int timeLimitSeconds;

  /// Local timestamp used to derive the countdown shown on screen.
  final DateTime questionStartedAt;

  /// The option the player picked for the *current* question, if any.
  final int? selectedOptionId;

  /// Whether that pick was correct, once `ANSWER_RESULT` arrives.
  final bool? lastAnswerCorrect;

  GameInProgress copyWith({
    int? myScore,
    int? opponentScore,
    GameQuestion? question,
    int? questionIndex,
    int? totalQuestions,
    int? timeLimitSeconds,
    DateTime? questionStartedAt,
    int? selectedOptionId,
    bool clearSelection = false,
    bool? lastAnswerCorrect,
    bool clearAnswerCorrect = false,
  }) {
    return GameInProgress(
      roomId: roomId,
      myName: myName,
      opponentName: opponentName,
      opponentAvatar: opponentAvatar,
      opponentIsBot: opponentIsBot,
      myScore: myScore ?? this.myScore,
      opponentScore: opponentScore ?? this.opponentScore,
      question: question ?? this.question,
      questionIndex: questionIndex ?? this.questionIndex,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
      questionStartedAt: questionStartedAt ?? this.questionStartedAt,
      selectedOptionId:
          clearSelection ? null : (selectedOptionId ?? this.selectedOptionId),
      lastAnswerCorrect:
          clearAnswerCorrect
              ? null
              : (lastAnswerCorrect ?? this.lastAnswerCorrect),
    );
  }

  @override
  List<Object?> get props => [
    roomId,
    myScore,
    opponentScore,
    question.id,
    questionIndex,
    selectedOptionId,
    lastAnswerCorrect,
  ];
}

class GameFinished extends GameBlocState {
  const GameFinished({
    required this.myScore,
    required this.opponentScore,
    required this.won,
    required this.draw,
    this.forfeitedByMe = false,
    this.forfeitedByOpponent = false,
  });

  final int myScore;
  final int opponentScore;
  final bool won;
  final bool draw;

  /// True if the current user forfeited the match.
  final bool forfeitedByMe;

  /// True if the opponent forfeited the match.
  final bool forfeitedByOpponent;

  @override
  List<Object?> get props => [
    myScore,
    opponentScore,
    won,
    draw,
    forfeitedByMe,
    forfeitedByOpponent,
  ];
}

class GameFailure extends GameBlocState {
  const GameFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
