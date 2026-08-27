import 'package:synamyk/domain/models/ort_test/ort_sub_test_question_result.dart';

class OrtSubTestFinishResult {
  final int sessionId;
  final String subTestTitle;
  final String levelName;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int skippedAnswers;
  final int totalPoints;
  final int earnedPoints;
  final int percentage;
  final int timeTakenSeconds;
  final String motivationalMessage;
  final List<OrtSubTestQuestionResult> questionResults;

  const OrtSubTestFinishResult({
    required this.sessionId,
    required this.subTestTitle,
    required this.levelName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.skippedAnswers,
    required this.totalPoints,
    required this.earnedPoints,
    required this.percentage,
    required this.timeTakenSeconds,
    required this.motivationalMessage,
    required this.questionResults,
  });
}
