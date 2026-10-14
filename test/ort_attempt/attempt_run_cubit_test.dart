import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synamyk/data/repositories/ort_attempt/ort_attempt_repository.dart';
import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/ort_attempt/attempt_result.dart';
import 'package:synamyk/domain/models/ort_attempt/attempt_state.dart';
import 'package:synamyk/domain/models/ort_attempt/full_test.dart';
import 'package:synamyk/domain/models/ort_attempt/section_questions.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/ui/ort_attempt/bloc/attempt_run_cubit.dart';

SectionQuestions section(int index, {bool last = false, int remaining = 600, List<int> selected = const []}) {
  return SectionQuestions.fromJson({
    'attemptId': 1,
    'sectionIndex': index,
    'totalSections': 2,
    'isLastSection': last,
    'remainingSeconds': remaining,
    'passages': [],
    'questions': [
      {
        'questionId': 10,
        'index': 0,
        'number': 1,
        'text': 'Q',
        'options': [
          {'id': 100, 'label': 'А', 'text': 'a', 'orderIndex': 0},
          {'id': 101, 'label': 'Б', 'text': 'b', 'orderIndex': 1},
        ],
        'selectedOptionIds': selected,
      },
    ],
  });
}

AttemptState attemptState(String status) =>
    AttemptState.fromJson({'attemptId': 1, 'status': status, 'sections': []});

class FakeRepo implements OrtAttemptRepository {
  final sections = <SectionQuestions>[];
  Object? sectionError;
  Object? saveError;
  String finishSectionStatus = 'IN_PROGRESS';
  String stateStatus = 'IN_PROGRESS';
  final saved = <List<int>>[];
  int pauses = 0;
  Completer<void>? saveGate;

  @override
  Future<SectionQuestions> getSection(int attemptId) async {
    if (sectionError != null) throw sectionError!;
    return sections.length > 1 ? sections.removeAt(0) : sections.first;
  }

  @override
  Future<void> saveAnswer(int attemptId, {required int questionId, required List<int> optionIds}) async {
    saved.add(optionIds);
    await saveGate?.future;
    if (saveError != null) throw saveError!;
  }

  @override
  Future<AttemptState> finishSection(int attemptId) async => attemptState(finishSectionStatus);

  @override
  Future<AttemptState> getState(int attemptId) async => attemptState(stateStatus);

  @override
  Future<void> pause(int attemptId) async => pauses++;

  @override
  Future<AttemptResult> finish(int attemptId) async =>
      AttemptResult.fromJson({'attemptId': 1, 'ortScore': 120, 'sections': [], 'topics': []});

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  late FakeRepo repo;
  late AttemptRunCubit cubit;

  setUp(() {
    repo = FakeRepo();
    cubit = AttemptRunCubit(repository: repo, attemptId: 1);
  });

  tearDown(() => cubit.close());

  test('loads the section with saved answers', () async {
    repo.sections.add(section(0, selected: [101]));
    await cubit.load();
    expect(cubit.state.status, AttemptRunStatus.ready);
    expect(cubit.state.answers, {10: 101});
    expect(cubit.state.remainingSeconds, 600);
  });

  test('tapping the selected option again clears the answer', () async {
    repo.sections.add(section(0));
    await cubit.load();
    await cubit.selectOption(10, 100);
    expect(cubit.state.answers, {10: 100});
    await cubit.selectOption(10, 100);
    expect(cubit.state.answers, isEmpty);
    expect(repo.saved, [
      [100],
      <int>[],
    ]);
  });

  test('a failed save rolls back to the confirmed answer', () async {
    repo.sections.add(section(0, selected: [101]));
    await cubit.load();
    repo.saveError = AppException.server(message: 'boom');
    await cubit.selectOption(10, 100);
    expect(cubit.state.answers, {10: 101});
    expect(cubit.state.notice?.kind, AttemptNoticeKind.answerFailed);
  });

  test('finishing a middle section loads the next one', () async {
    repo.sections
      ..add(section(0))
      ..add(section(1, last: true));
    await cubit.load();
    await cubit.finishSection();
    expect(cubit.state.status, AttemptRunStatus.ready);
    expect(cubit.state.section!.sectionIndex, 1);
    expect(cubit.state.section!.isLastSection, isTrue);
  });

  test('finishing the last section completes the attempt', () async {
    repo.sections.add(section(1, last: true));
    await cubit.load();
    repo.finishSectionStatus = 'COMPLETED';
    await cubit.finishSection();
    expect(cubit.state.status, AttemptRunStatus.completed);
  });

  test('400 on section load after completion routes to the result', () async {
    repo.sectionError = AppException.validation(message: 'Тест уже завершён');
    repo.stateStatus = 'COMPLETED';
    await cubit.load();
    expect(cubit.state.status, AttemptRunStatus.completed);
  });

  test('early finish carries the result', () async {
    repo.sections.add(section(0));
    await cubit.load();
    await cubit.finishAttempt();
    expect(cubit.state.status, AttemptRunStatus.completed);
    expect(cubit.state.result?.ortScore, 120);
  });

  test('pause is sent once until resumed', () async {
    repo.sections.add(section(0));
    await cubit.load();
    await cubit.pause();
    await cubit.pause();
    expect(repo.pauses, 1);
    await cubit.resume();
    await cubit.pause();
    expect(repo.pauses, 2);
  });

  test('a resync keeps an answer whose save is still in flight', () async {
    repo.sections.add(section(0));
    await cubit.load();
    repo.saveGate = Completer();
    final pending = cubit.selectOption(10, 101);
    await cubit.resume(); // server still reports no answer
    expect(cubit.state.answers, {10: 101});
    repo.saveGate!.complete();
    await pending;
    expect(cubit.state.answers, {10: 101});
  });

  test('model parsing keeps list order and defaults', () {
    final t = FullTestListItem.fromJson({'id': 1, 'title': 'T', 'isFree': true, 'totalDurationMinutes': 215});
    expect(t.maxScore, 245);
    expect(t.isFree, isTrue);
    expect(t.resumableAttemptId, isNull);
    expect(PagedResult<int>(content: const [], totalElements: 0, number: 0, last: true).last, isTrue);
  });
}
