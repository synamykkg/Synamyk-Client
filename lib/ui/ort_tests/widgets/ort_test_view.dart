import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/ort_attempt/widgets/attempt_question_card.dart';
import 'package:synamyk/ui/ort_tests/bloc/ort_test_bloc.dart';
import 'package:synamyk/ui/ort_tests/widgets/ort_test_exit_modal.dart';
import 'package:synamyk/utils/format_duration.dart';
import 'package:synamyk/widgets/math_text.dart';

class OrtTestView extends StatelessWidget {
  const OrtTestView({super.key, required this.state});

  final OrtTestLoaded state;

  void _showExitModal(BuildContext context, S l10n) {
    final bloc = context.read<OrtTestBloc>();

    bloc.add(OpenExitModal());

    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => OrtTestExitModal(
            onConfirm: () {
              bloc.add(SubmitExitModal());
              Navigator.pop(context, 'confirmed');
              context.go('/home');
            },
            onCancel: () {
              bloc.add(CloseExitModal());
              Navigator.pop(context, 'cancelled');
            },
            onDismiss: () {
              bloc.add(CloseExitModal());
            },
            title: l10n.exitTestTitle,
            subTitle: l10n.exitTestMessage,
            confirmText: l10n.exitTestConfirm,
            cancelText: l10n.exitTestCancel,
          ),
    ).then((result) {
      if (result == null) {
        bloc.add(CloseExitModal());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = state.ortTestList;
    final l10n = S.of(context);
    final total = question.totalQuestions == 0 ? 1 : question.totalQuestions;
    final low = state.duration <= 60;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          flexibleSpace: const SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.headerGradient),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => _showExitModal(context, l10n),
          ),
          titleSpacing: 0,
          title: Text(
            question.sectionName.isNotEmpty
                ? question.sectionName
                : state.ortTest.subTestTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(58),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 16, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${question.index + 1} / ${question.totalQuestions}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SyProgressBar(
                          value: question.index / total,
                          color: Colors.white,
                          trackColor: Colors.white.withValues(alpha: 0.25),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: low ? AppColors.danger : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 18,
                          color: low ? Colors.white : AppColors.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          formatDuration(state.duration),
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: low ? Colors.white : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          sliver: SliverToBoxAdapter(
            child: SyCard(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.tr(
                      'Вопрос ${question.index + 1}',
                      '${question.index + 1}-суроо',
                    ),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  MathText(
                    question.text,
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.35,
                    ),
                  ),
                  if (question.imageUrl.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        question.imageUrl,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  for (final option in question.options) ...[
                    AnswerOptionTile(
                      label: option.label,
                      text: option.text,
                      selected: state.variants.contains(option),
                      onTap:
                          () => context.read<OrtTestBloc>().add(
                            SelectVariantTest(variant: option),
                          ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
