import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synamyk/data/repositories/catalog/catalog_repository.dart';
import 'package:synamyk/data/repositories/notifications/notifications_repository.dart';
import 'package:synamyk/data/repositories/ort_attempt/ort_attempt_repository.dart';
import 'package:synamyk/data/repositories/user/user_repository.dart';
import 'package:synamyk/domain/models/catalog/catalog_models.dart';
import 'package:synamyk/domain/models/ort_attempt/full_test.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/ort_attempt/widgets/ort_format.dart';
import 'package:synamyk/utils/app_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _bannerDismissedKey = 'home_all_tests_banner_dismissed';

  int _tab = 0;
  String? _firstName;
  List<FullTestListItem>? _tests;
  AppConfigModel? _config;
  ProductModel? _allTests;
  Object? _error;
  bool _bannerDismissed = true;

  /// When [_config] was fetched — the countdown ticks locally from there.
  DateTime _configLoadedAt = DateTime.now();
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _load();
    AppRefresh.accessVersion.addListener(_load);
    GetIt.I<UserRepository>().getUser().then((user) {
      if (mounted && user != null) setState(() => _firstName = user.firstName);
    }, onError: (_) {});
    SharedPreferences.getInstance().then((prefs) {
      if (mounted) {
        setState(
          () => _bannerDismissed = prefs.getBool(_bannerDismissedKey) ?? false,
        );
      }
    }, onError: (_) {});
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    AppRefresh.accessVersion.removeListener(_load);
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final catalog = GetIt.I<CatalogRepository>();
    // Config and products are decorations — their failure must not hide
    // the tests list.
    final configFuture = catalog.getAppConfig().then<AppConfigModel?>(
      (c) => c,
      onError: (_) => null,
    );
    final productsFuture = catalog.getProducts().then<List<ProductModel>>(
      (p) => p,
      onError: (_) => const <ProductModel>[],
    );
    try {
      final tests = await GetIt.I<OrtAttemptRepository>().getTests();
      final config = await configFuture;
      final products = await productsFuture;
      if (!mounted) return;
      setState(() {
        _tests = tests;
        _config = config;
        _configLoadedAt = DateTime.now();
        _allTests =
            products.where((p) => p.code == ProductCodes.allTests).firstOrNull;
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _dismissBanner() async {
    setState(() => _bannerDismissed = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_bannerDismissedKey, true);
    } catch (_) {}
  }

  int? get _secondsToExam {
    final seconds = _config?.secondsUntilExam;
    if (seconds == null || _config?.ortExamDate == null) return null;
    return seconds - DateTime.now().difference(_configLoadedAt).inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    final tests = _tests;
    final best = tests
        ?.map((t) => t.bestOrtScore)
        .whereType<int>()
        .fold<int?>(null, (a, b) => a == null || b > a ? b : a);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            _HomeHeader(
              firstName: _firstName,
              bestScore: best,
              maxScore: tests?.firstOrNull?.maxScore ?? 245,
              secondsToExam: _secondsToExam,
              tab: _tab,
              onTab: (i) => setState(() => _tab = i),
            ),
            Expanded(
              child: IndexedStack(
                index: _tab,
                children: [
                  _TestsTab(
                    tests: tests,
                    error: _error,
                    allTests: _allTests,
                    bannerDismissed: _bannerDismissed,
                    onDismissBanner: _dismissBanner,
                    onRefresh: _load,
                    onRetry: () {
                      setState(() => _error = null);
                      _load();
                    },
                  ),
                  const _TextsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rounded brand header: greeting, score ring + ОРТ countdown, pill tabs.
class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.firstName,
    required this.bestScore,
    required this.maxScore,
    required this.secondsToExam,
    required this.tab,
    required this.onTab,
  });

  final String? firstName;
  final int? bestScore;
  final int maxScore;
  final int? secondsToExam;
  final int tab;
  final ValueChanged<int> onTab;

  @override
  Widget build(BuildContext context) {
    final seconds = secondsToExam;
    final days = seconds == null ? null : (seconds / 86400).ceil().clamp(0, 9999);
    final white70 = Colors.white.withValues(alpha: 0.75);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      child: Stack(
        children: [
          const Positioned.fill(child: SyHeaderBackground()),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              firstName == null || firstName!.isEmpty
                                  ? context.tr('Привет! 👋', 'Салам! 👋')
                                  : context.tr('Привет, $firstName 👋', 'Салам, $firstName 👋'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.h3.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              context.tr('Готовимся к ОРТ вместе', 'ЖРТга бирге даярданабыз'),
                              style: AppTextStyles.bodyMedium.copyWith(color: white70),
                            ),
                          ],
                        ),
                      ),
                      const _NotificationsBellButton(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                      ),
                      child: Row(
                        children: [
                          _ScoreRing(score: bestScore, maxScore: maxScore),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bestScore == null
                                      ? context.tr('Пройди первый тест', 'Биринчи тестти тапшыр')
                                      : context.tr('Лучший балл ОРТ', 'Эң жакшы ЖРТ баллы'),
                                  style: AppTextStyles.bodySmall.copyWith(color: white70),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  bestScore == null
                                      ? context.tr('Узнай свой балл', 'Баллыңды бил')
                                      : context.tr('$bestScore из $maxScore', '$maxScore баллдан $bestScore'),
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (days != null) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.event_rounded, size: 14, color: AppColors.primary),
                                        const SizedBox(width: 4),
                                        Text(
                                          days == 0
                                              ? context.tr('ОРТ уже прошёл', 'ЖРТ өттү')
                                              : context.tr('До ОРТ $days дн.', 'ЖРТга $days күн'),
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SyHeaderTabs(
                      labels: [context.tr('Тесты', 'Тесттер'), context.tr('Тексты', 'Тексттер')],
                      selected: tab,
                      onSelected: onTab,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Best ОРТ score as a ring; a dashed-looking empty ring before any attempt.
class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.score, required this.maxScore});

  final int? score;
  final int maxScore;

  @override
  Widget build(BuildContext context) {
    final value = score == null || maxScore == 0 ? 0.0 : score! / maxScore;
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder:
                  (_, v, _) => CircularProgressIndicator(
                    value: v,
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                    color: const Color(0xFF5EEAD4),
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                  ),
            ),
          ),
          score == null
              ? const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 26)
              : Text(
                '$score',
                style: AppTextStyles.h4.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
              ),
        ],
      ),
    );
  }
}

