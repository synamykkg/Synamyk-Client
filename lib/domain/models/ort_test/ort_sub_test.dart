class OrtSubTest {
  final int sessionId;
  final int subTestId;
  final String subTestTitle;
  final String levelName;
  final int totalQuestions;
  final int durationMinutes;
  final DateTime expiresAt;
  final int remainingSeconds;
  final int currentIndex;
  final bool isResumed;

  OrtSubTest({
    required this.sessionId,
    required this.subTestId,
    required this.subTestTitle,
    required this.levelName,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.expiresAt,
    required this.remainingSeconds,
    required this.currentIndex,
    required this.isResumed,
  });

  factory OrtSubTest.fromJson(Map<String, dynamic> json) {
    return OrtSubTest(
      sessionId: json['sessionId'],
      subTestId: json['subTestId'],
      subTestTitle: json['subTestTitle'],
      levelName: json['levelName'],
      totalQuestions: json['totalQuestions'],
      durationMinutes: json['durationMinutes'],
      expiresAt: DateTime.parse(json['expiresAt']),
      remainingSeconds: json['remainingSeconds'],
      currentIndex: json['currentIndex'],
      isResumed: json['isResumed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'subTestId': subTestId,
      'subTestTitle': subTestTitle,
      'levelName': levelName,
      'totalQuestions': totalQuestions,
      'durationMinutes': durationMinutes,
      'expiresAt': expiresAt.toIso8601String(),
      'remainingSeconds': remainingSeconds,
      'currentIndex': currentIndex,
      'isResumed': isResumed,
    };
  }
}
