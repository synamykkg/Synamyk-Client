import 'package:synamyk/domain/enums/attempt_status.dart';
import 'package:synamyk/domain/models/common/json_read.dart';

export 'package:synamyk/domain/enums/attempt_status.dart';

class AttemptSectionState {
  const AttemptSectionState({
    required this.index,
    required this.subTestId,
    required this.title,
    required this.iconUrl,
    required this.durationMinutes,
    required this.questionCount,
    required this.status,
    required this.answeredCount,
    required this.remainingSeconds,
  });

  final int index;
  final int subTestId;
  final String title;
  final String? iconUrl;
  final int durationMinutes;
  final int questionCount;

  /// `NOT_STARTED | IN_PROGRESS | PAUSED | COMPLETED | EXPIRED`.
  final String status;
  final int answeredCount;
  final int remainingSeconds;

  factory AttemptSectionState.fromJson(Map<String, dynamic> json) {
    return AttemptSectionState(
      index: readIntOr(json['index']),
      subTestId: readIntOr(json['subTestId']),
      title: readStringOr(json['title']),
      iconUrl: readString(json['iconUrl']),
      durationMinutes: readIntOr(json['durationMinutes']),
      questionCount: readIntOr(json['questionCount']),
      status: readStringOr(json['status']),
      answeredCount: readIntOr(json['answeredCount']),
      remainingSeconds: readIntOr(json['remainingSeconds']),
    );
  }
}

/// `AttemptStateResponse`.
class AttemptState {
  const AttemptState({
    required this.attemptId,
    required this.testId,
    required this.testTitle,
    required this.status,
    required this.isResumed,
    required this.totalDurationMinutes,
    required this.totalQuestions,
    required this.maxScore,
    required this.currentSectionIndex,
    required this.totalSections,
    required this.totalRemainingSeconds,
    required this.sections,
  });

  final int attemptId;
  final int testId;
  final String testTitle;
  final AttemptStatus status;
  final bool isResumed;
  final int totalDurationMinutes;
  final int totalQuestions;
  final int maxScore;
  final int currentSectionIndex;
  final int totalSections;
  final int totalRemainingSeconds;
  final List<AttemptSectionState> sections;

  factory AttemptState.fromJson(Map<String, dynamic> json) {
    return AttemptState(
      attemptId: readIntOr(json['attemptId']),
      testId: readIntOr(json['testId']),
      testTitle: readStringOr(json['testTitle']),
      status: AttemptStatus.fromJson(readString(json['status'])),
      isResumed: readBool(json['isResumed']),
      totalDurationMinutes: readIntOr(json['totalDurationMinutes']),
      totalQuestions: readIntOr(json['totalQuestions']),
      maxScore: readIntOr(json['maxScore'], 245),
      currentSectionIndex: readIntOr(json['currentSectionIndex']),
      totalSections: readIntOr(json['totalSections']),
      totalRemainingSeconds: readIntOr(json['totalRemainingSeconds']),
      sections: readMapList(
        json['sections'],
      ).map(AttemptSectionState.fromJson).toList(),
    );
  }
}
