import 'package:flutter/material.dart';
import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart'
    hide SubTestAttemptEntry;
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/repositories/ort_tests/fake_data/fake_ort_test.dart';
import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';
import 'package:synamyk/domain/enums/attempt_status.dart';
import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/ort_test/ai_analysis_result.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_option.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_finish_result.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_question.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_question_result.dart';
import 'package:synamyk/domain/models/ort_test/sub_test_attempt_entry.dart';
import 'package:synamyk/error/api_error_parser.dart';
import 'package:synamyk/error/app_exception.dart';

class OrtTestsRepositoryImpl implements OrtTestsRepository {
  OrtTestsRepositoryImpl({required this.synamykApi});

  final SynamykApiClient synamykApi;

  @override
  Future<OrtSubTest> startOrtTest(int subTestId) async {
    final ortApi = synamykApi.auth;
    final data = await ortApi.apiSubTestsSubTestIdStartPost(
      subTestId: subTestId,
    );

    if (data.statusCode == 200) {
      try {
        final result = data.body;

        if (result == null) {
          throw AppException.unknown();
        }
        return OrtSubTest(
          sessionId: result.sessionId!,
          subTestId: result.subTestId!,
          subTestTitle: result.subTestTitle!,
          levelName: result.levelName!,
          totalQuestions: result.totalQuestions!,
          durationMinutes: result.durationMinutes!,
          expiresAt: result.expiresAt!,
          remainingSeconds: result.remainingSeconds!,
          currentIndex: result.currentIndex!,
          isResumed: result.isResumed!,
        );
      } catch (_) {
        throw AppException.unknown();
      }
    }
    debugPrint(data.statusCode.toString());
    debugPrint(data.error.toString());
    throw AppException.unknown();
  }

  @override
  Future<OrtSubTestQuestion> getOrtTest(int sessionId, String language) async {
    final ortApi = synamykApi.auth;
    final data = await ortApi.apiSessionsSessionIdQuestionGet(
      sessionId: sessionId,
    );

    if (data.statusCode == 204) {
      throw AppException.noContent();
    }

    if (data.statusCode == 200) {
      final result = data.body;

      if (result == null) {
        throw AppException.unknown();
      }

      return OrtSubTestQuestion(
        questionId: result.questionId ?? (throw AppException.unknown()),
        index: result.index ?? (throw AppException.unknown()),
        totalQuestions: result.totalQuestions ?? (throw AppException.unknown()),
        sectionName: result.sectionName ?? '',
        text: result.text ?? (throw AppException.unknown()),
        imageUrl: result.imageUrl ?? '',
        pointValue: result.pointValue ?? 0,
        remainingSeconds: result.remainingSeconds ?? 0,
        selectedOptionIds: result.selectedOptionIds ?? [],
        isSkipped: result.isSkipped ?? false,
        options:
            (result.options ?? [])
                .map(
                  (e) => OrtSubTestOption(
                    id: e.id ?? (throw AppException.unknown()),
                    label: e.label ?? (throw AppException.unknown()),
                    text: e.text ?? (throw AppException.unknown()),
                    orderIndex: e.orderIndex ?? (throw AppException.unknown()),
                  ),
                )
                .toList(),
      );
      // QuestionForSessionResponse()
    }
    throw AppException.unknown();
    // .map(
    //   (e) => OrtTest(
    //     image: "",
    //     question: e['question'],
    //     id: e["id"],
    //     options: e["options"],
    //     correctAnswer: e['correctAnswer'],
    //   ),
    // )
    // .toList();
  }

  @override
  Future<OrtSubTestQuestion> sendOrtTestAnswer(
    int sessionId, {
    required int questionId,
    required List<int> optionsId,
  }) async {
    final ortApi = synamykApi.auth;

    final data = await ortApi.apiSessionsSessionIdAnswerPost(
      sessionId: sessionId,
      body: SubmitAnswerRequest(
        questionId: questionId,
        selectedOptionIds: optionsId,
      ),
    );

    if (data.statusCode == 204) {
      throw AppException.noContent();
    }

    if (data.statusCode == 200) {
      final result = data.body;

      if (result == null) {
        throw AppException.unknown();
      }

      return OrtSubTestQuestion(
        questionId: result.questionId ?? (throw AppException.unknown()),
        index: result.index ?? (throw AppException.unknown()),
        totalQuestions: result.totalQuestions ?? (throw AppException.unknown()),
        sectionName: result.sectionName ?? '',
        text: result.text ?? (throw AppException.unknown()),
        imageUrl: result.imageUrl ?? '',
        pointValue: result.pointValue ?? 0,
        remainingSeconds: result.remainingSeconds ?? 0,
        selectedOptionIds: result.selectedOptionIds ?? [],
        isSkipped: result.isSkipped ?? false,
        options:
            (result.options ?? [])
                .map(
                  (e) => OrtSubTestOption(
                    id: e.id ?? (throw AppException.unknown()),
                    label: e.label ?? (throw AppException.unknown()),
                    text: e.text ?? (throw AppException.unknown()),
                    orderIndex: e.orderIndex ?? (throw AppException.unknown()),
                  ),
                )
                .toList(),
      );

      // QuestionForSessionResponse()
    }
    throw AppException.unknown();
  }

