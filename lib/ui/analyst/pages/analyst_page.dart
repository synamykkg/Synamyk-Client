import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:synamyk/data/repositories/analyst/analyst_repository.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/analyst/bloc/analyst_bloc.dart';
import 'package:synamyk/ui/analyst/widgets/select_option_for_date.dart';
import 'package:synamyk/data/api/swagger/generated/synamyk_api.enums.swagger.dart';

class AnalystPage extends StatelessWidget {
  const AnalystPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              AnalystBloc(analystRepository: GetIt.I<AnalystRepository>())
                ..add(const AnalystStarted()),
      child: const _AnalystPageView(),
    );
  }
}

class _AnalystPageView extends StatelessWidget {
  const _AnalystPageView();

  void _showSubjectSelector(BuildContext context) {
    final analystBloc = context.read<AnalystBloc>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // tests из state — список TestItem от API
                  children:
                      analystBloc.state.tests.map((test) {
                        return ListTile(
                          leading: Radio<int>(
                            value: test.id!,
                            groupValue: analystBloc.state.selectedTestId,
                            onChanged: (_) {},
                          ),
                          title: Text(
                            test.title ?? '',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            analystBloc.add(AnalystTestChanged(test.id!));
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _periodLabel(ApiAnalyticsChartGetPeriod period, S l10n) {
    switch (period) {
      case ApiAnalyticsChartGetPeriod.week:
        return l10n.periodWeek;
      case ApiAnalyticsChartGetPeriod.month:
        return l10n.periodMonth;
      case ApiAnalyticsChartGetPeriod.year:
        return l10n.periodYear;
      case ApiAnalyticsChartGetPeriod.sixMonths:
        return l10n.periodSixMonths;
      case ApiAnalyticsChartGetPeriod.threeMonths:
        return l10n.periodThreeMonths;
      default:
        return period.value ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Scaffold(
      body: BlocBuilder<AnalystBloc, AnalystState>(
        builder: (context, state) {
          if (state.status == AnalystStatus.loading && state.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AnalystStatus.failure && state.data == null) {
            return Center(child: Text(l10n.analystError(state.errorMessage ?? '')));
          }

          final data = state.data;

          // ── Данные из API ──────────────────────────────────────────────
          final totalScore = data?.totalScore ?? 0.0;
          final changePercent =
              data?.changePercent ?? 0.0; // вместо scoreDifferences
          final points = data?.points ?? []; // вместо chartData

          // Периоды — из enum, исключая служебное значение
          final periods =
              ApiAnalyticsChartGetPeriod.values
                  .where(
                    (p) =>
                        p != ApiAnalyticsChartGetPeriod.swaggerGeneratedUnknown,
                  )
                  .toList();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),

                      // ── Выбор теста (вместо selectedSubject.label) ─────
                      GestureDetector(
                        onTap: () => _showSubjectSelector(context),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                state.selectedTest?.title ??
                                    data?.testTitle ??
                                    '',
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow:
                                    TextOverflow.ellipsis, // ← обрезает с "..."
                                maxLines: 1,
                              ),
                            ),
                            const Icon(Icons.align_horizontal_right),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.totalScore,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                totalScore.toStringAsFixed(2),
                                style: GoogleFonts.inter(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              // ── changePercent вместо diff ───────────────
                              Row(
                                children: [
                                  Icon(
                                    changePercent >= 0
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    size: 15,
                                    color:
                                        changePercent >= 0
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          changePercent >= 0
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // ── SelectOptionForDate с реальными периодами ───
                          SelectOptionForDate(
                            type: SelectOptionForDateType.period,
                            value: _periodLabel(state.selectedPeriod, l10n),
items: periods.map((p) => _periodLabel(p, l10n)).toList(),                            onChanged: (index) {
                              context.read<AnalystBloc>().add(
                                AnalystPeriodChanged(periods[index]),
                              );
                            },
                            selectedIndex: state.selectedPeriod.index - 1,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── График: points вместо chartData ─────────────────
                      if (points.isNotEmpty)
                        AspectRatio(
                          aspectRatio: 1.30,
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(
                                show: false,
                                drawVerticalLine: true,
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 32,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      int total = points.length;
                                      int desiredLabels =
                                          8; // сколько подписей хочешь

                                      int step = (total / desiredLabels).ceil();
                                      if (value % 1 != 0) {
                                        return const SizedBox.shrink();
                                      }

                                      final index = value.toInt();

                                      if (index < 0 || index >= points.length) {
                                        return const SizedBox.shrink();
                                      }

                                      if (index % step != 0 &&
                                          index != points.length - 1) {
                                        return const SizedBox.shrink();
                                      }

                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: Text(
                                          (index + 1).toString(),
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    interval: 5,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineTouchData: const LineTouchData(enabled: true),
                              minX: 0,
                              maxX: (points.length - 1).toDouble(),
                              minY: 0,
                              // защита от краша когда все score = 0
                              maxY:
                                  points
                                              .map(
                                                (e) =>
                                                    (e.score ?? 0).toDouble(),
                                              )
                                              .reduce(max) >
                                          0
                                      ? points
                                              .map(
                                                (e) =>
                                                    (e.score ?? 0).toDouble(),
                                              )
                                              .reduce(max) *
                                          1.2
                                      : 10,
                              lineBarsData: [
                                LineChartBarData(
                                  spots:
                                      points
                                          .asMap()
                                          .entries
                                          .map(
                                            (e) => FlSpot(
                                              e.key.toDouble(),
                                              (e.value.score ?? 0).toDouble(),
                                            ),
                                          )
                                          .toList(),
                                  barWidth: 5,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(show: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
