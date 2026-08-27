import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/game/game_repository.dart';
import 'package:synamyk/domain/models/game/game_test_model.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/game/widgets/game_motion.dart';

class GameListPage extends StatefulWidget {
  const GameListPage({super.key});

  @override
  State<GameListPage> createState() => _GameListPageState();
}

enum _GameFilter { unplayed, played }

class _GameListPageState extends State<GameListPage> {
  late Future<List<GameTestModel>> _future;
  _GameFilter _filter = _GameFilter.unplayed;

  @override
  void initState() {
    super.initState();
    _future = GetIt.I<GameRepository>().getGameTests(unplayedOnly: true);
  }

  void _setFilter(_GameFilter filter) {
    if (_filter == filter) return;
    setState(() {
      _filter = filter;
      _future =
          filter == _GameFilter.unplayed
              ? GetIt.I<GameRepository>().getGameTests(unplayedOnly: true)
              // The backend only supports filtering to unplayed tests —
              // "played" is filtered client-side from the full list.
              : GetIt.I<GameRepository>()
                  .getGameTests()
                  .then((tests) => tests.where((t) => t.played).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Дуэль 1×1', style: AppTextStyles.appBarTitle),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.history, color: Colors.black),
              tooltip: 'История игр',
              onPressed: () => context.push('/game/history'),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  Expanded(
                    child: _FilterChip(
                      label: 'Новые',
                      selected: _filter == _GameFilter.unplayed,
                      onTap: () => _setFilter(_GameFilter.unplayed),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FilterChip(
                      label: 'Пройденные',
                      selected: _filter == _GameFilter.played,
                      onTap: () => _setFilter(_GameFilter.played),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<GameTestModel>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Не удалось загрузить список игр',
                  style: AppTextStyles.bodyMedium,
                ),
              );
            }

            final tests = snapshot.data ?? [];
            if (tests.isEmpty) {
              return Center(
                child: Text('Пока нет доступных игр', style: AppTextStyles.bodyMedium),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: tests.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final test = tests[index];
                return FadeSlideIn(
                  delay: Duration(milliseconds: 60 * index),
                  child: HoverZoom(
                    child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF8F2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(test.title, style: AppTextStyles.h4),
                            ),
                            if (test.played)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Пройдено',
                                  style: AppTextStyles.testCardMetadata,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(test.description, style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 8),
                        Text(
                          '${test.questionsPerGame} вопросов из ${test.questionCount}',
                          style: AppTextStyles.testCardMetadata,
                        ),
                        if (test.myBestScore != null || test.playCount > 0) ...[
                          const SizedBox(height: 4),
                          Row(
                            spacing: 10,
                            children: [
                              if (test.myBestScore != null)
                                Row(
                                  spacing: 2,
                                  children: [
                                    const Icon(
                                      Icons.emoji_events,
                                      size: 15,
                                      color: Color(0xFF7B1FA2),
                                    ),
                                    Text(
                                      'Рекорд: ${test.myBestScore}',
                                      style: AppTextStyles.testCardMetadata,
                                    ),
                                  ],
                                ),
                              if (test.playCount > 0)
                                Text(
                                  'Игр: ${test.playCount}',
                                  style: AppTextStyles.testCardMetadata,
                                ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 16),
                        PressableScale(
                          onTap: () => context.push('/game/room', extra: test.id),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B1FA2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  'Играть',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
            );
          },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF7B1FA2) : const Color(0xFFEDF8F2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
