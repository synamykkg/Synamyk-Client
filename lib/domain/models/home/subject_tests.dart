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
    this.price = 0,
    this.effectiveFree = false,
    this.freeUntil,
  });

  final String id;
  final String level;
  final bool isFree;
  final String title;
  final String image;
  final int minutes;
  final int questions;

  /// Whether the current user can open this sub-test right now — the
  /// single source of truth for gating "Начать" (already accounts for
  /// free sub-tests, purchases, bundle purchases, admin grants, and any
  /// active free-window). Never re-derive this from [isFree]/[price].
  final bool hasAccess;

  /// Whether the current user has already completed this sub-test.
  final bool hasCompleted;

  /// Best `earnedPoints` among the user's COMPLETED attempts; `null` if none.
  final int? bestScore;

  /// sessionId of the best-scoring attempt; `null` if none.
  final int? bestSessionId;

  /// Total attempts of any status.
  final int attemptsCount;

  /// Price to unlock just this sub-test (independent of the bundle price).
  final double price;

  /// Whether a free-access window is active for this sub-test right now.
  final bool effectiveFree;

  /// When the active free-window ends; local time (Asia/Bishkek), no
  /// timezone conversion. `null` if not currently free, or free with no end.
  final DateTime? freeUntil;

  factory SubjectTests.fromJson(Map<String, dynamic> json) {
    return SubjectTests(
      id: json['id'] as String,
      level: json['level'] as String,
      isFree: json['isFree'] as bool,
      title: json['title'] as String,
      image: json['image'] as String,
      minutes: json['minutes'] as int,
      questions: json['questions'] as int,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      effectiveFree: json['effectiveFree'] as bool? ?? false,
      freeUntil:
          json['freeUntil'] != null
              ? DateTime.parse(json['freeUntil'] as String)
              : null,
    );
  }

}
