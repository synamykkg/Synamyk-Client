import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';
import 'package:synamyk/domain/models/ort_test/ai_analysis_result.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_finish_result.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_question.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_question_result.dart';
import 'package:synamyk/error/app_exception.dart';

part 'ort_test_ai_analyst_event.dart';
part 'ort_test_ai_analyst_state.dart';

class OrtTestAiAnalystBloc
    extends Bloc<OrtTestAiAnalystEvent, OrtTestAiAnalystState> {
  final OrtTestsRepository _repository;

  OrtTestAiAnalystBloc(this._repository) : super(OrtTestAiAnalystInitial()) {
    on<LoadAiAnalysis>(_onLoadAiAnalysis);
  }

  Future<void> _onLoadAiAnalysis(
    LoadAiAnalysis event,
    Emitter<OrtTestAiAnalystState> emit,
  ) async {
    emit(OrtTestAiAnalystLoading());
    try {
      final results = await _repository.getAiAnalysis(event.sessionId ,event.results);
      emit(OrtTestAiAnalystLoaded(results));
    } catch (e) {
      final message = e is AppException ? e.message : null;
      emit(OrtTestAiAnalystFailure(message ?? 'Не удалось загрузить анализ ИИ'));
    }
  }
}
