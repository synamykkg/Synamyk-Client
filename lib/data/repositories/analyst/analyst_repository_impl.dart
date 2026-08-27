// analyst_repository.dart
import 'package:flutter/material.dart';
import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/repositories/analyst/analyst_repository.dart';

// analyst_repository_impl.dart
class AnalystRepositoryImpl implements AnalystRepository {
  final SynamykApiClient synamykApi;

  AnalystRepositoryImpl({required this.synamykApi});

  @override
  Future<AnalyticsChartResponse> getAnalyticsData({
    int? testId,
    required ApiAnalyticsChartGetPeriod chartPeriod,
  }) async {
    final response = await synamykApi.auth.apiAnalyticsChartGet(
      testId: testId,
      period: chartPeriod,
    );

    if (response.statusCode == 200 && response.body != null) {
      return response.body!;
    }
    debugPrint(response.toString());
    throw Exception('Failed to get analytics data');
  }

  @override
  Future<List<TestListResponse>> getTests() async {
    final response = await synamykApi.auth.apiAnalyticsFiltersGet();

    if (response.statusCode == 200 && response.body != null) {
      return response.body!;
    }
    throw Exception('Failed to get tests');
  }
}
