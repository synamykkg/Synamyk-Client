import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/game/game_repository.dart';
import 'package:synamyk/domain/models/game/game_rating.dart';
import 'package:synamyk/domain/models/game/game_test_model.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/game/widgets/game_motion.dart';

class GameListPage extends StatefulWidget {
  const GameListPage({super.key});

  @override
  State<GameListPage> createState() => _GameListPageState();
}

enum _GameFilter { unplayed, played }

class _GameListPageState extends State<GameListPage> {
  late Future<List<GameTestModel>> _future;
  Future<GameRating>? _rating;
  _GameFilter _filter = _GameFilter.unplayed;

  GameRepository get _repo => GetIt.I<GameRepository>();

  @override
  void initState() {
    super.initState();
    _future = _loadTests();
    _rating = _repo.getMyRating();
  }

  Future<List<GameTestModel>> _loadTests() => _filter == _GameFilter.unplayed
      ? _repo.getGameTests(unplayedOnly: true)
      // The backend only supports filtering to unplayed tests —
      // "played" is filtered client-side from the full list.
      : _repo.getGameTests().then(
          (tests) => tests.where((t) => t.played).toList(),
        );

  void _setFilter(_GameFilter filter) {
    if (_filter == filter) return;
    setState(() {
      _filter = filter;
      _future = _loadTests();
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _loadTests();
      _rating = _repo.getMyRating();
    });
    await _future;
  }

  Future<void> _play(GameTestModel test) async {
    await context.push('/game/room', extra: test.id);
    if (mounted) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SyAppBar(
        title: context.tr('Дуэль 1×1', 'Дуэль 1×1'),
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard_rounded, color: Colors.white),
            tooltip: context.tr('Лидеры', 'Лидерлер'),
            onPressed: () => context.push('/game/leaderboard'),
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.white),
            tooltip: context.tr('История игр', 'Оюндардын тарыхы'),
            onPressed: () => context.push('/game/history'),
          ),
        ],
      ),
      body: SyCanvas(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<List<GameTestModel>>(
            future: _future,
            builder: (context, snapshot) {
              final header = <Widget>[
                FutureBuilder<GameRating>(
                  future: _rating,
                  builder: (context, s) => s.hasData
                      ? GameRatingCard(rating: s.data!)
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 14),
                SySegmented(
                  labels: [
                    context.tr('Новые', 'Жаңы'),
                    context.tr('Пройденные', 'Ойнолгон'),
                  ],
                  selected: _filter.index,
                  onSelected: (i) => _setFilter(_GameFilter.values[i]),
                ),
                const SizedBox(height: 14),
              ];

              final List<Widget> body;
              if (snapshot.connectionState != ConnectionState.done) {
                body = [
                  const SizedBox(height: 160, child: SyStateView.loading()),
                ];
              } else if (snapshot.hasError) {
                body = [
                  SyStateView.error(error: snapshot.error, onRetry: _refresh),
                ];
              } else if ((snapshot.data ?? []).isEmpty) {
                body = [
                  SyStateView.empty(
                    icon: Icons.sports_esports_outlined,
                    emptyText: context.tr(
                      'Пока нет доступных игр',
                      'Азырынча оюндар жок',
                    ),
                  ),
                ];
              } else {
                final tests = snapshot.data!;
                body = [
                  for (var i = 0; i < tests.length; i++) ...[
                    FadeSlideIn(
                      delay: Duration(milliseconds: 50 * i),
                      child: _GameCard(
                        test: tests[i],
                        onPlay: () => _play(tests[i]),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ];
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [...header, ...body],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Elo card: rating, league, progress to the next league, streak.
class GameRatingCard extends StatelessWidget {
  const GameRatingCard({super.key, required this.rating});

  final GameRating rating;

  static (Color, IconData) leagueStyle(String league) => switch (league) {
    'SILVER' => (const Color(0xFF94A3B8), Icons.shield_rounded),
    'GOLD' => (AppColors.gold, Icons.shield_rounded),
    'PLATINUM' => (const Color(0xFF22B8CF), Icons.verified_rounded),
    'DIAMOND' => (AppColors.pink, Icons.diamond_rounded),
    _ => (const Color(0xFFCD7F32), Icons.shield_outlined),
  };

  @override
  Widget build(BuildContext context) {
    final (leagueColor, leagueIcon) = leagueStyle(rating.league);
    final next = rating.nextLeagueRating;
    final progress = next == null
        ? 1.0
        : ((rating.rating - rating.leagueFloor) / (next - rating.leagueFloor))
              .clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(leagueIcon, color: leagueColor, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.leagueName.isEmpty
                          ? rating.league
                          : rating.leagueName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: rating.rating.toDouble()),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, _) => Text(
                        '${v.round()}',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (rating.rank != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      context.tr('Место', 'Орун'),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      '#${rating.rank}',
                      style: AppTextStyles.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 14),
          SyProgressBar(
            value: progress,
            color: Colors.white,
            trackColor: Colors.white.withValues(alpha: 0.25),
            height: 7,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  next == null
                      ? context.tr('Высшая лига', 'Эң жогорку лига')
                      : context.tr(
                          'До следующей лиги: ${next - rating.rating}',
                          'Кийинки лигага: ${next - rating.rating}',
                        ),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
              if (rating.winStreak >= 2)
                Text(
                  '🔥 ${rating.winStreak}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MiniStat(
                label: context.tr('Игр', 'Оюн'),
                value: rating.gamesPlayed,
              ),
              _MiniStat(
                label: context.tr('Побед', 'Жеңиш'),
                value: rating.wins,
              ),
              _MiniStat(
                label: context.tr('Поражений', 'Жеңилүү'),
                value: rating.losses,
              ),
              _MiniStat(
                label: context.tr('Ничьих', 'Тең'),
                value: rating.draws,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.test, required this.onPlay});

  final GameTestModel test;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return SyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SyIconTile(
                icon: Icons.bolt_rounded,
                color: AppColors.pink,
                background: AppColors.pinkSoft,
                size: 48,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test.title,
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (test.description.isNotEmpty) ...[
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
                  ],
                ),
              ),
              if (test.played)
                SyBadge.free(label: context.tr('Пройдено', 'Ойнолду')),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              SyBadge(
                icon: Icons.help_outline_rounded,
                label: context.tr(
                  '${test.questionsPerGame} вопросов',
                  '${test.questionsPerGame} суроо',
                ),
                color: AppColors.textSecondary,
                background: const Color(0xFFF1F5F9),
              ),
              if (test.myBestScore != null)
                SyBadge(
                  icon: Icons.emoji_events_rounded,
                  label: context.tr(
                    'Рекорд: ${test.myBestScore}',
                    'Рекорд: ${test.myBestScore}',
                  ),
                  color: const Color(0xFFB7791F),
                  background: AppColors.goldSoft,
                ),
              if (test.playCount > 0)
                SyBadge(
                  icon: Icons.replay_rounded,
                  label: context.tr(
                    'Игр: ${test.playCount}',
                    'Оюн: ${test.playCount}',
                  ),
                  color: AppColors.textSecondary,
                  background: const Color(0xFFF1F5F9),
                ),
            ],
          ),
          const SizedBox(height: 14),
          SyButton(
            label: context.tr('Играть', 'Ойноо'),
            icon: Icons.play_arrow_rounded,
            height: 48,
            onPressed: onPlay,
          ),
        ],
      ),
    );
  }
}
