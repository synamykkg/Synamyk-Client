import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_finish_result.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_question_result.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/ui/resources/app_strings.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/utils/format_duration.dart';

/// Renders a finished sub-test session's result. Used both right after
/// finishing a test and when revisiting a past attempt from its history
/// (fetched by sessionId).
class OrtTestCompletedView extends StatelessWidget {
  const OrtTestCompletedView({
    super.key,
    required this.finishResult,
    required this.language,
    required this.id,
  });

  final OrtSubTestFinishResult finishResult;
  final String language;
  final int id;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final percent = finishResult.percentage.toDouble();
    final ratio =
        finishResult.totalQuestions == 0
            ? 0.0
            : finishResult.correctAnswers / finishResult.totalQuestions;
    final canPop = Navigator.of(context).canPop();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: const SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.headerGradient),
            ),
          ),
          leading:
              canPop
                  ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).maybePop(),
                  )
                  : null,
          titleSpacing: canPop ? 0 : 20,
          title: Text(
            finishResult.subTestTitle.isNotEmpty
                ? finishResult.subTestTitle
                : l10n.yourResult,
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SyCard(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox.expand(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: ratio),
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.easeOutCubic,
                              builder:
                                  (_, v, _) => CircularProgressIndicator(
                                    value: v,
                                    strokeWidth: 12,
                                    strokeCap: StrokeCap.round,
                                    backgroundColor: AppColors.primarySoft,
                                  ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.emoji_events_rounded,
                                color: AppColors.gold,
                                size: 28,
                              ),
                              Text(
                                '${percent.toStringAsFixed(percent == percent.roundToDouble() ? 0 : 1)}%',
                                style: AppTextStyles.h1.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.yourResult,
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (finishResult.motivationalMessage.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        finishResult.motivationalMessage,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SyCard(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    _Stat(
                      icon: Icons.check_circle_rounded,
                      color: AppColors.success,
                      value: '${finishResult.correctAnswers}',
                      label: context.tr('верно', 'туура'),
                    ),
                    _Stat(
                      icon: Icons.cancel_rounded,
                      color: AppColors.danger,
                      value: '${finishResult.wrongAnswers}',
                      label: context.tr('ошибки', 'ката'),
                    ),
                    _Stat(
                      icon: Icons.remove_circle_rounded,
                      color: AppColors.textMuted,
                      value: '${finishResult.skippedAnswers}',
                      label: context.tr('пропущено', 'өткөрүлдү'),
                    ),
                    _Stat(
                      icon: Icons.timer_rounded,
                      color: AppColors.primary,
                      value: formatDuration(finishResult.timeTakenSeconds),
                      label: l10n.timeLabel,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SyCard(
                onTap: () {
                  showModalBottomSheet<void>(
                    useSafeArea: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return _OrtTestResultsModal(
                        results: finishResult.questionResults,
                        language: language,
                        id: id,
                        sessionId: finishResult.sessionId,
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    const SyIconTile(
                      icon: Icons.auto_awesome_rounded,
                      color: AppColors.pink,
                      background: AppColors.pinkSoft,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.viewErrors,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
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
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _OrtTestResultsModal extends StatefulWidget {
  final List<OrtSubTestQuestionResult> results;
  final String language;
  final int id;
  final int sessionId;

  const _OrtTestResultsModal({
    required this.results,
    required this.language,
    required this.id,
    required this.sessionId,
  });

  @override
  State<_OrtTestResultsModal> createState() => _OrtTestResultsModalState();
}

class _OrtTestResultsModalState extends State<_OrtTestResultsModal> {
  final Set<String> selectedIds = {};

  void _toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SyButton(
            label: l10n.analyzeWithAi,
            icon: Icons.auto_awesome_rounded,
            onPressed:
                selectedIds.isEmpty
                    ? null
                    : () {
                      final selectedResults =
                          widget.results
                              .where(
                                (r) => selectedIds.contains(
                                  r.questionId.toString(),
                                ),
                              )
                              .toList();
                      GoRouter.of(context).push(
                        '/ort_test/${widget.language}/${widget.id}/ai_analyst',
                        extra: {
                          'sessionId': widget.sessionId,
                          'results': selectedResults,
                        },
                      );
                    },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                pinned: false,
                floating: false,
                snap: false,
                titleSpacing: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                title: Text(l10n.results, style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700)),
              ),
              SliverGrid.builder(
                itemCount: widget.results.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 80,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final result = widget.results[index];
                  final isSelected = selectedIds.contains(
                    result.questionId.toString(),
                  );
                  final isSkipped = result.isSkipped;
                  // AI analysis only makes sense for wrong answers: a
                  // correct or skipped question has no "error" to explain,
                  // and the backend returns an empty analysis for it.
                  final isSelectable = !isSkipped && !result.isCorrect;

                  return GestureDetector(
                    onTap:
                        isSelectable
                            ? () =>
                                _toggleSelection(result.questionId.toString())
                            : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelectable
                                ? Colors.white
                                : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFF6D35E0)
                                  : const Color(
                                    0xFF252525,
                                  ).withOpacity(isSelectable ? 0.5 : 0.2),
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 8,
                              children: [
                                Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        isSkipped
                                            ? Colors.orange
                                            : result.isCorrect
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  child: Icon(
                                    isSkipped
                                        ? Icons.emoji_events
                                        : result.isCorrect
                                        ? Icons.check
                                        : Icons.close,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                                Text(
                                  '№${index + 1}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Color(
                                      result.isCorrect
                                          ? 0xFF08A64A
                                          : 0xFFE34444,
                                    ).withOpacity(isSelectable ? 0.5 : 0.2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 6,
                              left: 6,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6D35E0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
