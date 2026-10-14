import 'package:synamyk/domain/models/common/json_read.dart';
import 'package:synamyk/domain/models/figure/figure.dart';

class AttemptOption {
  const AttemptOption({
    required this.id,
    required this.label,
    required this.text,
    required this.orderIndex,
  });

  final int id;
  final String label;
  final String text;
  final int orderIndex;

  factory AttemptOption.fromJson(Map<String, dynamic> json) {
    return AttemptOption(
      id: readIntOr(json['id']),
      label: readStringOr(json['label']),
      text: readStringOr(json['text']),
      orderIndex: readIntOr(json['orderIndex']),
    );
  }
}

class AttemptQuestion {
  const AttemptQuestion({
    required this.questionId,
    required this.index,
    required this.number,
    required this.passageId,
    required this.isComparison,
    required this.text,
    required this.columnA,
    required this.columnB,
    required this.imageUrl,
    required this.figure,
    required this.options,
    required this.selectedOptionIds,
  });

  final int questionId;
  final int index;
  final int number;
  final int? passageId;

  /// `questionType == COMPARISON` — «Колонка А / Колонка Б».
  final bool isComparison;
  final String text;
  final String? columnA;
  final String? columnB;
  final String? imageUrl;
  final Figure? figure;
  final List<AttemptOption> options;
  final List<int> selectedOptionIds;

  factory AttemptQuestion.fromJson(Map<String, dynamic> json) {
    final index = readIntOr(json['index']);
    return AttemptQuestion(
      questionId: readIntOr(json['questionId']),
      index: index,
      number: readIntOr(json['number'], index + 1),
      passageId: readInt(json['passageId']),
      isComparison: json['questionType'] == 'COMPARISON',
      text: readStringOr(json['text']),
      columnA: readString(json['columnA']),
      columnB: readString(json['columnB']),
      imageUrl: readString(json['imageUrl']),
      figure: Figure.tryParse(json['figure']),
      options: readMapList(json['options']).map(AttemptOption.fromJson).toList()
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex)),
      selectedOptionIds: readIntList(json['selectedOptionIds']),
    );
  }
}

class ReadingPassage {
  const ReadingPassage({
    required this.id,
    required this.number,
    required this.title,
    required this.text,
    required this.imageUrl,
    required this.questionIds,
  });

  final int id;
  final int number;
  final String? title;
  final String text;
  final String? imageUrl;
  final List<int> questionIds;

  factory ReadingPassage.fromJson(Map<String, dynamic> json) {
    return ReadingPassage(
      id: readIntOr(json['id']),
      number: readIntOr(json['number'], 1),
      title: readString(json['title']),
      text: readStringOr(json['text']),
      imageUrl: readString(json['imageUrl']),
      questionIds: readIntList(json['questionIds']),
    );
  }
}

/// `SectionQuestionsResponse` — the current section with all its questions.
class SectionQuestions {
  const SectionQuestions({
    required this.attemptId,
    required this.sessionId,
    required this.sectionIndex,
    required this.totalSections,
    required this.isLastSection,
    required this.subTestId,
    required this.title,
    required this.remainingSeconds,
    required this.totalQuestions,
    required this.passages,
    required this.questions,
  });

  final int attemptId;
  final int? sessionId;
  final int sectionIndex;
  final int totalSections;
  final bool isLastSection;
  final int subTestId;
  final String title;
  final int remainingSeconds;
  final int totalQuestions;
  final List<ReadingPassage> passages;
  final List<AttemptQuestion> questions;

  factory SectionQuestions.fromJson(Map<String, dynamic> json) {
    final questions =
        readMapList(json['questions']).map(AttemptQuestion.fromJson).toList()
          ..sort((a, b) => a.index.compareTo(b.index));
    return SectionQuestions(
      attemptId: readIntOr(json['attemptId']),
      sessionId: readInt(json['sessionId']),
      sectionIndex: readIntOr(json['sectionIndex']),
      totalSections: readIntOr(json['totalSections'], 1),
      isLastSection: readBool(json['isLastSection']),
      subTestId: readIntOr(json['subTestId']),
      title: readStringOr(json['title']),
      remainingSeconds: readIntOr(json['remainingSeconds']),
      totalQuestions: readIntOr(json['totalQuestions'], questions.length),
      passages: readMapList(
        json['passages'],
      ).map(ReadingPassage.fromJson).toList(),
      questions: questions,
    );
  }
}
