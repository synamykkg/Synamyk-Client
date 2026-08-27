part of 'ort_test_bloc.dart';

enum ExitModalState {
  opened,
  closed,
  submitted 
}

abstract class OrtTestState extends Equatable {}

class OrtTestInitial extends OrtTestState {
  @override
  List<Object?> get props => [];
}

class OrtTestLoading extends OrtTestState {
  @override
  List<Object?> get props => [];
}

class OrtTestStarted extends OrtTestState {
  OrtTestStarted({required this.ortTest});

  final OrtSubTest ortTest;

  @override
  List<Object?> get props => [];
}

class OrtTestLoaded extends OrtTestState {
  OrtTestLoaded({
    required this.ortTest,
    required this.ortTestList,
    this.isLoading = false,
    this.pages = 0,
    this.solvedTests = 0,
    this.variants = const [],
    // this.result,
    this.initialDuration = 600,
    this.duration = 600,
    this.isExitModal = ExitModalState.closed,
  });
  final OrtSubTest ortTest;
  final OrtSubTestQuestion ortTestList;
  final bool isLoading;
  final int pages;
  final int solvedTests;
  final int initialDuration;
  final List<OrtSubTestOption> variants;
  // final List<OrtSubTestResult>? result;
  final int duration;
  final ExitModalState isExitModal;

  OrtTestLoaded copyWith({
    OrtSubTest? ortTest,
    OrtSubTestQuestion? ortTestList,
    bool? isLoading,
    int? pages,
    int? solvedTests,
    int? initialDuration,
    List<OrtSubTestOption>? variants,
    // List<OrtSubTestResult>? result,
    int? duration,
    ExitModalState? isExitModal,
  }) {
    return OrtTestLoaded(
      ortTestList: ortTestList ?? this.ortTestList,
      pages: pages ?? this.pages,
      isLoading: isLoading ?? this.isLoading,
      solvedTests: solvedTests ?? this.solvedTests,
      initialDuration: initialDuration ?? this.initialDuration,
      variants: variants ?? this.variants,
      // result: result ?? this.result,
      duration: duration ?? this.duration,
      ortTest: ortTest ?? this.ortTest,
      isExitModal: isExitModal ?? this.isExitModal,
    );
  }

  @override
  List<Object?> get props => [
    ortTest,
    ortTestList,
    pages,
    variants,
    // result,
    solvedTests,
    duration,
    isLoading,
    isExitModal,
  ];
}

class OrtTestCompleted extends OrtTestState {
  final OrtSubTestFinishResult finishResult;

  OrtTestCompleted({required this.finishResult});

  @override
  List<Object?> get props => [finishResult];
}

class OrtTestFailure extends OrtTestState {
  OrtTestFailure({this.exception});

  final Object? exception;

  OrtTestFailure copyWith({Object? exception}) {
    return OrtTestFailure(exception: exception ?? this.exception);
  }

  @override
  List<Object?> get props => [exception];
}
