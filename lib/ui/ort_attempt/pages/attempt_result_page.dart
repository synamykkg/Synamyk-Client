import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:synamyk/data/repositories/ort_attempt/ort_attempt_repository.dart';
import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';
import 'package:synamyk/domain/models/ort_attempt/attempt_result.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/ort_attempt/widgets/ort_format.dart';

/// «Жыйынтык» of a whole-test attempt: ОРТ score card, sections, topics.
class AttemptResultPage extends StatefulWidget {
  const AttemptResultPage({super.key, required this.attemptId, this.initial});

  final int attemptId;

  /// Already fetched by an early finish — avoids a second request.
  final AttemptResult? initial;

  @override
  State<AttemptResultPage> createState() => _AttemptResultPageState();
}

class _AttemptResultPageState extends State<AttemptResultPage> {
  final _cardKey = GlobalKey();
  AttemptResult? _result;
  Object? _error;
  bool _sharing = false;

  @override
  void initState() {
    super.initState();
    _result = widget.initial;
    if (_result == null) _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final result = await GetIt.I<OrtAttemptRepository>().getResult(
        widget.attemptId,
      );
      if (mounted) setState(() => _result = result);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _share(AttemptResult result) async {
    setState(() => _sharing = true);
    try {
      final boundary =
          _cardKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null || !mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(bytes.buffer.asUint8List(), mimeType: 'image/png'),
          ],
          fileNameOverrides: const ['synamyk_result.png'],
          text: context.tr(
            'Мой результат ОРТ в Synamyk: ${result.ortScore} баллов!',
            'Менин Synamyk\'тагы ЖРТ жыйынтыгым: ${result.ortScore} балл!',
          ),
        ),
      );
    } catch (e) {
      if (mounted) showSySnack(context, errorMessage(context, e), error: true);
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return Scaffold(
      appBar: SyAppBar(
        title: context.tr('Итоги', 'Жыйынтык'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.white),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: SyCanvas(
        child: result == null
            ? (_error != null
                  ? SyStateView.error(error: _error, onRetry: _load)
                  : const SyStateView.loading())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  RepaintBoundary(
                    key: _cardKey,
                    child: _ScoreCard(result: result),
                  ),
                  const SizedBox(height: 14),
                  SyButton(
                    label: context.tr('Поделиться', 'Бөлүшүү'),
                    icon: Icons.ios_share_rounded,
                    loading: _sharing,
                    onPressed: () => _share(result),
                  ),
                  const SizedBox(height: 14),
                  _StatsRow(result: result),
                  if (result.sections.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _SectionsCard(result: result),
                  ],
                  if (result.topics.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _TopicsCard(topics: result.topics),
                  ],
                  const SizedBox(height: 18),
                  Text(
                    context.tr(
                      '* Результат теста не используется как оценка по предметам',
                      '* Тесттин жыйынтыгы сабактар үчүн баа катары колдонулбайт',
                    ),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.result});

  final AttemptResult result;

  @override
  Widget build(BuildContext context) {
    final passed = result.passedThreshold;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 26),
            decoration: const BoxDecoration(gradient: AppColors.headerGradient),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.gold,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: result.ortScore.toDouble()),
                  duration: const Duration(milliseconds: 1100),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, _) => Text(
                    '${v.round()}',
                    style: AppTextStyles.displayLarge.copyWith(
                      fontSize: 64,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  context.tr(
                    'баллов из ${result.maxScore}',
                    '${result.maxScore} баллдан',
                  ),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 12),
                _ThresholdBar(result: result),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: passed ? AppColors.success : AppColors.danger,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    passed
                        ? context.tr(
                            'Порог ${result.thresholdScore} пройден',
                            'Босого ${result.thresholdScore} өттү',
                          )
                        : context.tr(
                            'Порог ${result.thresholdScore} не пройден',
                            'Босого ${result.thresholdScore} өткөн жок',
                          ),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Column(
              children: [
                if (result.userFullName.isNotEmpty)
                  Text(
                    result.userFullName,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  [
                    result.testTitle,
                    formatDate(result.completedAt),
                  ].where((s) => s.isNotEmpty).join(' · '),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.tr(
                    'Моё достижение на ОРТ',
                    'Менин ЖРТ боюнча жетишкендигим',
                  ),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (result.motivationalMessage?.isNotEmpty == true) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      result.motivationalMessage!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        'assets/icons/logo/synamyk_icon_500.png',
                        width: 22,
                        height: 22,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Synamyk',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Score vs. threshold on one scale.
class _ThresholdBar extends StatelessWidget {
  const _ThresholdBar({required this.result});

  final AttemptResult result;

  @override
  Widget build(BuildContext context) {
    final max = result.maxScore <= 0 ? 1 : result.maxScore;
    final score = (result.ortScore / max).clamp(0.0, 1.0);
    final threshold = (result.thresholdScore / max).clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, c) {
        return SizedBox(
          height: 14,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                top: 4,
                bottom: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 4,
                bottom: 4,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: score),
                  duration: const Duration(milliseconds: 1100),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, _) => Container(
                    width: c.maxWidth * v,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: c.maxWidth * threshold - 1.5,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 3,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.result});

  final AttemptResult result;

  @override
  Widget build(BuildContext context) {
    Widget stat(IconData icon, Color color, String value, String label) {
      return Expanded(
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    final minutes = (result.timeTakenSeconds / 60).round();
    return SyCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Row(
        children: [
          stat(
            Icons.check_circle_rounded,
            AppColors.success,
            '${result.correctAnswers}',
            context.tr('верно', 'туура'),
          ),
          stat(
            Icons.cancel_rounded,
            AppColors.danger,
            '${result.wrongAnswers}',
            context.tr('ошибки', 'ката'),
          ),
          stat(
            Icons.remove_circle_rounded,
            AppColors.textMuted,
            '${result.skippedAnswers}',
            context.tr('пропущено', 'өткөрүлдү'),
          ),
          stat(
            Icons.timer_rounded,
            AppColors.primary,
            formatMinutes(context, minutes),
            context.tr('время', 'убакыт'),
          ),
        ],
      ),
    );
  }
}

class _SectionsCard extends StatefulWidget {
  const _SectionsCard({required this.result});

  final AttemptResult result;

  @override
  State<_SectionsCard> createState() => _SectionsCardState();
}

class _SectionsCardState extends State<_SectionsCard> {
  /// sessionId whose AI analysis is being prepared.
  int? _loadingSessionId;

  Color _color(double percent) => percent >= 70
      ? AppColors.success
      : percent >= 40
      ? AppColors.warning
      : AppColors.danger;

  /// Opens the AI explanation for the wrong answers of one section.
  Future<void> _analyze(SectionResult section) async {
    final sessionId = section.sessionId;
    if (sessionId == null || _loadingSessionId != null) return;
    setState(() => _loadingSessionId = sessionId);
    try {
      final result = await GetIt.I<OrtTestsRepository>().getSessionResult(
        sessionId,
      );
      final wrong = result.questionResults
          .where((q) => !q.isCorrect && !q.isSkipped)
          .toList();
      if (!mounted) return;
      if (wrong.isEmpty) {
        showSySnack(
          context,
          context.tr(
            'В этом разделе нет ошибок для разбора',
            'Бул бөлүмдө талдоочу ката жок',
          ),
        );
        return;
      }
      await context.push(
        '/ort_test/${widget.result.testId}/${section.subTestId}/ai_analyst',
        extra: {'sessionId': sessionId, 'results': wrong},
      );
    } catch (e) {
      if (mounted) showSySnack(context, errorMessage(context, e), error: true);
    } finally {
      if (mounted) setState(() => _loadingSessionId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SyCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SySectionTitle(context.tr('По разделам', 'Бөлүктөр боюнча')),
          const SizedBox(height: 4),
          for (final s in widget.result.sections)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          s.title,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        s.ortScore != null && s.maxScore != null
                            ? context.tr(
                                '${s.ortScore} / ${s.maxScore} б.',
                                '${s.ortScore} / ${s.maxScore} балл',
                              )
                            : '${s.correctAnswers} / ${s.totalQuestions}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 52,
                        child: Text(
                          formatPercent(s.percentage),
                          textAlign: TextAlign.right,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _color(s.percentage),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SyProgressBar(
                    value: s.percentage / 100,
                    color: _color(s.percentage),
                  ),
                  if (s.sessionId != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SyButton(
                            label: context.tr('Разбор с ИИ', 'ИИ менен талдоо'),
                            icon: Icons.auto_awesome_rounded,
                            style: SyButtonStyle.secondary,
                            height: 40,
                            loading: _loadingSessionId == s.sessionId,
                            onPressed: () => _analyze(s),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SyButton(
                            label: context.tr('Мои ответы', 'Жооптарым'),
                            icon: Icons.fact_check_outlined,
                            style: SyButtonStyle.ghost,
                            height: 40,
                            onPressed: () => context.push(
                              '/sessions/${s.sessionId}/result',
                              extra: {
                                'testId': '${widget.result.testId}',
                                'subTestId': s.subTestId,
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (s.status == 'NOT_STARTED') ...[
                    const SizedBox(height: 4),
                    Text(
                      context.tr('Раздел не начат', 'Бөлүм башталган эмес'),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TopicsCard extends StatelessWidget {
  const _TopicsCard({required this.topics});

  final List<TopicResult> topics;

  @override
  Widget build(BuildContext context) {
    final header = AppTextStyles.bodySmall.copyWith(
      color: AppColors.textMuted,
      fontWeight: FontWeight.w600,
    );
    final cell = AppTextStyles.bodyMedium.copyWith(
      color: AppColors.textPrimary,
    );
    return SyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SySectionTitle(context.tr('По темам', 'Темалар боюнча')),
          const SizedBox(height: 12),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.2),
              1: FlexColumnWidth(1.1),
              2: FlexColumnWidth(1.1),
              3: FlexColumnWidth(1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  Text(context.tr('Тема', 'Тема'), style: header),
                  Text(context.tr('Вопросов', 'Суроолор'), style: header),
                  Text(context.tr('Верно', 'Туура'), style: header),
                  Text(
                    context.tr('%', 'Пайыз'),
                    style: header,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              for (final t in topics)
                TableRow(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.divider)),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        t.topic,
                        style: cell.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text('${t.totalQuestions}', style: cell),
                    Text('${t.correctAnswers}', style: cell),
                    Text(
                      formatPercent(t.percentage),
                      textAlign: TextAlign.right,
                      style: cell.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