  @override
  Future<OrtSubTestQuestion> skipOrtTest(int sessionId) async {
    final ortApi = synamykApi.auth;

    final data = await ortApi.apiSessionsSessionIdSkipPost(
      sessionId: sessionId,
    );

    if (data.statusCode == 204) {
      throw AppException.noContent();
    }

    if (data.statusCode == 200) {
      final result = data.body;

      if (result == null) {
        throw AppException.unknown();
      }

      return OrtSubTestQuestion(
        questionId: result.questionId ?? (throw AppException.unknown()),
        index: result.index ?? (throw AppException.unknown()),
        totalQuestions: result.totalQuestions ?? (throw AppException.unknown()),
        sectionName: result.sectionName ?? '',
        text: result.text ?? (throw AppException.unknown()),
        imageUrl: result.imageUrl ?? '',
        pointValue: result.pointValue ?? 0,
        remainingSeconds: result.remainingSeconds ?? 0,
        selectedOptionIds: result.selectedOptionIds ?? [],
        isSkipped: result.isSkipped ?? false,
        options:
            (result.options ?? [])
                .map(
                  (e) => OrtSubTestOption(
                    id: e.id ?? (throw AppException.unknown()),
                    label: e.label ?? (throw AppException.unknown()),
                    text: e.text ?? (throw AppException.unknown()),
                    orderIndex: e.orderIndex ?? (throw AppException.unknown()),
                  ),
                )
                .toList(),
      );

      // QuestionForSessionResponse()
    }
    throw AppException.unknown();
  }

  @override
  Future<OrtSubTestFinishResult> finishOrtTest(int sessionId) async {
    final ortApi = synamykApi.auth;
    final data = await ortApi.apiSessionsSessionIdFinishPost(
      sessionId: sessionId,
    );

    if (data.statusCode == 200) {
      final result = data.body;
      if (result == null) throw AppException.unknown();

      return OrtSubTestFinishResult(
        sessionId: result.sessionId ?? (throw AppException.unknown()),
        subTestTitle: result.subTestTitle ?? '',
        levelName: result.levelName ?? '',
        totalQuestions: result.totalQuestions ?? 0,
        correctAnswers: result.correctAnswers ?? 0,
        wrongAnswers: result.wrongAnswers ?? 0,
        skippedAnswers: result.skippedAnswers ?? 0,
        totalPoints: result.totalPoints ?? 0,
        earnedPoints: result.earnedPoints ?? 0,
        percentage: result.percentage ?? 0,
        timeTakenSeconds: result.timeTakenSeconds ?? 0,
        motivationalMessage: result.motivationalMessage ?? '',
        questionResults:
            (result.questionResults ?? [])
                .map(
                  (e) => OrtSubTestQuestionResult(
                    questionId: e.questionId ?? (throw AppException.unknown()),
                    index: e.index ?? (throw AppException.unknown()),
                    isCorrect: e.isCorrect ?? false,
                    isSkipped: e.isSkipped ?? false,
                    pointValue: e.pointValue ?? 0,
                    selectedOptionIds:
                        (e.selectedOptionIds ?? []).map((id) => id).toList(),
                    correctOptionIds:
                        (e.correctOptionIds ?? []).map((id) => id).toList(),
                  ),
                )
                .toList(),
      );
    }
    throw AppException.unknown();
  }

  @override
  Future<bool> pauseOrtTest(int sessionId) async {
    final ortApi = synamykApi.auth;

    final data = await ortApi.apiSessionsSessionIdPausePost(
      sessionId: sessionId,
    );

    if (data.statusCode == 200) {
      final result = data.body;
      if (result == null) throw AppException.unknown();
      if (result.success ?? false) return true;
      throw AppException.unknown(result.message);
      // return result.success ? true : throw AppException.unknown('');
    }

    // return true;
    throw AppException.unknown();
  }

