class AiAnalysisResult {
  final int id;
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final String explanation;

  AiAnalysisResult({
    required this.id,
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.explanation,
  });
}
