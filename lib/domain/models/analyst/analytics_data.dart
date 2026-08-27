import 'package:synamyk/domain/enums/analytics_period.dart';
import 'package:synamyk/domain/models/analyst/analytics_chart_point.dart';

class AnalyticsData {
  final double totalScore;

  /// Differences in scores compared to past results.
  /// Key is the period (e.g., week, month), Value is the difference (e.g., +20, -5).
  final Map<AnalyticsPeriod, double> scoreDifferences;
  final List<AnalyticsChartPoint> chartData;

  const AnalyticsData({
    required this.totalScore,
    required this.scoreDifferences,
    required this.chartData,
  });
}
