class GameTestModel {
  GameTestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timeLimitSeconds,
    required this.questionsPerGame,
    required this.questionCount,
    this.played = false,
    this.myBestScore,
    this.lastPlayedAt,
    this.playCount = 0,
  });

  final int id;
  final String title;
  final String description;
  final int timeLimitSeconds;
  final int questionsPerGame;
  final int questionCount;

  /// Whether the current user has already completed at least one match of this game test.
  final bool played;

  /// Best score among the user's matches of this game test; null if never played.
  final int? myBestScore;

  /// When the user last played this game test; null if never played.
  final DateTime? lastPlayedAt;

  /// How many times the user has played this game test; 0 if never played.
  final int playCount;

  factory GameTestModel.fromJson(Map<String, dynamic> json) {
    return GameTestModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      timeLimitSeconds: json['timeLimitSeconds'] as int? ?? 0,
      questionsPerGame: json['questionsPerGame'] as int? ?? 0,
      questionCount: json['questionCount'] as int? ?? 0,
      played: json['played'] as bool? ?? false,
      myBestScore: json['myBestScore'] as int?,
      lastPlayedAt:
          json['lastPlayedAt'] != null
              ? DateTime.parse(json['lastPlayedAt'] as String)
              : null,
      playCount: json['playCount'] as int? ?? 0,
    );
  }
}
