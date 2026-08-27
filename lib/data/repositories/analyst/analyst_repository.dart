import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/domain/enums/analytics_period.dart';
import 'package:synamyk/domain/models/analyst/analytics_data.dart';

abstract class AnalystRepository {
  Future<AnalyticsChartResponse> getAnalyticsData({
    int? testId,
    required ApiAnalyticsChartGetPeriod chartPeriod,
  });

  Future<List<TestListResponse>> getTests();
}
