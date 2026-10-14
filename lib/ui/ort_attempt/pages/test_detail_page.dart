import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/catalog/catalog_repository.dart';
import 'package:synamyk/data/repositories/ort_attempt/ort_attempt_repository.dart';
import 'package:synamyk/data/repositories/referral/referral_repository.dart';
import 'package:synamyk/domain/models/catalog/catalog_models.dart';
import 'package:synamyk/domain/models/ort_attempt/full_test.dart';
import 'package:synamyk/domain/models/referral/referral_info.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/ort_attempt/widgets/ort_format.dart';
import 'package:synamyk/ui/payment/models/payment_confirm_args.dart';
import 'package:synamyk/utils/app_refresh.dart';

/// «Негизги тест 1»: totals, sections, «Баштоо».
class TestDetailPage extends StatefulWidget {
  const TestDetailPage({super.key, required this.testId});

  final int testId;

  @override
  State<TestDetailPage> createState() => _TestDetailPageState();
}

class _TestDetailPageState extends State<TestDetailPage> {
  FullTestDetail? _test;
  Object? _error;
  bool _starting = false;

  OrtAttemptRepository get _repo => GetIt.I<OrtAttemptRepository>();

  @override
  void initState() {
    super.initState();
    _load();
    AppRefresh.accessVersion.addListener(_load);
  }

