class GameHistoryEntry {
  GameHistoryEntry({
    required this.roomId,
    required this.gameTestId,
    required this.gameTestTitle,
    required this.score,
    required this.opponentScore,
    required this.totalQuestions,
    required this.won,
    required this.draw,
    required this.vsBot,
    required this.forfeited,
    required this.opponentName,
    required this.opponentAvatar,
    required this.playedAt,
    this.ratingChange,
    this.ratingAfter,
  });

  final int roomId;
  final int gameTestId;
  final String gameTestTitle;
  final int score;
  final int opponentScore;
  final int totalQuestions;
  final bool won;
  final bool draw;
  final bool vsBot;
  final bool forfeited;
  final String opponentName;
  final String? opponentAvatar;
  final DateTime? playedAt;

  /// `null` for games played before ratings existed.
  final int? ratingChange;
  final int? ratingAfter;

  factory GameHistoryEntry.fromJson(Map<String, dynamic> json) {
    return GameHistoryEntry(
      roomId: json['roomId'] as int,
      gameTestId: json['gameTestId'] as int,
      gameTestTitle: json['gameTestTitle'] as String? ?? '',
      score: json['score'] as int? ?? 0,
      opponentScore: json['opponentScore'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      won: json['won'] as bool? ?? false,
      draw: json['draw'] as bool? ?? false,
      vsBot: json['vsBot'] as bool? ?? false,
      forfeited: json['forfeited'] as bool? ?? false,
      opponentName: json['opponentName'] as String? ?? '',
      opponentAvatar: json['opponentAvatar'] as String?,
      playedAt:
          json['playedAt'] != null
              ? DateTime.tryParse(json['playedAt'] as String)
              : null,
      ratingChange: json['ratingChange'] as int?,
      ratingAfter: json['ratingAfter'] as int?,
    );
  }
}
