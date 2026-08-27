import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/home/home_repository.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/ui/resources/app_strings.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/home/bloc/subject_tests/subject_tests_bloc.dart';
import 'package:synamyk/ui/payment/models/payment_confirm_args.dart';

class HomeTestsListPage extends StatelessWidget {
  const HomeTestsListPage({super.key, required this.language});

  final String language;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Scaffold(
      body: BlocProvider(
        create:
            (context) =>
                SubjectTestsBloc(repository: GetIt.I<HomeRepository>())
                  ..add(GetSubjectTestsList(id: language)),
        child: BlocBuilder<SubjectTestsBloc, SubjectTestsState>(
          builder: (context, state) {
            if (state is SubjectTestsLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    snap: false,

                    // App bar is not pinned at the top
                    pinned: true,

                    // App bar does not float
                    floating: false,
                    flexibleSpace: FlexibleSpaceBar(
                      // Center the title in the app bar
                      centerTitle: true,
                      title: Text.rich(
                        TextSpan(
                          text: l10n.homeTests,
                          style: AppTextStyles.homeTitle,
                          children: [
                            TextSpan(
                              text: l10n.appName,
                              style: AppTextStyles.homeTitleAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),

                        child: Center(
                          child: Row(
                            spacing: 21,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const _LevelStatusIcon(status: _LevelStatus.free),
                              GestureDetector(
                                onTap: () {
                                  context.push(
                                    '/ort_test/$language/${state.freeTests[index].id}',
                                  );
                                },
                                child: Container(
                                  width: 282,
                                  constraints: const BoxConstraints(minHeight: 97),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEDF8F2),
                                    border: Border.all(
                                      color: Color(0xFF252525).withOpacity(0.1),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          l10n.freeLevel,
                                          style: AppTextStyles.testCardLabel,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          state.freeTests[index].title,
                                          style: AppTextStyles.testCardTitle,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          spacing: 10,
                                          children: [
                                            Row(
                                              spacing: 2,
                                              children: [
                                                Icon(
                                                  Icons.watch_later,
                                                  size: 15,
                                                ),
                                                Text(
                                                  l10n.minutes(state.freeTests[index].minutes),
                                                  style:
                                                      AppTextStyles
                                                          .testCardMetadata,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              spacing: 2,
                                              children: [
                                                Icon(
                                                  Icons.question_mark,
                                                  size: 15,
                                                ),
                                                Text(
                                                  l10n.questions(state.freeTests[index].questions),
                                                  style:
                                                      AppTextStyles
                                                          .testCardMetadata,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (state.freeTests[index].bestScore != null ||
                                            state.freeTests[index].attemptsCount > 0) ...[
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: [
                                              if (state.freeTests[index].bestScore != null)
                                                _CardActionChip(
                                                  icon: Icons.emoji_events,
                                                  label: 'Лучший балл: ${state.freeTests[index].bestScore}',
                                                  color: const Color(0xFF7B1FA2),
                                                  background: const Color(0xFFF4E6FA),
                                                  onTap:
                                                      state.freeTests[index].bestSessionId != null
                                                          ? () => context.push(
                                                            '/sessions/${state.freeTests[index].bestSessionId}/result',
                                                            extra: {
                                                              'testId': language,
                                                              'subTestId': int.parse(state.freeTests[index].id),
                                                            },
                                                          )
                                                          : null,
                                                ),
                                              if (state.freeTests[index].attemptsCount > 0)
                                                _CardActionChip(
                                                  icon: Icons.history,
                                                  label: 'Попыток: ${state.freeTests[index].attemptsCount}',
                                                  color: const Color(0xFF616161),
                                                  background: const Color(0xFFE8E8E8),
                                                  onTap: () {
                                                    context.push(
                                                      '/sub_tests/${state.freeTests[index].id}/history',
                                                      extra: language,
                                                    );
                                                  },
                                                ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: state.freeTests.length),
                  ),
                  state.paidTests.isNotEmpty
                      ? SliverToBoxAdapter(
                        child: Center(
                          child: SizedBox(
                            width: 347,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Платные уровни',
                                    style: AppTextStyles.testCardTitle,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF4E6FA),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${state.price.toStringAsFixed(0)} сом',
                                      style: AppTextStyles.testCardMetadata
                                          .copyWith(
                                            color: const Color(0xFF7B1FA2),
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      : const SliverToBoxAdapter(child: SizedBox()),
                  state.paidTests.isNotEmpty
                      ? SliverToBoxAdapter(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(), // важно!
                          itemCount: state.paidTests.length,
                          itemBuilder: (context, index) {
                            final subTest = state.paidTests[index];
                            final locked = !subTest.hasAccess;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Center(
                                child: Opacity(
                                  opacity: locked ? 0.7 : 1,
                                  child: Row(
                                    spacing: 21,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _LevelStatusIcon(
                                        status:
                                            locked
                                                ? _LevelStatus.locked
                                                : _LevelStatus.unlocked,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (locked) {
                                            context.push(
                                              '/payment',
                                              extra: PaymentConfirmArgs(
                                                testId: int.parse(language),
                                                subTestId: int.parse(subTest.id),
                                                testTitle: state.testTitle,
                                                subTestTitle: subTest.title,
                                                price: state.price,
                                                language: language,
                                              ),
                                            );
                                          } else {
                                            context.go(
                                              '/ort_test/$language/${subTest.id}',
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: 282,
                                          constraints: const BoxConstraints(minHeight: 97),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFEDF8F2),
                                            border: Border.all(
                                              color: Color(
                                                0xFF252525,
                                              ).withOpacity(0.1),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  subTest.level,
                                                  style:
                                                      AppTextStyles
                                                          .testCardLabel,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  subTest.title,
                                                  style:
                                                      AppTextStyles
                                                          .testCardTitle,
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  spacing: 10,
                                                  children: [
                                                    Row(
                                                      spacing: 2,
                                                      children: [
                                                        Icon(
                                                          Icons.watch_later,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          l10n.minutes(subTest.minutes),
                                                          style:
                                                              AppTextStyles
                                                                  .testCardMetadata,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      spacing: 2,
                                                      children: [
                                                        Icon(
                                                          Icons.question_mark,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          l10n.questions(subTest.questions),
                                                          style:
                                                              AppTextStyles
                                                                  .testCardMetadata,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                if (subTest.bestScore != null ||
                                                    subTest.attemptsCount > 0) ...[
                                                  const SizedBox(height: 8),
                                                  Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    children: [
                                                      if (subTest.bestScore != null)
                                                        _CardActionChip(
                                                          icon: Icons.emoji_events,
                                                          label: 'Лучший балл: ${subTest.bestScore}',
                                                          color: const Color(0xFF7B1FA2),
                                                          background: const Color(0xFFF4E6FA),
                                                          onTap:
                                                              subTest.bestSessionId != null
                                                                  ? () => context.push(
                                                                    '/sessions/${subTest.bestSessionId}/result',
                                                                    extra: {
                                                                      'testId': language,
                                                                      'subTestId': int.parse(subTest.id),
                                                                    },
                                                                  )
                                                                  : null,
                                                        ),
                                                      if (subTest.attemptsCount > 0)
                                                        _CardActionChip(
                                                          icon: Icons.history,
                                                          label: 'Попыток: ${subTest.attemptsCount}',
                                                          color: const Color(0xFF616161),
                                                          background: const Color(0xFFE8E8E8),
                                                          onTap: () {
                                                            context.push(
                                                              '/sub_tests/${subTest.id}/history',
                                                              extra: language,
                                                            );
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      : const SliverToBoxAdapter(child: SizedBox()),
                ],
              );
            }

            if (state is SubjectTestsError) {
              return Center(child: Text(l10n.subjectUnavailable));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

enum _LevelStatus { free, unlocked, locked }

/// Circular status badge shown next to each level card — green/open for
/// free levels, purple/open once a paid level is purchased, grey/closed
/// while it's still locked.
class _LevelStatusIcon extends StatelessWidget {
  const _LevelStatusIcon({required this.status});

  final _LevelStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground, IconData icon) = switch (status) {
      _LevelStatus.free => (
        const Color(0xFFE8F5E9),
        const Color(0xFF2E7D32),
        Icons.lock_open_rounded,
      ),
      _LevelStatus.unlocked => (
        const Color(0xFFF4E6FA),
        const Color(0xFF7B1FA2),
        Icons.lock_open_rounded,
      ),
      _LevelStatus.locked => (
        const Color(0xFFF0F0F0),
        const Color(0xFF9E9E9E),
        Icons.lock_rounded,
      ),
    };

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, color: foreground, size: 22),
    );
  }
}

/// A pill-shaped, clearly-tappable action shown on a level card (e.g. "best
/// score" or "attempt history"). Unlike plain icon+text, the filled
/// background and trailing chevron make it obviously a button, not a label.
class _CardActionChip extends StatelessWidget {
  const _CardActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final effectiveColor = enabled ? color : const Color(0xFF9E9E9E);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: enabled ? background : const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Icon(icon, size: 14, color: effectiveColor),
            Text(
              label,
              style: AppTextStyles.testCardMetadata.copyWith(
                color: effectiveColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (enabled)
              Icon(Icons.chevron_right_rounded, size: 14, color: effectiveColor),
          ],
        ),
      ),
    );
  }
}
