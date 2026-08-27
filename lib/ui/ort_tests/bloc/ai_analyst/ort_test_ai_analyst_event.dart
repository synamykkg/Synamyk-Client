part of 'ort_test_ai_analyst_bloc.dart';

// ignore: unused_import
// import 'package:synamyk/domain/models/ort_test/ort_result.dart';

abstract class OrtTestAiAnalystEvent extends Equatable {
  const OrtTestAiAnalystEvent();

  @override
  List<Object> get props => [];
}

class LoadAiAnalysis extends OrtTestAiAnalystEvent {
  final List<OrtSubTestQuestionResult> results;
  final int sessionId;

  const LoadAiAnalysis(this.sessionId ,this.results);

  @override
  List<Object> get props => [results, sessionId];
}
