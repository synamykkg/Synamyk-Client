import 'package:flutter/material.dart';
import 'package:synamyk/domain/models/ort_attempt/section_questions.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/figure/figure_view.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/widgets/math_text.dart';

/// «N-суроо» card: text, image, figure, Column A/B and options.
class AttemptQuestionCard extends StatelessWidget {
  const AttemptQuestionCard({
    super.key,
    required this.question,
    required this.selectedOptionId,
    required this.onSelect,
    this.enabled = true,
  });

  final AttemptQuestion question;
  final int? selectedOptionId;
  final ValueChanged<int> onSelect;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final q = question;
    final answered = selectedOptionId != null;
    return SyCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                context.tr('Вопрос ${q.number}', '${q.number}-суроо'),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: answered ? 1 : 0,
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          if (q.text.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            MathText(
              q.text,
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
          ],
          if (q.imageUrl != null && q.imageUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                q.imageUrl!,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ],
          if (q.figure != null) ...[
            const SizedBox(height: 12),
            FigureView(figure: q.figure!),
          ],
          if (q.isComparison) ...[
            const SizedBox(height: 14),
            ComparisonColumns(
              columnA: q.columnA ?? '',
              columnB: q.columnB ?? '',
            ),
          ],
          const SizedBox(height: 14),
          for (final option in q.options) ...[
            AnswerOptionTile(
              label: option.label,
              text: option.text,
              selected: option.id == selectedOptionId,
              onTap: enabled ? () => onSelect(option.id) : null,
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class ComparisonColumns extends StatelessWidget {
  const ComparisonColumns({
    super.key,
    required this.columnA,
    required this.columnB,
  });

  final String columnA;
  final String columnB;

  @override
  Widget build(BuildContext context) {
    Widget column(String title, String content) {
      return Expanded(
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(minHeight: 120),
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: MathText(
                  content,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        column(context.tr('КОЛОНКА А', 'КОЛОНКА А'), columnA),
        const SizedBox(width: 12),
        column(context.tr('КОЛОНКА Б', 'КОЛОНКА Б'), columnB),
      ],
    );
  }
}

class AnswerOptionTile extends StatelessWidget {
  const AnswerOptionTile({
    super.key,
    required this.label,
    required this.text,
    required this.selected,
    required this.onTap,
    this.stateColor,
  });

  final String label;
  final String text;
  final bool selected;
  final VoidCallback? onTap;

  /// Overrides the selection color (green/red reveal in games).
  final Color? stateColor;

  @override
  Widget build(BuildContext context) {
    final accent = stateColor ?? AppColors.primary;
    final highlighted = selected || stateColor != null;
    return Material(
      color: highlighted ? accent.withValues(alpha: 0.08) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: highlighted ? accent : AppColors.divider,
          width: highlighted ? 1.8 : 1.2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: highlighted ? accent : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: highlighted ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MathText(
                  text,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: highlighted ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reading passage with a line number beside every 5th line.
class ReadingPassageCard extends StatelessWidget {
  const ReadingPassageCard({super.key, required this.passage});

  final ReadingPassage passage;

  @override
  Widget build(BuildContext context) {
    final lines = passage.text.split('\n');
    final textStyle = AppTextStyles.bodyLarge.copyWith(
      color: AppColors.textPrimary,
      height: 1.55,
    );
    return SyCard(
      padding: const EdgeInsets.fromLTRB(10, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 10),
            child: Row(
              children: [
                const SyIconTile(icon: Icons.auto_stories_rounded, size: 34),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    passage.title?.isNotEmpty == true
                        ? passage.title!
                        : context.tr(
                            'Текст ${passage.number}',
                            '${passage.number}-текст',
                          ),
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (passage.imageUrl != null && passage.imageUrl!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                passage.imageUrl!,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 10),
          ],
          for (var i = 0; i < lines.length; i++)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 36,
                  child: (i + 1) % 5 == 0
                      ? Text(
                          '${i + 1}',
                          textAlign: TextAlign.right,
                          style: textStyle.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 13,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lines[i],
                    textAlign: TextAlign.justify,
                    style: textStyle,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
