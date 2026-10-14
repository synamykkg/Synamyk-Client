import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:synamyk/data/repositories/game/game_repository.dart';
import 'package:synamyk/domain/models/game/game_history_entry.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/game/widgets/game_motion.dart';

class GameHistoryPage extends StatefulWidget {
  const GameHistoryPage({super.key});

  @override
  State<GameHistoryPage> createState() => _GameHistoryPageState();
}

class _GameHistoryPageState extends State<GameHistoryPage> {
  late Future<List<GameHistoryEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = GetIt.I<GameRepository>().getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SyAppBar(title: context.tr('История игр', 'Оюндардын тарыхы')),
      body: SyCanvas(
        child: FutureBuilder<List<GameHistoryEntry>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SyStateView.loading();
            }
            if (snapshot.hasError) {
              return SyStateView.error(
                error: snapshot.error,
                onRetry: () => setState(
                  () => _future = GetIt.I<GameRepository>().getHistory(),
                ),
              );
            }

            final entries = snapshot.data ?? [];
            if (entries.isEmpty) {
              return SyStateView.empty(
                icon: Icons.sports_esports_outlined,
                emptyText: context.tr(
                  'Вы ещё не сыграли ни одной игры',
                  'Сиз азырынча бир да оюн ойной элексиз',
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) => FadeSlideIn(
                delay: Duration(milliseconds: 40 * index),
                child: _HistoryTile(entry: entries[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry});

  final GameHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String badgeText;
    if (entry.forfeited) {
      color = entry.won ? AppColors.success : AppColors.textMuted;
      badgeText = entry.won
          ? context.tr('Соперник сдался', 'Атаандаш берилди')
          : context.tr('Сдался', 'Берилди');
    } else if (entry.draw) {
      color = AppColors.textMuted;
      badgeText = context.tr('Ничья', 'Тең');
    } else if (entry.won) {
      color = AppColors.success;
      badgeText = context.tr('Победа', 'Жеңиш');
    } else {
      color = AppColors.danger;
      badgeText = context.tr('Поражение', 'Жеңилүү');
    }
    final change = entry.ratingChange;

    return SyCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primarySoft,
            backgroundImage: entry.opponentAvatar != null
                ? NetworkImage(entry.opponentAvatar!)
                : null,
            child: entry.vsBot
                ? const Icon(Icons.smart_toy_rounded, color: AppColors.primary)
                : entry.opponentAvatar == null
                ? const Icon(Icons.person_rounded, color: AppColors.primary)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.gameTestTitle,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'vs ${entry.vsBot ? context.tr('Бот', 'Бот') : entry.opponentName}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                SyBadge(
                  label: badgeText,
                  color: color,
                  background: color.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.score} : ${entry.opponentScore}',
                style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
              ),
              if (change != null)
                Text(
                  '${change > 0
                      ? '+'
                      : change < 0
                      ? '−'
                      : ''}${change.abs()}${entry.ratingAfter != null ? ' · ${entry.ratingAfter}' : ''}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: change > 0
                        ? AppColors.success
                        : change < 0
                        ? AppColors.danger
                        : AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
