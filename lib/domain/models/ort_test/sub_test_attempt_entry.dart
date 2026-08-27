import 'package:synamyk/domain/enums/attempt_status.dart';

class SubTestAttemptEntry {
  SubTestAttemptEntry({
    required this.sessionId,
    required this.status,
    required this.correctAnswers,
    required this.earnedPoints,
    required this.totalQuestions,
    required this.percentage,
    required this.startedAt,
    required this.completedAt,
  });

  final int sessionId;
  final AttemptStatus status;
  final int? correctAnswers;
  final int earnedPoints;
  final int totalQuestions;
  final int percentage;
  final DateTime startedAt;
  final DateTime? completedAt;

  bool get isCompleted => status == AttemptStatus.completed;

  factory SubTestAttemptEntry.fromJson(Map<String, dynamic> json) {
    return SubTestAttemptEntry(
      sessionId: json['sessionId'] as int,
      status: AttemptStatus.fromJson(json['status'] as String?),
      correctAnswers: json['correctAnswers'] as int?,
      earnedPoints: json['earnedPoints'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      percentage: json['percentage'] as int? ?? 0,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt:
          json['completedAt'] != null
              ? DateTime.parse(json['completedAt'] as String)
              : null,
    );
  }
}
