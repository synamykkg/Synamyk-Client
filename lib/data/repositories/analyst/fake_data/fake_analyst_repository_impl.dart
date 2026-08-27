// import 'package:synamyk/data/repositories/analyst/analyst_repository.dart';
// import 'package:synamyk/domain/enums/analytics_period.dart';
// import 'package:synamyk/domain/models/analyst/analytics_chart_point.dart';
// import 'package:synamyk/domain/models/analyst/analytics_data.dart';

// class FakeAnalystRepositoryImpl implements AnalystRepository {
//   @override
//   Future<AnalyticsData> getAnalyticsData({
//     required String subjectId,
//     required AnalyticsPeriod chartPeriod,
//   }) async {
//     await Future.delayed(const Duration(seconds: 1));

//     final DateTime now = DateTime.now();
//     List<AnalyticsChartPoint> chartData = [];
//     int pointsCount;
//     Duration interval;

//     switch (chartPeriod) {
//       case AnalyticsPeriod.week:
//         pointsCount = 7;
//         interval = const Duration(days: 1);
//         break;
//       case AnalyticsPeriod.month:
//         pointsCount = 30;
//         interval = const Duration(days: 1);
//         break;
//       case AnalyticsPeriod.threeMonths:
//         pointsCount = 12; // Approx weeks
//         interval = const Duration(days: 7);
//         break;
//       case AnalyticsPeriod.sixMonths:
//         pointsCount = 6;
//         interval = const Duration(days: 30);
//         break;
//       case AnalyticsPeriod.year:
//         pointsCount = 12;
//         interval = const Duration(days: 30);
//         break;
//     }

//     for (int i = 0; i < pointsCount; i++) {
//       chartData.add(
//         AnalyticsChartPoint(
//           date: now.subtract(interval * (pointsCount - 1 - i)),
//           score: 10.0 + (i * 2) + (now.millisecond % 10),
//         ),
//       );
//     }

//     return AnalyticsData(
//       totalScore: 852.96,
//       scoreDifferences: {
//         AnalyticsPeriod.week: 25.58,
//         AnalyticsPeriod.month: 50.0,
//         AnalyticsPeriod.threeMonths: 120.5,
//         AnalyticsPeriod.sixMonths: 200.0,
//         AnalyticsPeriod.year: 350.0,
//       },
//       chartData: chartData,
//     );
//   }
// }
