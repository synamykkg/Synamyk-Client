class OrtSubTestQuestionResult {
  final int questionId;
  final int index;
  final bool isCorrect;
  final bool isSkipped;
  final int pointValue;
  final List<int> selectedOptionIds;
  final List<int> correctOptionIds;

  const OrtSubTestQuestionResult({
    required this.questionId,
    required this.index,
    required this.isCorrect,
    required this.isSkipped,
    required this.pointValue,
    required this.selectedOptionIds,
    required this.correctOptionIds,
  });
}