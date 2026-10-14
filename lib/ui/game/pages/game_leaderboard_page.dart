import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:synamyk/data/repositories/game/game_repository.dart';
import 'package:synamyk/domain/models/game/game_rating.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/game/pages/game_list_page.dart';

/// Game leaderboard with the user's own card on top.
class GameLeaderboardPage extends StatefulWidget {
  const GameLeaderboardPage({super.key});

  @override
  State<GameLeaderboardPage> createState() => _GameLeaderboardPageState();
}

class _GameLeaderboardPageState extends State<GameLeaderboardPage> {
  late Future<(GameRating?, List<GameRating>)> _future = _load();

  Future<(GameRating?, List<GameRating>)> _load() async {
    final repo = GetIt.I<GameRepository>();
    final meFuture = repo.getMyRating().then<GameRating?>(
      (r) => r,
      onError: (_) => null,
    );
    final board = await repo.getLeaderboard();
    return (await meFuture, board.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SyAppBar(title: context.tr('Лидеры игр', 'Оюн лидерлери')),
      body: SyCanvas(
        child: FutureBuilder<(GameRating?, List<GameRating>)>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return SyStateView.error(
                error: snapshot.error,
                onRetry: () => setState(() => _future = _load()),
              );
            }
            final data = snapshot.data;
            if (data == null) return const SyStateView.loading();
            final (me, players) = data;
            return RefreshIndicator(
              onRefresh: () async {
                setState(() => _future = _load());
                await _future;
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (me != null) ...[
                    GameRatingCard(rating: me),
                    const SizedBox(height: 16),
                  ],
                  for (var i = 0; i < players.length; i++) ...[
                    _LeaderRow(
                      player: players[i],
                      position: players[i].rank ?? i + 1,
                      isMe:
                          me?.userId != null && players[i].userId == me?.userId,
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LeaderRow extends StatelessWidget {
  const _LeaderRow({
    required this.player,
    required this.position,
    required this.isMe,
  });

  final GameRating player;
  final int position;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final (leagueColor, leagueIcon) = GameRatingCard.leagueStyle(player.league);
    final medal = switch (position) {
      1 => AppColors.gold,
      2 => const Color(0xFF9AA5B1),
      3 => const Color(0xFFCD7F32),
      _ => null,
    };
    return SyCard(
      color: isMe ? AppColors.primarySoft : Colors.white,
      borderColor: isMe ? AppColors.primary : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: medal != null
                ? Icon(Icons.workspace_premium_rounded, color: medal, size: 26)
                : Text(
                    '$position',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primarySoft,
            backgroundImage: player.avatarUrl != null
                ? NetworkImage(player.avatarUrl!)
                : null,
            child: player.avatarUrl == null
                ? const Icon(Icons.person_rounded, color: AppColors.primary)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Icon(leagueIcon, size: 14, color: leagueColor),
                    const SizedBox(width: 4),
                    Text(
                      player.leagueName,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${player.rating}',
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
