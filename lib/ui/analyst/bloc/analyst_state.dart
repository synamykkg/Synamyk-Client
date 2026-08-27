// analyst_state.dart
part of 'analyst_bloc.dart';

enum AnalystStatus { initial, loading, success, failure }

class AnalystState {
  final AnalystStatus status;
  final AnalyticsChartResponse? data;
  final List<TestListResponse> tests;
  final int? selectedTestId;
  final ApiAnalyticsChartGetPeriod selectedPeriod;
  final String? errorMessage;

  const AnalystState({
    this.status = AnalystStatus.initial,
    this.data,
    this.tests = const [],
    this.selectedTestId,
    this.selectedPeriod = ApiAnalyticsChartGetPeriod.week,
    this.errorMessage,
  });

  TestListResponse? get selectedTest => tests.isEmpty
      ? null
      : tests.firstWhere(
          (t) => t.id == selectedTestId,
          orElse: () => tests.first,
        );

  AnalystState copyWith({
    AnalystStatus? status,
    AnalyticsChartResponse? data,
    List<TestListResponse>? tests,
    int? selectedTestId,
    ApiAnalyticsChartGetPeriod? selectedPeriod,
    String? errorMessage,
  }) {
    return AnalystState(
      status: status ?? this.status,
      data: data ?? this.data,
      tests: tests ?? this.tests,
      selectedTestId: selectedTestId ?? this.selectedTestId,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}