// ─── Тесттер ────────────────────────────────────────────────

class _TestsTab extends StatelessWidget {
  const _TestsTab({
    required this.tests,
    required this.error,
    required this.allTests,
    required this.bannerDismissed,
    required this.onDismissBanner,
    required this.onRefresh,
    required this.onRetry,
  });

  final List<FullTestListItem>? tests;
  final Object? error;
  final ProductModel? allTests;
  final bool bannerDismissed;
  final VoidCallback onDismissBanner;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final tests = this.tests;
    if (tests == null) {
      return error != null
          ? SyStateView.error(error: error, onRetry: onRetry)
          : const SyStateView.loading();
    }
    final allTests = this.allTests;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          if (allTests != null && allTests.canBuy && !bannerDismissed) ...[
            _UnlockBanner(
              text: context.tr(
                'Откройте все тесты одним платежом',
                'Бир жолку төлөм менен бардык тесттерди ачыңыз',
              ),
              button: context.tr('Открыть тесты', 'Тесттерди ачуу'),
              onTap: () => context.push('/product/${ProductCodes.allTests}'),
              onClose: onDismissBanner,
            ),
            const SizedBox(height: 12),
          ],
          if (tests.isEmpty)
            SyStateView.empty(
              emptyText: context.tr('Тестов пока нет', 'Азырынча тесттер жок'),
            ),
          for (final test in tests) ...[
            _TestCard(
              test: test,
              onTap: () => context.push('/tests/${test.id}'),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

/// «🔒 Бир жолку төлөм менен…» + CTA, optionally dismissible.
class _UnlockBanner extends StatelessWidget {
  const _UnlockBanner({
    required this.text,
    required this.button,
    required this.onTap,
    this.onClose,
  });

  final String text;
  final String button;
  final VoidCallback onTap;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return SyCard(
      color: AppColors.primarySoft,
      borderColor: AppColors.primaryBorder,
      shadow: false,
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.lock_open_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (onClose != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: onClose,
                )
              else
                const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SyButton(
              label: button,
              icon: Icons.lock_open_rounded,
              height: 48,
              onPressed: onTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _TestCard extends StatelessWidget {
  const _TestCard({required this.test, required this.onTap});

  final FullTestListItem test;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Widget? badge = test.isFree
        ? SyBadge.free(label: context.tr('Бесплатно', 'Акысыз'))
        : test.hasAccess
        ? null
        : SyBadge.premium(label: context.tr('Премиум', 'Премиум'));
    final showDescription =
        test.description.isNotEmpty && test.description != test.title;

    return SyCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: test.hasAccess ? AppColors.headerGradient : null,
              color: test.hasAccess ? null : const Color(0xFFF1EEF8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              test.hasAccess ? Icons.auto_stories_rounded : Icons.lock_rounded,
              color: test.hasAccess ? Colors.white : AppColors.textMuted,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        test.title,
                        style: AppTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (badge != null) ...[const SizedBox(width: 8), badge],
                  ],
                ),
                if (showDescription) ...[
                  const SizedBox(height: 2),
                  Text(
                    test.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 14,
                  runSpacing: 4,
                  children: [
                    _Meta(
                      icon: Icons.schedule_rounded,
                      text: formatHoursMinutes(
                        context,
                        test.totalDurationMinutes,
                      ),
                    ),
                    if (test.totalQuestions > 0)
                      _Meta(
                        icon: Icons.format_list_bulleted_rounded,
                        text: formatQuestions(context, test.totalQuestions),
                      ),
                  ],
                ),
                if (test.bestOrtScore != null ||
                    test.resumableAttemptId != null) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      if (test.resumableAttemptId != null)
                        SyBadge(
                          icon: Icons.play_arrow_rounded,
                          label: context.tr('Продолжить', 'Улантуу'),
                          color: AppColors.warning,
                          background: AppColors.warningSoft,
                        ),
                      if (test.bestOrtScore != null)
                        SyBadge(
                          icon: Icons.emoji_events_rounded,
                          label: '${test.bestOrtScore} / ${test.maxScore}',
                          color: const Color(0xFFB7791F),
                          background: AppColors.goldSoft,
                        ),
                    ],
                  ),
                  if (test.bestOrtScore != null && test.maxScore > 0) ...[
                    const SizedBox(height: 10),
                    SyProgressBar(
                      value: test.bestOrtScore! / test.maxScore,
                      color: AppColors.success,
                      height: 5,
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─── Тексттер ───────────────────────────────────────────────

class _TextsTab extends StatefulWidget {
  const _TextsTab();

  @override
  State<_TextsTab> createState() => _TextsTabState();
}

class _TextsTabState extends State<_TextsTab> {
  List<ReadingTextItem>? _texts;
  ProductModel? _allTexts;
  Object? _error;

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
    final catalog = GetIt.I<CatalogRepository>();
    final productsFuture = catalog.getProducts().then<List<ProductModel>>(
      (p) => p,
      onError: (_) => const <ProductModel>[],
    );
    try {
      final texts = await catalog.getTexts();
      final products = await productsFuture;
      if (!mounted) return;
      setState(() {
        _texts = texts;
        _allTexts = products
            .where((p) => p.code == ProductCodes.allTexts)
            .firstOrNull;
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = _texts;
    if (texts == null) {
      return _error != null
          ? SyStateView.error(
              error: _error,
              onRetry: () {
                setState(() => _error = null);
                _load();
              },
            )
          : const SyStateView.loading();
    }
    final allTexts = _allTexts;
    final anyLocked = texts.any((t) => !t.hasAccess);

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          if (allTexts != null && allTexts.canBuy && anyLocked) ...[
            _UnlockBanner(
              text: context.tr(
                'Откройте все тексты для чтения одним платежом',
                'Бир жолку төлөм менен бардык окуу тексттерин ачыңыз',
              ),
              button: context.tr('Открыть тексты', 'Тексттерди ачуу'),
              onTap: () => context.push('/product/${ProductCodes.allTexts}'),
            ),
            const SizedBox(height: 12),
          ],
          if (texts.isEmpty)
            SyStateView.empty(
              emptyText: context.tr(
                'Текстов пока нет',
                'Азырынча тексттер жок',
              ),
              icon: Icons.menu_book_outlined,
            ),
          for (final text in texts) ...[
            SyCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              onTap: () => context.push(
                text.hasAccess
                    ? '/texts/${text.id}'
                    : '/product/${ProductCodes.allTexts}',
              ),
              child: Row(
                children: [
                  const SyIconTile(icon: Icons.menu_book_rounded),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      text.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (text.hasPdf && text.hasAccess)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.picture_as_pdf_outlined,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                    ),
                  Icon(
                    text.hasAccess
                        ? Icons.chevron_right_rounded
                        : Icons.lock_outline_rounded,
                    color: text.hasAccess
                        ? AppColors.textMuted
                        : AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _NotificationsBellButton extends StatefulWidget {
  const _NotificationsBellButton();

  @override
  State<_NotificationsBellButton> createState() =>
      _NotificationsBellButtonState();
}

class _NotificationsBellButtonState extends State<_NotificationsBellButton> {
  late Future<int> _unreadCount;

  @override
  void initState() {
    super.initState();
    _unreadCount = GetIt.I<NotificationsRepository>().getUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _unreadCount,
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return IconButton(
          icon: Badge(
            isLabelVisible: count > 0,
            label: Text('$count'),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
          ),
          onPressed: () => context.push('/notifications'),
        );
      },
    );
  }
}
