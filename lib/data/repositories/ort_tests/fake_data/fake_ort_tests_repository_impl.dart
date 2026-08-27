// import 'package:dio/dio.dart';
// import 'package:synamyk/data/repositories/ort_tests/fake_data/fake_ort_test.dart';
// import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';
// import 'package:synamyk/domain/models/ort_test/ai_analysis_result.dart';
// import 'package:synamyk/domain/models/ort_test/ort_sub_test_result.dart';
// import 'package:synamyk/domain/models/ort_test/ort_sub_test_question.dart';
// import 'package:synamyk/domain/models/ort_test/ort_sub_test_option.dart';

// class FakeOrtTestsRepositoryImpl implements OrtTestsRepository {
//   @override
//   Future<List<OrtSubTestQuestion>> getOrtTest(
//     String lessonId,
//     String language,
//   ) async {
//     // final response = fakeOrtTest;
//     final dataLang = subjectsTests[language];
//     final data = dataLang[lessonId] as List<Map<String, dynamic>>;

//     // for (var element in data) {}

//     return data.map((e) {
//       final dataOptions = e["options"] as List<Map<String, String>>;
//       final dataOption =
//           dataOptions
//               .map(
//                 (option) => OrtSubTestOption(
//                   variant: option["variant"] as String,
//                   optionsAnswer: option["optionsAnswer"] as String,
//                 ),
//               )
//               .toList();
//       return OrtSubTestQuestion(
//         image: e['image'],
//         question: e['question'],
//         id: e["id"],
//         options: dataOption,
//         correctAnswer: e['correctAnswer'],
//       );
//     }).toList();
//   }

//   @override
//   Future<int> getDuration(String lessonId, String language) async {
//     return 600;
//   }

//   @override
//   Future<List<OrtSubTestQuestion>> listOrtTest() {
//     return getOrtTest("eng_test_1", "language");
//   }

//   @override
//   Future<void> sendDataToGpt(List results) {
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<AiAnalysisResult>> getAiAnalysis(
//     List<OrtSubTestResult> results,
//   ) async {
//     await Future.delayed(const Duration(seconds: 2));

//     // Flatten all tests from all languages for simulation
//     final allTests = <Map<String, dynamic>>[];
//     subjectsTests.forEach((lang, testsMap) {
//       testsMap.forEach((testId, questions) {
//         allTests.addAll(questions as List<Map<String, dynamic>>);
//       });
//     });

//     return results.map((result) {
//       final questionData = allTests.firstWhere(
//         (q) => q['id'] == result.id,
//         orElse:
//             () => {
//               'question': 'Unknown Question',
//               'correctAnswer': 'Unknown',
//               'explanation': 'No data',
//             },
//       );

//       return AiAnalysisResult(
//         id: result.id,
//         question: questionData['question'],
//         userAnswer: result.answer,
//         correctAnswer: questionData['correctAnswer'],
//         explanation:
//             "This is a simulated AI explanation for question ${result.id}. The correct answer is '${questionData['correctAnswer']}' because logical reasoning.",
//       );
//     }).toList();
//   }
// }