  Future<List<AiAnalysisResult>> getAiAnalysis(
    int sessionId,
    List<OrtSubTestQuestionResult> results,
  ) async {
    final ortApi = synamykApi.auth;
    try {
      final questionIds = results.map((r) => r.questionId).toList();
      final data = await ortApi.apiSessionsSessionIdAnalyzeErrorsPost(
        sessionId: sessionId,
        body: ErrorAnalysisRequest(questionIds: questionIds),
      );
      if (!data.isSuccessful) {
        throw ExceptionParser.parseResponse(data.statusCode, data.error);
      }

      final result = data.body;
      if (result == null) throw AppException.unknown();
      if (result.analyses == null) throw AppException.unknown();

      return result.analyses!
          .map(
            (e) => AiAnalysisResult(
              id: e.questionId!,

              question: e.questionText!,
              userAnswer: e.wrongAnswer!,
              correctAnswer: e.correctAnswer!,
              explanation: e.explanation!,
            ),
          )
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<PagedResult<SubTestAttemptEntry>> getSubTestHistory(
    int subTestId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await synamykApi.auth.apiSubTestsSubTestIdHistoryGet(
        subTestId: subTestId,
        page: page,
        size: size,
      );
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(response.statusCode, response.error);
      }
      final body = response.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      final content =
          (body.content ?? [])
              .map(
                (e) => SubTestAttemptEntry(
                  sessionId: e.sessionId ?? (throw AppException.unknown()),
                  status: AttemptStatus.fromJson(e.status),
                  correctAnswers: e.correctAnswers,
                  earnedPoints: e.earnedPoints ?? 0,
                  totalQuestions: e.totalQuestions ?? 0,
                  percentage: e.percentage ?? 0,
                  startedAt: e.startedAt ?? (throw AppException.unknown()),
                  completedAt: e.completedAt,
                ),
              )
              .toList();

      return PagedResult(
        content: content,
        totalElements: body.totalElements ?? content.length,
        number: body.number ?? page,
        last: body.last ?? true,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<OrtSubTestFinishResult> getSessionResult(int sessionId) async {
    final ortApi = synamykApi.auth;
    final data = await ortApi.apiSessionsSessionIdResultGet(
      sessionId: sessionId,
    );

    if (data.statusCode == 200) {
      final result = data.body;
      if (result == null) throw AppException.unknown();

      return OrtSubTestFinishResult(
        sessionId: result.sessionId ?? (throw AppException.unknown()),
        subTestTitle: result.subTestTitle ?? '',
        levelName: result.levelName ?? '',
        totalQuestions: result.totalQuestions ?? 0,
        correctAnswers: result.correctAnswers ?? 0,
        wrongAnswers: result.wrongAnswers ?? 0,
        skippedAnswers: result.skippedAnswers ?? 0,
        totalPoints: result.totalPoints ?? 0,
        earnedPoints: result.earnedPoints ?? 0,
        percentage: result.percentage ?? 0,
        timeTakenSeconds: result.timeTakenSeconds ?? 0,
        motivationalMessage: result.motivationalMessage ?? '',
        questionResults:
            (result.questionResults ?? [])
                .map(
                  (e) => OrtSubTestQuestionResult(
                    questionId: e.questionId ?? (throw AppException.unknown()),
                    index: e.index ?? (throw AppException.unknown()),
                    isCorrect: e.isCorrect ?? false,
                    isSkipped: e.isSkipped ?? false,
                    pointValue: e.pointValue ?? 0,
                    selectedOptionIds:
                        (e.selectedOptionIds ?? []).map((id) => id).toList(),
                    correctOptionIds:
                        (e.correctOptionIds ?? []).map((id) => id).toList(),
                  ),
                )
                .toList(),
      );
    }
    throw AppException.unknown();
  }
}

// @override
// Future<int> getDuration(String lessonId, String language) async {
//   return 60;
// }

// @override
// Future<List<OrtSubTestQuestion>> listOrtTest() {
//   return getOrtTest("lessonId", "language");
// }

// @override
// Future<void> sendDataToGpt(List results) {
//   throw UnimplementedError();
// }

// @override
// Future<List<AiAnalysisResult>> getAiAnalysis(
//   List<OrtSubTestFinishResult> results,
// ) async {
//   // Simulate API delay
//   await Future.delayed(const Duration(seconds: 2));

//   final allQuestions = fakeOrtTest;

//   return results.map((result) {
//     final questionData = allQuestions.firstWhere(
//       (q) => q['id'] == result.id,
//       orElse:
//           () => {
//             'question': 'Unknown Question',
//             'correctAnswer': 'Unknown',
//             'explanation': 'No data',
//           },
//     );

//     return AiAnalysisResult(
//       id: result.id,
//       question: questionData['question'],
//       userAnswer: result.answer,
//       correctAnswer: questionData['correctAnswer'],
//       explanation:
//           questionData['explanation'] ??
//           "Объяснение для этого вопроса генерируется ИИ...",
//     );
//   }).toList();
// }
