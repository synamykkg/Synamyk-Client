import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_finish_result.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_question.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_option.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/utils/ticker.dart';

part 'ort_test_state.dart';
part 'ort_test_event.dart';

enum ResultStatus { correct, wrong, skip }

class OrtTestBloc extends Bloc<OrtTestEvent, OrtTestState> {
  final Ticker ticker;

  OrtTestBloc({required this.ortTestRepository, required this.ticker})
    : super(OrtTestInitial()) {
    on<LoadOrtTest>((event, emit) async {
      // if (state is! OrtTestLoaded) {
      //   emit(OrtTestLoading());
      // }

      try {
        // if (state is! OrtTestLoaded) {
        //   final ortTests = await ortTestRepository.startOrtTest(event.id);
        //   final ortSubTest = await ortTestRepository.getOrtTest(
        //     ortTests.sessionId,
        //     '',
        //   );

        //   emit(OrtTestLoaded(ortTest: ortTests, ortTestList: ortSubTest));
        // } else {
        //   final ortSubTest = await ortTestRepository.getOrtTest(event.id, '');
        //   final current = state as OrtTestLoaded;

        //   emit(current.copyWith(ortTestList: ortSubTest));
        // }
        final ortTests = await ortTestRepository.startOrtTest(event.id);
        final ortSubTest = await ortTestRepository.getOrtTest(
          ortTests.sessionId,
          '',
        );

        emit(OrtTestLoaded(ortTest: ortTests, ortTestList: ortSubTest));

        add(StartTimerOrtTest(duration: ortTests.durationMinutes * 60));
      } catch (e) {
        emit(OrtTestFailure(exception: e));
      }
    });

    // В SubmitOrtTest:
    on<SubmitOrtTest>((event, emit) async {
      final current = state as OrtTestLoaded;
      if (current.variants.isEmpty) return;

      emit(current.copyWith(isLoading: true));

      try {
        final nextQuestion = await ortTestRepository.sendOrtTestAnswer(
          current.ortTest.sessionId,
          questionId: current.ortTestList.questionId,
          optionsId: current.variants.map((v) => v.id).toList(),
        );
        emit(
          current.copyWith(
            ortTestList: nextQuestion,
            variants: [],
            isLoading: false,
          ),
        );
      } catch (e) {
        // ловим всё
        if (e is AppException && e.isNoContent) {
          await _handleFinish(current, emit);
        } else {
          emit(OrtTestFailure(exception: e));
        }
      }
    });

    on<SkipOrtTest>((event, emit) async {
      final current = state as OrtTestLoaded;

      // if (current.variants.isEmpty) return;

      emit(current.copyWith(isLoading: true));

      try {
        final nextQuestion = await ortTestRepository.skipOrtTest(
          current.ortTest.sessionId,
        );
        emit(
          current.copyWith(
            ortTestList: nextQuestion,
            variants: [],
            isLoading: false,
          ),
        );
      } catch (e) {
        // ловим всё
        if (e is AppException && e.isNoContent) {
          await _handleFinish(current, emit);
        } else {
          emit(OrtTestFailure(exception: e));
        }
      }
    });

    on<SendDataOrtTest>((event, emit) {
      final durarion = event.duration;
      final results = state as OrtTestCompleted;
    });

    on<SelectVariantTest>((event, emit) {
      final current = state as OrtTestLoaded;
      final variants = List<OrtSubTestOption>.from(current.variants);

      // если уже выбран — снимаем, если нет — добавляем
      if (variants.contains(event.variant)) {
        variants.remove(event.variant);
      } else {
        variants.add(event.variant);
      }

      emit(current.copyWith(variants: variants));
    });

    on<OpenExitModal>((event, emit) {
      final current = state as OrtTestLoaded;

      final openPauseModalRequest = ortTestRepository.pauseOrtTest(
        current.ortTest.sessionId,
      );

      emit(current.copyWith(isExitModal: ExitModalState.opened));
    });
    on<CloseExitModal>((event, emit) {
      final current = state as OrtTestLoaded;

      final openPauseModalRequest = ortTestRepository.startOrtTest(
        current.ortTest.subTestId,
      );

      emit(current.copyWith(isExitModal: ExitModalState.closed));
    });
    on<SubmitExitModal>((event, emit) async {
      final current = state as OrtTestLoaded;

      // final openPauseModalRequest = ortTestRepository.finishOrtTest(
      //   current.ortTest.sessionId,
      // );

      await _handleFinish(current, emit);

      emit(current.copyWith(isExitModal: ExitModalState.submitted));
    });

    on<StartTimerOrtTest>(_onStarted);
    on<TimerTicked>(_onTicked);
    // on<StopTimerOrtTest>(_onStopped);
  }
  void _onStarted(StartTimerOrtTest event, Emitter<OrtTestState> emit) {
    final current = state as OrtTestLoaded;

    emit(current.copyWith(duration: event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  void _onTicked(TimerTicked event, Emitter<OrtTestState> emit) {
    if (state is! OrtTestLoaded) return;
    final current = state as OrtTestLoaded;

    emit(current.copyWith(duration: event.duration));
  }

  // void _onStopped(StopTimerOrtTest event, Emitter<OrtTestState> emit) {
  //   final current = state as OrtTestLoaded;

  //   _tickerSubscription?.cancel();

  //   current.ortTestList.skip(current.pages).forEach((element) {
  //     final newResult = OrtSubTestResult(
  //       id: element.id,
  //       result: false,
  //       answer: "",
  //       status: ResultStatus.skip,
  //     );

  //     final List<OrtSubTestResult> updatedResults = [
  //       ...(current.result ?? []),
  //       newResult,
  //     ];

  //     final updatedSolved = current.solvedTests;

  //     if (current.pages == current.ortTestList.length - 1) {
  //       emit(
  //         OrtTestCompleted(
  //           results: updatedResults,
  //           quantity: current.ortTestList.length,
  //           solved: updatedSolved,
  //           indicator: updatedSolved / current.ortTestList.length,
  //           percent: (updatedSolved / current.ortTestList.length * 100).round(),
  //           time: current.initialDuration - current.duration,
  //         ),
  //       );
  //       return;
  //     }

  //     emit(
  //       current.copyWith(
  //         result: updatedResults,
  //         pages: current.pages + 1,
  //         solvedTests: updatedSolved,
  //         variant: null,
  //       ),
  //     );
  //   });
  // }

  Future<void> _handleFinish(
    OrtTestLoaded current,
    Emitter<OrtTestState> emit,
  ) async {
    try {
      final finishResult = await ortTestRepository.finishOrtTest(
        current.ortTest.sessionId,
      );
      _tickerSubscription?.cancel();
      emit(OrtTestCompleted(finishResult: finishResult));
    } catch (e) {
      emit(OrtTestFailure(exception: e));
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  final OrtTestsRepository ortTestRepository;
  StreamSubscription<int>? _tickerSubscription;
  // final Ticker _ticker;
}
