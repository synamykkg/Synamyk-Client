import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:synamyk/data/repositories/home/home_repository.dart';
import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';
import 'package:synamyk/domain/enums/attempt_status.dart';
import 'package:synamyk/domain/models/home/subject_tests.dart';
import 'package:synamyk/domain/models/ort_test/sub_test_attempt_entry.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/game/widgets/game_motion.dart';

class _AttemptFeedItem {
  _AttemptFeedItem({
    required this.testId,
    required this.testTitle,
    required this.subTestId,
    required this.subTestTitle,
    required this.entry,
  });

  final String testId;
  final String testTitle;
  final String subTestId;
  final String subTestTitle;
  final SubTestAttemptEntry entry;
}

/// Entry point for "История тестов" from Profile: a single flat feed of
/// every attempt across every test/sub-test, newest first — merged
/// client-side since the backend only exposes history per sub-test.
class TestsHistoryPage extends StatefulWidget {
  const TestsHistoryPage({super.key});

  @override
  State<TestsHistoryPage> createState() => _TestsHistoryPageState();
}

class _TestsHistoryPageState extends State<TestsHistoryPage> {
  late Future<List<_AttemptFeedItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadFeed();
  }

  Future<List<_AttemptFeedItem>> _loadFeed() async {
    final homeRepository = GetIt.I<HomeRepository>();
    final ortTestsRepository = GetIt.I<OrtTestsRepository>();

    final subjects = await homeRepository.getHomeSubjectsList();
    final items = <_AttemptFeedItem>[];

    for (final subject in subjects) {
      final List<SubjectTests> subTests;
      try {
        subTests = (await homeRepository.getSubjectTests(subject.id)).testsList;
      } catch (_) {
        continue;
      }

      for (final subTest in subTests) {
        if (subTest.attemptsCount <= 0) continue;
        try {
          final subTestId = int.parse(subTest.id);
          var page = 0;
          while (true) {
            final result = await ortTestsRepository.getSubTestHistory(
              subTestId,
              page: page,
              size: 50,
            );
            for (final entry in result.content) {
              items.add(
                _AttemptFeedItem(
                  testId: subject.id,
                  testTitle: subject.title,
                  subTestId: subTest.id,
                  subTestTitle: subTest.title,
                  entry: entry,
                ),
              );
            }
            if (result.last || result.content.isEmpty) break;
            page++;
          }
        } catch (_) {
          // Skip sub-tests whose history fails to load — the rest of the
          // feed should still render.
        }
      }
    }

    items.sort((a, b) => b.entry.startedAt.compareTo(a.entry.startedAt));
    return items;
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
          title: Text('История тестов', style: AppTextStyles.appBarTitle),
          centerTitle: true,
        ),
        body: FutureBuilder<List<_AttemptFeedItem>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Не удалось загрузить историю тестов',
                  style: AppTextStyles.bodyMedium,
                ),
              );
            }

            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return Center(
                child: Text(
                  'У вас пока нет пройденных тестов',
                  style: AppTextStyles.bodyMedium,
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return FadeSlideIn(
                  delay: Duration(milliseconds: 30 * index),
                  child: _AttemptFeedTile(
                    item: item,
                    onTap:
                        item.entry.isCompleted
                            ? () => context.push(
                              '/sessions/${item.entry.sessionId}/result',
                              extra: {
                                'testId': item.testId,
                                'subTestId': int.parse(item.subTestId),
                              },
                            )
                            : null,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _AttemptFeedTile extends StatelessWidget {
  const _AttemptFeedTile({required this.item, required this.onTap});

  final _AttemptFeedItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final entry = item.entry;
    final Color badgeColor;
    final String badgeText;
    switch (entry.status) {
      case AttemptStatus.completed:
        badgeColor = Colors.green;
        badgeText = 'Завершено';
      case AttemptStatus.inProgress:
        badgeColor = Colors.orange;
        badgeText = 'В процессе';
      case AttemptStatus.paused:
        badgeColor = Colors.orange;
        badgeText = 'Пауза';
      case AttemptStatus.abandoned:
        badgeColor = const Color(0xFFB3B3B3);
        badgeText = 'Прервано';
      case AttemptStatus.expired:
        badgeColor = const Color(0xFFB3B3B3);
        badgeText = 'Истекло';
      case AttemptStatus.unknown:
        badgeColor = const Color(0xFFB3B3B3);
        badgeText = '—';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEDF8F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.testTitle} · ${item.subTestTitle}',
                    style: AppTextStyles.testCardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(entry.startedAt),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFF808080),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Баллы: ${entry.earnedPoints}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFF808080),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text('${entry.percentage}%', style: AppTextStyles.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
