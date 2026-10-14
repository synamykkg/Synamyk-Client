import 'package:synamyk/domain/models/common/json_read.dart';

class SectionResult {
  const SectionResult({
    required this.subTestId,
    required this.title,
    required this.sessionId,
    required this.status,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.percentage,
    required this.ortScore,
    required this.maxScore,
  });

  final int subTestId;
  final String title;
  final int? sessionId;

  /// `COMPLETED | EXPIRED | NOT_STARTED`.
  final String status;
  final int totalQuestions;
  final int correctAnswers;
  final double percentage;
  final int? ortScore;
  final int? maxScore;

  factory SectionResult.fromJson(Map<String, dynamic> json) {
    return SectionResult(
      subTestId: readIntOr(json['subTestId']),
      title: readStringOr(json['title']),
      sessionId: readInt(json['sessionId']),
      status: readStringOr(json['status']),
      totalQuestions: readIntOr(json['totalQuestions']),
      correctAnswers: readIntOr(json['correctAnswers']),
      percentage: readDoubleOr(json['percentage']),
      ortScore: readInt(json['ortScore']),
      maxScore: readInt(json['maxScore']),
    );
  }
}

class TopicResult {
  const TopicResult({
    required this.topic,
    required this.sectionTitle,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.percentage,
  });

  final String topic;
  final String sectionTitle;
  final int totalQuestions;
  final int correctAnswers;
  final double percentage;

  factory TopicResult.fromJson(Map<String, dynamic> json) {
    return TopicResult(
      topic: readStringOr(json['topic']),
      sectionTitle: readStringOr(json['sectionTitle']),
      totalQuestions: readIntOr(json['totalQuestions']),
      correctAnswers: readIntOr(json['correctAnswers']),
      percentage: readDoubleOr(json['percentage']),
    );
  }
}

/// `AttemptResultResponse`.
class AttemptResult {
  const AttemptResult({
    required this.attemptId,
    required this.testId,
    required this.testTitle,
    required this.userFullName,
    required this.completedAt,
    required this.ortScore,
    required this.maxScore,
    required this.thresholdScore,
    required this.passedThreshold,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.skippedAnswers,
    required this.percentage,
    required this.timeTakenSeconds,
    required this.motivationalMessage,
    required this.sections,
    required this.topics,
  });

  final int attemptId;
  final int testId;
  final String testTitle;
  final String userFullName;
  final DateTime? completedAt;
  final int ortScore;
  final int maxScore;
  final int thresholdScore;
  final bool passedThreshold;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int skippedAnswers;
  final double percentage;
  final int timeTakenSeconds;
  final String? motivationalMessage;
  final List<SectionResult> sections;
  final List<TopicResult> topics;

  factory AttemptResult.fromJson(Map<String, dynamic> json) {
    return AttemptResult(
      attemptId: readIntOr(json['attemptId']),
      testId: readIntOr(json['testId']),
      testTitle: readStringOr(json['testTitle']),
      userFullName: readStringOr(json['userFullName']),
      completedAt: readDate(json['completedAt']),
      ortScore: readIntOr(json['ortScore']),
      maxScore: readIntOr(json['maxScore'], 245),
      thresholdScore: readIntOr(json['thresholdScore']),
      passedThreshold: readBool(json['passedThreshold']),
      totalQuestions: readIntOr(json['totalQuestions']),
      correctAnswers: readIntOr(json['correctAnswers']),
      wrongAnswers: readIntOr(json['wrongAnswers']),
      skippedAnswers: readIntOr(json['skippedAnswers']),
      percentage: readDoubleOr(json['percentage']),
      timeTakenSeconds: readIntOr(json['timeTakenSeconds']),
      motivationalMessage: readString(json['motivationalMessage']),
      sections: readMapList(
        json['sections'],
      ).map(SectionResult.fromJson).toList(),
      topics: readMapList(json['topics']).map(TopicResult.fromJson).toList(),
    );
  }
}

/// One row of «Жыйынтык» (`GET /api/attempts/history`).
class AttemptHistoryItem {
  const AttemptHistoryItem({
    required this.attemptId,
    required this.testId,
    required this.testTitle,
    required this.ortScore,
    required this.maxScore,
    required this.percentage,
    required this.completedAt,
  });

  final int attemptId;
  final int testId;
  final String testTitle;
  final int? ortScore;
  final int maxScore;
  final double percentage;
  final DateTime? completedAt;

  factory AttemptHistoryItem.fromJson(Map<String, dynamic> json) {
    return AttemptHistoryItem(
      attemptId: readIntOr(json['attemptId']),
      testId: readIntOr(json['testId']),
      testTitle: readStringOr(json['testTitle']),
      ortScore: readInt(json['ortScore']),
      maxScore: readIntOr(json['maxScore'], 245),
      percentage: readDoubleOr(json['percentage']),
      completedAt: readDate(json['completedAt']) ?? readDate(json['startedAt']),
    );
  }
}
