import 'package:flutter/material.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';
import 'package:synamyk/domain/enums/attempt_status.dart';
import 'package:synamyk/domain/models/ort_test/sub_test_attempt_entry.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/game/widgets/game_motion.dart';

class SubTestHistoryPage extends StatefulWidget {
  const SubTestHistoryPage({
    super.key,
    required this.subTestId,
    required this.testId,
  });

  final int subTestId;

  /// Null when reached via a push deep-link, which only carries the
  /// subTestId — see the "known limitation" note in the integration plan.
  final String? testId;

  @override
  State<SubTestHistoryPage> createState() => _SubTestHistoryPageState();
}

class _SubTestHistoryPageState extends State<SubTestHistoryPage> {
  static const _pageSize = 20;

  final List<SubTestAttemptEntry> _entries = [];
  final ScrollController _scrollController = ScrollController();

  bool _initialLoading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  bool _hasError = false;
  int _nextPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadNextPage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _loadingMore || _initialLoading) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadNextPage();
    }
  }

  Future<void> _loadNextPage() async {
    setState(() {
      if (_entries.isEmpty) {
        _initialLoading = true;
      } else {
        _loadingMore = true;
      }
      _hasError = false;
    });

    try {
      final page = await GetIt.I<OrtTestsRepository>().getSubTestHistory(
        widget.subTestId,
        page: _nextPage,
        size: _pageSize,
      );
      setState(() {
        _entries.addAll(page.content);
        _hasMore = !page.last;
        _nextPage = page.number + 1;
      });
    } catch (_) {
      setState(() => _hasError = true);
    } finally {
      setState(() {
        _initialLoading = false;
        _loadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: SyAppBar(
          title: 'История прохождений',
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_initialLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasError && _entries.isEmpty) {
      return Center(
        child: Text(
          'Не удалось загрузить историю попыток',
          style: AppTextStyles.bodyMedium,
        ),
      );
    }
    if (_entries.isEmpty) {
      return Center(
        child: Text(
          'Вы ещё не проходили этот тест',
          style: AppTextStyles.bodyMedium,
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: _entries.length + (_hasMore ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index >= _entries.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final entry = _entries[index];
        return FadeSlideIn(
          delay: Duration(milliseconds: 50 * index),
          child: _AttemptTile(
            entry: entry,
            onTap:
                entry.isCompleted
                    ? () => context.push(
                      '/sessions/${entry.sessionId}/result',
                      extra: {
                        'testId': widget.testId ?? '',
                        'subTestId': widget.subTestId,
                      },
                    )
                    : null,
          ),
        );
      },
    );
  }
}

class _AttemptTile extends StatelessWidget {
  const _AttemptTile({required this.entry, required this.onTap});

  final SubTestAttemptEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
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
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(entry.startedAt),
                    style: AppTextStyles.testCardTitle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Баллы: ${entry.earnedPoints}',
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
