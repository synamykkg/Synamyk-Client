// analyst_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/api/swagger/generated/synamyk_api.enums.swagger.dart';
import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/data/repositories/analyst/analyst_repository.dart';

part 'analyst_event.dart';
part 'analyst_state.dart';

class AnalystBloc extends Bloc<AnalystEvent, AnalystState> {
  final AnalystRepository _analystRepository;

  AnalystBloc({required AnalystRepository analystRepository})
      : _analystRepository = analystRepository,
        super(const AnalystState()) {
    on<AnalystStarted>(_onStarted);
    on<AnalystTestChanged>(_onTestChanged);
    on<AnalystPeriodChanged>(_onPeriodChanged);
    on<AnalystRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onStarted(AnalystStarted event, Emitter<AnalystState> emit) async {
    emit(state.copyWith(status: AnalystStatus.loading));
    try {
      final tests = await _analystRepository.getTests();
      emit(state.copyWith(
        tests: tests,
        selectedTestId: tests.isNotEmpty ? tests.first.id : null,
      ));
      await _fetchData(emit);
    } catch (e) {
      emit(state.copyWith(status: AnalystStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onTestChanged(AnalystTestChanged event, Emitter<AnalystState> emit) async {
    emit(state.copyWith(selectedTestId: event.testId));
    await _fetchData(emit);
  }

  Future<void> _onPeriodChanged(AnalystPeriodChanged event, Emitter<AnalystState> emit) async {
    emit(state.copyWith(selectedPeriod: event.period));
    await _fetchData(emit);
  }

  Future<void> _onRefreshRequested(AnalystRefreshRequested event, Emitter<AnalystState> emit) async {
    await _fetchData(emit);
  }

  Future<void> _fetchData(Emitter<AnalystState> emit) async {
    emit(state.copyWith(status: AnalystStatus.loading));
    try {
      final data = await _analystRepository.getAnalyticsData(
        testId: state.selectedTestId,
        chartPeriod: state.selectedPeriod,
      );
      emit(state.copyWith(status: AnalystStatus.success, data: data));
    } catch (e) {
      emit(state.copyWith(status: AnalystStatus.failure, errorMessage: e.toString()));
    }
  }
}