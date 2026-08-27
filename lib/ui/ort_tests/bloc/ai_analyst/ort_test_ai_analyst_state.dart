part of 'ort_test_ai_analyst_bloc.dart';

abstract class OrtTestAiAnalystState extends Equatable {
  const OrtTestAiAnalystState();

  @override
  List<Object> get props => [];
}

class OrtTestAiAnalystInitial extends OrtTestAiAnalystState {}

class OrtTestAiAnalystLoading extends OrtTestAiAnalystState {}

class OrtTestAiAnalystLoaded extends OrtTestAiAnalystState {
  final List<AiAnalysisResult> results;

  const OrtTestAiAnalystLoaded(this.results);

  @override
  List<Object> get props => [results];
}

class OrtTestAiAnalystFailure extends OrtTestAiAnalystState {
  final String message;

  const OrtTestAiAnalystFailure(this.message);

  @override
  List<Object> get props => [message];
}
