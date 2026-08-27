import 'package:synamyk/domain/models/ort_test/ort_sub_test_option.dart';

class OrtSubTestQuestion {
  OrtSubTestQuestion({
    required this.questionId,
    required this.index,
    required this.totalQuestions,
    required this.sectionName,
    required this.text,
    required this.imageUrl,
    required this.pointValue,
    required this.options,
    required this.remainingSeconds,
    required this.selectedOptionIds,
    required this.isSkipped,
  });

  final int questionId;
  final int index;
  final int totalQuestions;
  final String sectionName;
  final String text;
  final String imageUrl;
  final int pointValue;
  final List<OrtSubTestOption> options;
  final int remainingSeconds;
  final List<int> selectedOptionIds;
  final bool isSkipped;

  factory OrtSubTestQuestion.fromJson(Map<String, dynamic> json) {
    return OrtSubTestQuestion(
      questionId: json['questionId'] as int,
      index: json['index'] as int,
      totalQuestions: json['totalQuestions'] as int,
      sectionName: json['sectionName'] as String,
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String,
      pointValue: json['pointValue'] as int,
      options:
          (json['options'] as List<dynamic>)
              .map((e) => OrtSubTestOption.fromJson(e as Map<String, dynamic>))
              .toList(),
      remainingSeconds: json['remainingSeconds'] as int,
      selectedOptionIds:
          (json['selectedOptionIds'] as List<dynamic>)
              .map((e) => e as int)
              .toList(),
      isSkipped: json['isSkipped'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'index': index,
      'totalQuestions': totalQuestions,
      'sectionName': sectionName,
      'text': text,
      'imageUrl': imageUrl,
      'pointValue': pointValue,
      'options': options.map((e) => e.toJson()).toList(),
      'remainingSeconds': remainingSeconds,
      'selectedOptionIds': selectedOptionIds,
      'isSkipped': isSkipped,
    };
  }
}

// class OrtSubTestQuestion {
//   OrtSubTestQuestion({
//     required this.questionId,
//     required this.index,
//     required this.image,
//     required this.question,
//     required this.options,
//     required this.correctAnswer,
//   });

//   final String id;
//   final String question;
//   final String image;
//   // final List<OrtTestOption> options;
//   final List<OrtSubTestOption> options;
//   final String correctAnswer;
// }
