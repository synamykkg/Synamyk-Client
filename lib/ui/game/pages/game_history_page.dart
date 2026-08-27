import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/game/game_repository.dart';
import 'package:synamyk/domain/models/game/game_history_entry.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
            onPressed: () => context.pop(),
          ),
          title: Text('История игр', style: AppTextStyles.appBarTitle),
          centerTitle: true,
        ),
        body: FutureBuilder<List<GameHistoryEntry>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Не удалось загрузить историю игр',
                  style: AppTextStyles.bodyMedium,
                ),
              );
            }

            final entries = snapshot.data ?? [];
            if (entries.isEmpty) {
              return Center(
                child: Text('Вы ещё не сыграли ни одной игры', style: AppTextStyles.bodyMedium),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: entries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder:
                  (context, index) => FadeSlideIn(
                    delay: Duration(milliseconds: 50 * index),
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
    final Color badgeColor;
    final String badgeText;
    if (entry.forfeited) {
      badgeColor = const Color(0xFFB3B3B3);
      badgeText = entry.won ? 'Соперник сдался' : 'Сдался';
    } else if (entry.draw) {
      badgeColor = const Color(0xFFB3B3B3);
      badgeText = 'Ничья';
    } else if (entry.won) {
      badgeColor = Colors.green;
      badgeText = 'Победа';
    } else {
      badgeColor = Colors.red;
      badgeText = 'Поражение';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF8F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFE0D0EC),
            backgroundImage:
                entry.opponentAvatar != null
                    ? NetworkImage(entry.opponentAvatar!)
                    : null,
            child:
                entry.vsBot
                    ? const Icon(Icons.smart_toy, color: Color(0xFF7B1FA2))
                    : entry.opponentAvatar == null
                    ? const Icon(Icons.person, color: Color(0xFF7B1FA2))
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.gameTestTitle, style: AppTextStyles.testCardTitle),
                const SizedBox(height: 2),
                Text(
                  'vs ${entry.vsBot ? 'Бот' : entry.opponentName}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF808080),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText,
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${entry.score} : ${entry.opponentScore}',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
