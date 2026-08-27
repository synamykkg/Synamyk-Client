import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/ort_test/ai_analysis_result.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_finish_result.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_question.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_question_result.dart';
import 'package:synamyk/domain/models/ort_test/sub_test_attempt_entry.dart';

abstract class OrtTestsRepository {
  Future<OrtSubTest> startOrtTest(int subTestId);

  Future<OrtSubTestQuestion> getOrtTest(int lessonId, String language);

  Future<OrtSubTestQuestion> sendOrtTestAnswer(
    int sessionId, {
    required int questionId,
    required List<int> optionsId,
  });

  Future<OrtSubTestQuestion> skipOrtTest(int sessionId);

  Future<OrtSubTestFinishResult> finishOrtTest(int sessionId);

  Future<bool> pauseOrtTest(int sessionId);

  // Future<int> getDuration(String lessonId, String language);

  // Future<List<OrtSubTestQuestion>> listOrtTest();

  Future<List<AiAnalysisResult>> getAiAnalysis(
    int sessionId,
    List<OrtSubTestQuestionResult> results,
  );

  // Future<void> sendDataToGpt(List results);

  /// История попыток по подтесту, от новых к старым (включая незавершённые).
  Future<PagedResult<SubTestAttemptEntry>> getSubTestHistory(
    int subTestId, {
    int page = 0,
    int size = 20,
  });

  /// Результат уже завершённой сессии — для повторного просмотра без
  /// повторного вызова [finishOrtTest].
  Future<OrtSubTestFinishResult> getSessionResult(int sessionId);
}
