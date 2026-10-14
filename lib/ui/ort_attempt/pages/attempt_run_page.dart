import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/ort_attempt/ort_attempt_repository.dart';
import 'package:synamyk/domain/models/ort_attempt/section_questions.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/ort_attempt/bloc/attempt_run_cubit.dart';
import 'package:synamyk/ui/ort_attempt/widgets/attempt_question_card.dart';
import 'package:synamyk/ui/ort_attempt/widgets/ort_format.dart';
import 'package:synamyk/utils/app_refresh.dart';

/// Taking a whole test: one screen per section with all its questions.
class AttemptRunPage extends StatelessWidget {
  const AttemptRunPage({super.key, required this.attemptId});

  final int attemptId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttemptRunCubit(
        repository: GetIt.I<OrtAttemptRepository>(),
        attemptId: attemptId,
      )..load(),
      child: const _AttemptRunView(),
    );
  }
}

class _AttemptRunView extends StatefulWidget {
  const _AttemptRunView();

  @override
  State<_AttemptRunView> createState() => _AttemptRunViewState();
}

class _AttemptRunViewState extends State<_AttemptRunView>
    with WidgetsBindingObserver {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scroll.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    final cubit = context.read<AttemptRunCubit>();
    switch (lifecycle) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        cubit.pause();
      case AppLifecycleState.resumed:
        cubit.resume();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  Future<void> _exit() async {
    final cubit = context.read<AttemptRunCubit>();
    if (cubit.state.status == AttemptRunStatus.completed) {
      if (mounted) context.pop();
      return;
    }
    final ok = await showSyConfirm(
      context,
      title: context.tr('Остановить тест?', 'Тестти токтотосузбу?'),
      message: context.tr(
        'Таймер раздела остановится. Продолжить можно позже с того же места.',
        'Бөлүмдүн таймери токтойт. Кийин ушул жерден уланта аласыз.',
      ),
      confirm: context.tr('Остановить', 'Токтотуу'),
      cancel: context.tr('Остаться', 'Калуу'),
    );
    if (!ok || !mounted) return;
    await cubit.pause();
    if (mounted) context.pop();
  }

  Future<void> _finishSection(AttemptRunState state) async {
    final section = state.section!;
    final unanswered = section.questions.length - state.answeredCount;
    final ok = await showSyConfirm(
      context,
      title: section.isLastSection
          ? context.tr('Завершить тест?', 'Тестти аяктайсызбы?')
          : context.tr('Завершить раздел?', 'Бөлүмдү аяктайсызбы?'),
      message: [
        context.tr(
          'Вернуться к разделу будет нельзя.',
          'Кайра кайтууга болбойт.',
        ),
        if (unanswered > 0)
          context.tr(
            'Без ответа: $unanswered.',
            'Жооп берилбеген: $unanswered.',
          ),
      ].join('\n'),
      confirm: context.tr('Завершить', 'Аяктоо'),
    );
    if (ok && mounted) context.read<AttemptRunCubit>().finishSection();
  }

  Future<void> _finishWholeTest() async {
    final ok = await showSyConfirm(
      context,
      title: context.tr(
        'Завершить тест досрочно?',
        'Тестти мөөнөтүнөн мурда аяктайсызбы?',
      ),
      message: context.tr(
        'Оставшиеся разделы засчитаются без ответов.',
        'Калган бөлүмдөр жоопсуз эсептелет.',
      ),
      confirm: context.tr('Завершить', 'Аяктоо'),
      destructive: true,
    );
    if (ok && mounted) context.read<AttemptRunCubit>().finishAttempt();
  }

  void _onState(BuildContext context, AttemptRunState state) {
    if (state.status == AttemptRunStatus.completed) {
      AppRefresh.notifyAttemptChanged();
      final attemptId = context.read<AttemptRunCubit>().attemptId;
      context.pushReplacement(
        '/attempts/$attemptId/result',
        extra: state.result,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exit();
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<AttemptRunCubit, AttemptRunState>(
            listenWhen: (a, b) => a.status != b.status,
            listener: _onState,
          ),
          BlocListener<AttemptRunCubit, AttemptRunState>(
            listenWhen: (a, b) =>
                a.notice?.id != b.notice?.id && b.notice != null,
            listener: (context, state) {
              final notice = state.notice!;
              switch (notice.kind) {
                case AttemptNoticeKind.sectionTimeUp:
                  showSySnack(
                    context,
                    context.tr(
                      'Время раздела истекло',
                      'Бөлүмдүн убактысы бүттү',
                    ),
                  );
                case AttemptNoticeKind.answerFailed:
                  showSySnack(
                    context,
                    errorMessage(context, notice.error),
                    error: true,
                  );
              }
            },
          ),
          BlocListener<AttemptRunCubit, AttemptRunState>(
            listenWhen: (a, b) =>
                a.section?.sectionIndex != b.section?.sectionIndex,
            listener: (_, _) {
              if (_scroll.hasClients) _scroll.jumpTo(0);
            },
          ),
        ],
        child: BlocBuilder<AttemptRunCubit, AttemptRunState>(
          builder: (context, state) {
            final section = state.section;
            return Scaffold(
              appBar: SyAppBar(
                title: section?.title ?? '',
                onBack: _exit,
                showBack: true,
                actions: [
                  PopupMenuButton<int>(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onSelected: (_) => _finishWholeTest(),
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flag_outlined,
                              color: AppColors.danger,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              ctx.tr(
                                'Завершить тест досрочно',
                                'Тестти мөөнөтүнөн мурда аяктоо',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                bottom: section == null
                    ? null
                    : _ProgressHeader(
                        section: section,
                        answered: state.answeredCount,
                        remainingSeconds: state.remainingSeconds,
                      ),
              ),
              body: SyCanvas(child: _buildBody(context, state)),
              bottomNavigationBar: section == null
                  ? null
                  : SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                        child: SyButton(
                          loading: state.status == AttemptRunStatus.busy,
                          label: section.isLastSection
                              ? context.tr('Завершить тест', 'Аяктоо')
                              : context.tr('Следующий раздел', 'Кийинки бөлүм'),
                          icon: section.isLastSection
                              ? Icons.flag_rounded
                              : Icons.arrow_forward_rounded,
                          onPressed: state.status == AttemptRunStatus.ready
                              ? () => _finishSection(state)
                              : null,
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AttemptRunState state) {
    final section = state.section;
    if (section == null || state.status == AttemptRunStatus.loading) {
      if (state.status == AttemptRunStatus.failed) {
        return SyStateView.error(
          error: state.error,
          onRetry: () => context.read<AttemptRunCubit>().load(),
        );
      }
      return const SyStateView.loading();
    }

    final cubit = context.read<AttemptRunCubit>();
    final items = _buildItems(section);
    final enabled =
        state.status == AttemptRunStatus.ready && state.remainingSeconds > 0;

    return ListView.separated(
      key: PageStorageKey('section-${section.sectionIndex}'),
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        return switch (items[i]) {
          _PassageItem(:final passage) => ReadingPassageCard(passage: passage),
          _PassageHeaderItem(:final number) => Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    context.tr(
                      'Вопросы к тексту $number',
                      '$number-тексттин суроолору',
                    ),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
          ),
          _QuestionItem(:final question) => AttemptQuestionCard(
            key: ValueKey(question.questionId),
            question: question,
            selectedOptionId: state.answers[question.questionId],
            enabled: enabled,
            onSelect: (optionId) {
              HapticFeedback.selectionClick();
              cubit.selectOption(question.questionId, optionId);
            },
          ),
        };
      },
    );
  }

  /// Passages go right before their first question, followed by
  /// «N-тексттин суроолору» and their questions in `questionIds` order;
  /// questions without a passage keep their section order.
  List<_Item> _buildItems(SectionQuestions section) {
    final byId = {for (final q in section.questions) q.questionId: q};
    final passages = {for (final p in section.passages) p.id: p};
    final emitted = <int>{};
    final items = <_Item>[];

    for (final q in section.questions) {
      if (emitted.contains(q.questionId)) continue;
      final passage = q.passageId == null ? null : passages.remove(q.passageId);
      if (passage != null) {
        items
          ..add(_PassageItem(passage))
          ..add(_PassageHeaderItem(passage.number));
        final ids = passage.questionIds.isNotEmpty
            ? passage.questionIds
            : section.questions
                  .where((x) => x.passageId == passage.id)
                  .map((x) => x.questionId);
        for (final id in ids) {
          final pq = byId[id];
          if (pq != null && emitted.add(id)) items.add(_QuestionItem(pq));
        }
        continue;
      }
      emitted.add(q.questionId);
      items.add(_QuestionItem(q));
    }
    return items;
  }
}

sealed class _Item {
  const _Item();
}

class _PassageItem extends _Item {
  const _PassageItem(this.passage);
  final ReadingPassage passage;
}

class _PassageHeaderItem extends _Item {
  const _PassageHeaderItem(this.number);
  final int number;
}

class _QuestionItem extends _Item {
  const _QuestionItem(this.question);
  final AttemptQuestion question;
}

/// Section counter, answered progress and the section timer.
class _ProgressHeader extends StatelessWidget implements PreferredSizeWidget {
  const _ProgressHeader({
    required this.section,
    required this.answered,
    required this.remainingSeconds,
  });

  final SectionQuestions section;
  final int answered;
  final int remainingSeconds;

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    final total = section.questions.isEmpty
        ? section.totalQuestions
        : section.questions.length;
    final low = remainingSeconds <= 60;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      context.tr(
                        'Раздел ${section.sectionIndex + 1} из ${section.totalSections}',
                        '${section.sectionIndex + 1}/${section.totalSections} бөлүм',
                      ),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$answered / $total',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SyProgressBar(
                  value: total == 0 ? 0 : answered / total,
                  color: Colors.white,
                  trackColor: Colors.white.withValues(alpha: 0.25),
                  height: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
                  formatClock(remainingSeconds),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: low ? Colors.white : AppColors.primary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
