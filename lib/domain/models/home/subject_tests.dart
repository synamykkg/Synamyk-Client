class SubjectTests {
  SubjectTests({
    required this.id,
    required this.level,
    required this.isFree,
    required this.title,
    required this.image,
    required this.minutes,
    required this.questions,
    this.hasAccess = true,
    this.hasCompleted = false,
    this.bestScore,
    this.bestSessionId,
    this.attemptsCount = 0,
  });

  final String id;
  final String level;
  final bool isFree;
  final String title;
  final String image;
  final int minutes;
  final int questions;

  /// Whether the current user can open this sub-test right now
  /// (free sub-tests are always accessible; paid ones only after purchase).
  final bool hasAccess;

  /// Whether the current user has already completed this sub-test.
  final bool hasCompleted;

  /// Best `earnedPoints` among the user's COMPLETED attempts; `null` if none.
  final int? bestScore;

  /// sessionId of the best-scoring attempt; `null` if none.
  final int? bestSessionId;

  /// Total attempts of any status.
  final int attemptsCount;

  factory SubjectTests.fromJson(Map<String, dynamic> json) {
    return SubjectTests(
      id: json['id'] as String,
      level: json['level'] as String,
      isFree: json['isFree'] as bool,
      title: json['title'] as String,
      image: json['image'] as String,
      minutes: json['minutes'] as int,
      questions: json['questions'] as int,
    );
  }

}