  @override
  void dispose() {
    AppRefresh.accessVersion.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final test = await _repo.getTest(widget.testId);
      if (mounted) {
        setState(() {
          _test = test;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _onStart() async {
    final test = _test;
    if (test == null || _starting) return;

    if (!test.hasAccess) {
      await _showPurchaseOptions(test);
      return;
    }

    var restart = false;
    if (test.resumableAttemptId != null) {
      final choice = await _askResume(test);
      if (choice == null) return;
      restart = choice == _ResumeChoice.restart;
    }

    setState(() => _starting = true);
    try {
      final state = await _repo.start(test.id, restart: restart);
      if (!mounted) return;
      await context.push('/attempts/${state.attemptId}');
      AppRefresh.notifyAttemptChanged();
    } catch (e) {
      if (mounted) showSySnack(context, errorMessage(context, e), error: true);
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  Future<_ResumeChoice?> _askResume(FullTestDetail test) {
    final sectionIndex = test.resumableSectionIndex;
    final section = sectionIndex != null && sectionIndex < test.sections.length
        ? test.sections[sectionIndex].title
        : null;
    return showModalBottomSheet<_ResumeChoice>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: SyIconTile(
                  icon: Icons.restore_rounded,
                  size: 60,
                  color: AppColors.warning,
                  background: AppColors.warningSoft,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                ctx.tr(
                  'У вас есть незавершённый тест',
                  'Сизде аяктала элек тест бар',
                ),
                textAlign: TextAlign.center,
                style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                section == null
                    ? ctx.tr(
                        'Продолжите с того же места или начните заново.',
                        'Ошол жерден улантыңыз же кайра баштаңыз.',
                      )
                    : ctx.tr(
                        'Остановились на разделе «$section».',
                        '«$section» бөлүмүндө токтогонсуз.',
                      ),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              SyButton(
                label: ctx.tr('Продолжить', 'Улантуу'),
                icon: Icons.play_arrow_rounded,
                onPressed: () => Navigator.of(ctx).pop(_ResumeChoice.resume),
              ),
              const SizedBox(height: 10),
              SyButton(
                label: ctx.tr('Начать заново', 'Кайра баштоо'),
                icon: Icons.replay_rounded,
                style: SyButtonStyle.secondary,
                onPressed: () => Navigator.of(ctx).pop(_ResumeChoice.restart),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showPurchaseOptions(FullTestDetail test) async {
    setState(() => _starting = true);
    final results = await Future.wait([
      GetIt.I<CatalogRepository>().getProducts().then<Object?>(
        (v) => v,
        onError: (_) => null,
      ),
      GetIt.I<ReferralRepository>().getMyInfo().then<Object?>(
        (v) => v,
        onError: (_) => null,
      ),
    ]);
    if (!mounted) return;
    setState(() => _starting = false);

    final products = (results[0] as List<ProductModel>?) ?? const [];
    final allTests = products
        .where((p) => p.code == ProductCodes.allTests)
        .firstOrNull;
    final rewards = (results[1] as ReferralInfo?)?.availableRewards ?? 0;

    final action = await showModalBottomSheet<_PurchaseAction>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: SyIconTile(icon: Icons.lock_outline_rounded, size: 60),
              ),
              const SizedBox(height: 14),
              Text(
                ctx.tr('Тест доступен в Премиум', 'Тест Премиумда жеткиликтүү'),
                textAlign: TextAlign.center,
                style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                test.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              if (test.price > 0) ...[
                SyButton(
                  label: ctx.tr(
                    'Купить тест — ${formatSom(test.price)}',
                    'Тестти сатып алуу — ${formatSom(test.price)}',
                  ),
                  icon: Icons.shopping_bag_outlined,
                  onPressed: () =>
                      Navigator.of(ctx).pop(_PurchaseAction.buyTest),
                ),
                const SizedBox(height: 10),
              ],
              if (allTests != null && allTests.canBuy) ...[
                SyButton(
                  label: ctx.tr(
                    'Все тесты — ${formatSom(allTests.price)}',
                    'Бардык тесттер — ${formatSom(allTests.price)}',
                  ),
                  icon: Icons.all_inclusive_rounded,
                  style: SyButtonStyle.secondary,
                  onPressed: () =>
                      Navigator.of(ctx).pop(_PurchaseAction.buyAll),
                ),
                const SizedBox(height: 10),
              ],
              if (rewards > 0)
                SyButton(
                  label: ctx.tr(
                    'Открыть бесплатно за друга',
                    'Дос үчүн акысыз ачуу',
                  ),
                  icon: Icons.card_giftcard_rounded,
                  style: SyButtonStyle.secondary,
                  onPressed: () =>
                      Navigator.of(ctx).pop(_PurchaseAction.redeem),
                )
              else
                SyButton(
                  label: ctx.tr(
                    'Пригласи друга — получи тест',
                    'Досуңду чакыр — тест ал',
                  ),
                  icon: Icons.person_add_alt_rounded,
                  style: SyButtonStyle.ghost,
                  onPressed: () =>
                      Navigator.of(ctx).pop(_PurchaseAction.invite),
                ),
            ],
          ),
        ),
      ),
    );
    if (!mounted || action == null) return;

    switch (action) {
      case _PurchaseAction.buyTest:
        context.push(
          '/payment',
          extra: PaymentConfirmArgs(
            target: PaymentTarget.test,
            testId: test.id,
            testTitle: test.title,
            price: test.price,
            language: '${test.id}',
            returnLocation: '/tests/${test.id}',
          ),
        );
      case _PurchaseAction.buyAll:
        context.push('/product/${ProductCodes.allTests}');
      case _PurchaseAction.invite:
        context.push('/referrals');
      case _PurchaseAction.redeem:
        final ok = await showSyConfirm(
          context,
          title: context.tr(
            'Открыть тест за награду?',
            'Тестти сыйлык менен ачасызбы?',
          ),
          message: context.tr(
            '«${test.title}» откроется навсегда.',
            '«${test.title}» түбөлүккө ачылат.',
          ),
          confirm: context.tr('Открыть', 'Ачуу'),
        );
        if (!ok || !mounted) return;
        try {
          await GetIt.I<ReferralRepository>().redeemReward(test.id);
          if (!mounted) return;
          showSySnack(context, context.tr('Тест открыт!', 'Тест ачылды!'));
          AppRefresh.notifyPurchased();
        } catch (e) {
          if (mounted) {
            showSySnack(context, errorMessage(context, e), error: true);
          }
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final test = _test;
    return Scaffold(
      appBar: SyAppBar(title: test?.title ?? ''),
      body: SyCanvas(
        child: test == null
            ? (_error != null
                  ? SyStateView.error(error: _error, onRetry: _load)
                  : const SyStateView.loading())
            : _buildBody(test),
      ),
      bottomNavigationBar: test == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SyButton(
                  loading: _starting,
                  label: !test.hasAccess
                      ? context.tr('Открыть доступ', 'Мүмкүнчүлүк алуу')
                      : test.resumableAttemptId != null
                      ? context.tr('Продолжить', 'Улантуу')
                      : context.tr('Начать', 'Баштоо'),
                  icon: test.hasAccess
                      ? Icons.play_arrow_rounded
                      : Icons.lock_open_rounded,
                  onPressed: _onStart,
                ),
              ),
            ),
    );
  }

  Widget _buildBody(FullTestDetail test) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SyCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                _Stat(
                  icon: Icons.timer_outlined,
                  text: formatMinutes(context, test.totalDurationMinutes),
                ),
                const Spacer(),
                _Stat(
                  icon: Icons.format_list_bulleted_rounded,
                  text: formatQuestions(context, test.totalQuestions),
                ),
                const Spacer(),
                _Stat(
                  icon: Icons.emoji_events_outlined,
                  text: context.tr(
                    '${test.maxScore} баллов',
                    '${test.maxScore} балл',
                  ),
                ),
              ],
            ),
          ),
          if (test.bestOrtScore != null) ...[
            const SizedBox(height: 12),
            SyCard(
              color: AppColors.goldSoft,
              shadow: false,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, color: AppColors.gold),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      context.tr(
                        'Ваш лучший результат',
                        'Эң жакшы жыйынтыгыңыз',
                      ),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '${test.bestOrtScore} / ${test.maxScore}',
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (!test.hasAccess) ...[
            const SizedBox(height: 12),
            SyCard(
              color: AppColors.primarySoft,
              borderColor: AppColors.primaryBorder,
              shadow: false,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      context.tr(
                        'Тест доступен после оплаты',
                        'Тест төлөгөндөн кийин ачылат',
                      ),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          SySectionTitle(context.tr('Разделы', 'Бөлүмдөр')),
          const SizedBox(height: 10),
          for (var i = 0; i < test.sections.length; i++) ...[
            _SectionCard(
              index: i,
              section: test.sections[i],
              current:
                  test.resumableAttemptId != null &&
                  test.resumableSectionIndex == i,
            ),
            const SizedBox(height: 10),
          ],
          if (test.sections.isNotEmpty) ...[
            const SizedBox(height: 4),
            Center(
              child: TextButton.icon(
                onPressed: () => context.push('/home/tests/${test.id}'),
                icon: const Icon(Icons.fitness_center_rounded, size: 18),
                label: Text(
                  context.tr('Тренировка по разделам', 'Бөлүм боюнча машыгуу'),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _ResumeChoice { resume, restart }

enum _PurchaseAction { buyTest, buyAll, redeem, invite }

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

const _sectionIcons = [
  Icons.calculate_rounded,
  Icons.functions_rounded,
  Icons.edit_rounded,
  Icons.auto_stories_rounded,
  Icons.spellcheck_rounded,
  Icons.psychology_rounded,
];

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.index,
    required this.section,
    required this.current,
  });

  final int index;
  final FullTestSection section;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return SyCard(
      borderColor: current ? AppColors.warning : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          SyIconTile.indexed(
            index,
            _sectionIcons[index % _sectionIcons.length],
            imageUrl: section.iconUrl,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${formatMinutes(context, section.durationMinutes)} · ${formatQuestions(context, section.questionCount)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (current)
            SyBadge(
              label: context.tr('Здесь', 'Ушул жерде'),
              color: AppColors.warning,
              background: AppColors.warningSoft,
            )
          else if (section.maxScore != null)
            Text(
              context.tr('${section.maxScore} б.', '${section.maxScore} б.'),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
