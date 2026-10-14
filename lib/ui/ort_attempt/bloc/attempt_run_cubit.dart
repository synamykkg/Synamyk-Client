import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/ort_attempt/ort_attempt_repository.dart';
import 'package:synamyk/domain/models/ort_attempt/attempt_result.dart';
import 'package:synamyk/domain/models/ort_attempt/attempt_state.dart';
import 'package:synamyk/domain/models/ort_attempt/section_questions.dart';
import 'package:synamyk/error/app_exception.dart';

enum AttemptRunStatus { loading, ready, busy, completed, failed }

/// A one-off notice for the UI (snackbar); [id] makes repeats distinct.
class AttemptRunNotice {
  const AttemptRunNotice(this.id, this.kind, [this.error]);

  final int id;
  final AttemptNoticeKind kind;
  final Object? error;
}

enum AttemptNoticeKind { sectionTimeUp, answerFailed }

class AttemptRunState {
  const AttemptRunState({
    this.status = AttemptRunStatus.loading,
    this.section,
    this.answers = const {},
    this.remainingSeconds = 0,
    this.error,
    this.result,
    this.notice,
  });

  final AttemptRunStatus status;
  final SectionQuestions? section;

  /// questionId → selected option id (ОРТ questions are single-choice).
  final Map<int, int> answers;
  final int remainingSeconds;
  final Object? error;

  /// Set when [status] is [AttemptRunStatus.completed] via early finish;
  /// `null` means "fetch it on the result screen".
  final AttemptResult? result;
  final AttemptRunNotice? notice;

  int get answeredCount => answers.length;

  AttemptRunState copyWith({
    AttemptRunStatus? status,
    SectionQuestions? section,
    Map<int, int>? answers,
    int? remainingSeconds,
    Object? error,
    AttemptResult? result,
    AttemptRunNotice? notice,
  }) {
    return AttemptRunState(
      status: status ?? this.status,
      section: section ?? this.section,
      answers: answers ?? this.answers,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      error: error ?? this.error,
      result: result ?? this.result,
      notice: notice ?? this.notice,
    );
  }
}

/// Drives one section screen of a whole-test attempt: local countdown with
/// periodic server resync, optimistic answers, pause/resume, section and
/// test completion.
class AttemptRunCubit extends Cubit<AttemptRunState> {
  AttemptRunCubit({
    required OrtAttemptRepository repository,
    required this.attemptId,
  }) : _repo = repository,
       super(const AttemptRunState());

  final OrtAttemptRepository _repo;
  final int attemptId;

  static const _resyncEvery = Duration(seconds: 60);

  Timer? _ticker;
  DateTime _deadline = DateTime.now();
  DateTime _lastSync = DateTime.now();
  Future<void>? _inFlight;
  bool _paused = false;
  int _noticeSeq = 0;

  /// Answers the server has confirmed, to roll back a failed optimistic tap.
  final Map<int, int> _confirmed = {};

  /// Latest request number per question — only the newest response may
  /// roll a question back.
  final Map<int, int> _answerSeq = {};

  Future<void> load() => _loadSection(showLoading: true);

  /// Serializes section fetches. A caller that must see fresh data (after
  /// finishing a section) waits for an in-flight resync and then fetches
  /// again; background resyncs just piggyback on the in-flight one.
  Future<void> _loadSection({bool showLoading = false}) async {
    while (_inFlight != null) {
      await _inFlight;
      if (!showLoading) return;
    }
    final future = _fetchSection(showLoading);
    _inFlight = future;
    try {
      await future;
    } finally {
      _inFlight = null;
    }
  }

  Future<void> _fetchSection(bool showLoading) async {
    if (showLoading) {
      emit(
        AttemptRunState(
          status: AttemptRunStatus.loading,
          section: state.section,
        ),
      );
    }
    try {
      final section = await _repo.getSection(attemptId);
      if (isClosed) return;
      _applySection(section);
    } on AppException catch (e) {
      if (isClosed) return;
      // 400 «Тест уже завершён» after the last section's timer ran out.
      if (e.type == ExceptionType.validation && await _isCompleted()) {
        _complete();
      } else if (state.section == null || showLoading) {
        emit(state.copyWith(status: AttemptRunStatus.failed, error: e));
      }
    } catch (e) {
      if (isClosed) return;
      if (state.section == null || showLoading) {
        emit(state.copyWith(status: AttemptRunStatus.failed, error: e));
      }
    }
  }

