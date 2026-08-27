// analyst_event.dart
part of 'analyst_bloc.dart';

abstract class AnalystEvent {
  const AnalystEvent();
}

class AnalystStarted extends AnalystEvent {
  const AnalystStarted();
}

class AnalystTestChanged extends AnalystEvent {
  final int testId;
  const AnalystTestChanged(this.testId);
}

class AnalystPeriodChanged extends AnalystEvent {
  final ApiAnalyticsChartGetPeriod period;
  const AnalystPeriodChanged(this.period);
}

class AnalystRefreshRequested extends AnalystEvent {
  const AnalystRefreshRequested();
}