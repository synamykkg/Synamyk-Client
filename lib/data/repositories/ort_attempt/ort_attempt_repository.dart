import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/ort_attempt/attempt_result.dart';
import 'package:synamyk/domain/models/ort_attempt/attempt_state.dart';
import 'package:synamyk/domain/models/ort_attempt/full_test.dart';
import 'package:synamyk/domain/models/ort_attempt/section_questions.dart';

/// Taking a test as one whole: sections in a row, each with its own timer,
/// scored on the ОРТ scale.
abstract class OrtAttemptRepository {
  Future<List<FullTestListItem>> getTests();

  Future<FullTestDetail> getTest(int testId);

  /// `null` when there's no unfinished attempt (204).
  Future<AttemptState?> getResumable(int testId);

  /// `restart: false` continues an unfinished attempt (or creates one);
  /// `true` abandons it and starts over.
  Future<AttemptState> start(int testId, {required bool restart});

  Future<AttemptState> getState(int attemptId);

  /// The current section with all its questions. The first call starts the
  /// section timer; an expired section is closed server-side and the next
  /// one is returned.
  Future<SectionQuestions> getSection(int attemptId);

  /// Empty [optionIds] clears the answer.
  Future<void> saveAnswer(
    int attemptId, {
    required int questionId,
    required List<int> optionIds,
  });

  Future<AttemptState> finishSection(int attemptId);

  Future<void> pause(int attemptId);

  /// Ends the whole test early.
  Future<AttemptResult> finish(int attemptId);

  Future<AttemptResult> getResult(int attemptId);

  Future<PagedResult<AttemptHistoryItem>> getHistory({
    int page = 0,
    int size = 20,
  });
}