  void _applySection(SectionQuestions section) {
    final sameSection =
        state.section?.sectionIndex == section.sectionIndex &&
        state.status != AttemptRunStatus.loading;

    final serverAnswers = <int, int>{
      for (final q in section.questions)
        if (q.selectedOptionIds.isNotEmpty)
          q.questionId: q.selectedOptionIds.first,
    };
    if (!sameSection) _answerSeq.clear();
    _confirmed
      ..clear()
      ..addAll(serverAnswers);

    // Keep taps whose save is still in flight instead of flickering back.
    final answers = Map.of(serverAnswers);
    if (sameSection) {
      for (final qid in _answerSeq.keys) {
        final local = state.answers[qid];
        local == null ? answers.remove(qid) : answers[qid] = local;
      }
    }

    _paused = false;
    _deadline = DateTime.now().add(Duration(seconds: section.remainingSeconds));
    _lastSync = DateTime.now();
    emit(
      AttemptRunState(
        status: AttemptRunStatus.ready,
        section: section,
        answers: answers,
        remainingSeconds: section.remainingSeconds,
        notice: state.notice,
      ),
    );
    _startTicker();
  }

  void _startTicker() {
    _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_paused || state.status != AttemptRunStatus.ready) return;
    final left = math.max(0, _deadline.difference(DateTime.now()).inSeconds);
    if (left != state.remainingSeconds) {
      emit(state.copyWith(remainingSeconds: left));
    }
    if (left == 0) {
      // The server closes the expired section and hands back the next one.
      _paused = true;
      _notice(AttemptNoticeKind.sectionTimeUp);
      _loadSection();
    } else if (DateTime.now().difference(_lastSync) >= _resyncEvery) {
      _lastSync = DateTime.now();
      _loadSection();
    }
  }

  Future<void> selectOption(int questionId, int optionId) async {
    if (state.status != AttemptRunStatus.ready || state.remainingSeconds <= 0) {
      return;
    }
    final current = state.answers[questionId];
    final next = current == optionId ? null : optionId;
    final answers = Map.of(state.answers);
    next == null ? answers.remove(questionId) : answers[questionId] = next;
    emit(state.copyWith(answers: answers));

    final seq = (_answerSeq[questionId] ?? 0) + 1;
    _answerSeq[questionId] = seq;
    try {
      await _repo.saveAnswer(
        attemptId,
        questionId: questionId,
        optionIds: next == null ? const [] : [next],
      );
      if (isClosed) return;
      if (_answerSeq[questionId] == seq) {
        _answerSeq.remove(questionId);
        next == null
            ? _confirmed.remove(questionId)
            : _confirmed[questionId] = next;
      }
    } catch (e) {
      if (isClosed || _answerSeq[questionId] != seq) return;
      _answerSeq.remove(questionId);
      final rolledBack = Map.of(state.answers);
      final confirmed = _confirmed[questionId];
      confirmed == null
          ? rolledBack.remove(questionId)
          : rolledBack[questionId] = confirmed;
      emit(state.copyWith(answers: rolledBack));
      _notice(AttemptNoticeKind.answerFailed, e);
      // «Время раздела истекло» — move on to whatever the server says is current.
      if (e is AppException && e.type == ExceptionType.validation) {
        _loadSection();
      }
    }
  }

  Future<void> finishSection() async {
    if (state.status != AttemptRunStatus.ready) return;
    emit(state.copyWith(status: AttemptRunStatus.busy));
    try {
      final attempt = await _repo.finishSection(attemptId);
      if (isClosed) return;
      if (attempt.status == AttemptStatus.completed) {
        _complete();
      } else {
        await _loadSection(showLoading: true);
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: AttemptRunStatus.ready));
      _notice(AttemptNoticeKind.answerFailed, e);
    }
  }

  /// «Завершить тест досрочно».
  Future<void> finishAttempt() async {
    if (state.status == AttemptRunStatus.busy) return;
    final previous = state.status;
    emit(state.copyWith(status: AttemptRunStatus.busy));
    try {
      final result = await _repo.finish(attemptId);
      if (isClosed) return;
      _complete(result);
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: previous));
      _notice(AttemptNoticeKind.answerFailed, e);
    }
  }

  /// App backgrounded or the user left: freeze the section timer server-side.
  Future<void> pause() async {
    if (state.status == AttemptRunStatus.completed || _paused) return;
    _paused = true;
    try {
      await _repo.pause(attemptId);
    } catch (_) {
      // Best effort — the server still enforces the deadline.
    }
  }

  /// Back in the foreground: `GET /section` lifts the pause and resyncs.
  Future<void> resume() async {
    if (state.status == AttemptRunStatus.completed) return;
    await _loadSection(showLoading: state.section == null);
  }

  Future<bool> _isCompleted() async {
    try {
      final attempt = await _repo.getState(attemptId);
      return attempt.status == AttemptStatus.completed;
    } catch (_) {
      return false;
    }
  }

  void _complete([AttemptResult? result]) {
    _ticker?.cancel();
    _ticker = null;
    emit(state.copyWith(status: AttemptRunStatus.completed, result: result));
  }

  void _notice(AttemptNoticeKind kind, [Object? error]) {
    emit(state.copyWith(notice: AttemptRunNotice(++_noticeSeq, kind, error)));
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
