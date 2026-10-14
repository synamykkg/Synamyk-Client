import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/ort_attempt/ort_attempt_repository.dart';
import 'package:synamyk/domain/models/ort_attempt/attempt_result.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/ort_attempt/widgets/ort_format.dart';
import 'package:synamyk/utils/app_refresh.dart';

/// «Жыйынтык» tab: finished whole-test attempts, newest first.
class AttemptHistoryPage extends StatefulWidget {
  const AttemptHistoryPage({super.key});

  @override
  State<AttemptHistoryPage> createState() => _AttemptHistoryPageState();
}

class _AttemptHistoryPageState extends State<AttemptHistoryPage> {
  final _items = <AttemptHistoryItem>[];
  final _scroll = ScrollController();
  bool _loading = true;
  bool _loadingMore = false;
  bool _last = false;
  int _page = 0;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _reload();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 400) _loadMore();
    });
    AppRefresh.accessVersion.addListener(_reload);
  }

  @override
  void dispose() {
    AppRefresh.accessVersion.removeListener(_reload);
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = _items.isEmpty;
      _error = null;
    });
    try {
      final page = await GetIt.I<OrtAttemptRepository>().getHistory();
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(page.content);
        _page = 0;
        _last = page.last;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _last || _loading) return;
    setState(() => _loadingMore = true);
    try {
      final page = await GetIt.I<OrtAttemptRepository>().getHistory(
        page: _page + 1,
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(page.content);
        _page = page.number;
        _last = page.last;
      });
    } catch (_) {
      // Scrolling again retries.
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SyStateView.loading();
    if (_error != null && _items.isEmpty) {
      return SyStateView.error(error: _error, onRetry: _reload);
    }
    if (_items.isEmpty) {
      return RefreshIndicator(
        onRefresh: _reload,
        child: ListView(
          children: [
            const SizedBox(height: 80),
            SyStateView.empty(
              icon: Icons.emoji_events_outlined,
              emptyText: context.tr(
                'Пройдите тест целиком — здесь появится ваш балл ОРТ',
                'Тестти толук тапшырыңыз — бул жерде ЖРТ баллыңыз чыгат',
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.separated(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: _items.length + (_loadingMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          if (i >= _items.length) {
            return const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final item = _items[i];
          final score = item.ortScore;
          final ratio = score == null || item.maxScore == 0
              ? 0.0
              : score / item.maxScore;
          return SyCard(
            onTap: () => context.push('/attempts/${item.attemptId}/result'),
            child: Row(
              children: [
                SizedBox(
                  width: 58,
                  height: 58,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: ratio,
                          strokeWidth: 5,
                          backgroundColor: AppColors.primarySoft,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Text(
                        '${score ?? '—'}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.testTitle,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        [
                          context.tr(
                            'из ${item.maxScore}',
                            '${item.maxScore} баллдан',
                          ),
                          formatPercent(item.percentage),
                          formatDate(item.completedAt),
                        ].where((s) => s.isNotEmpty).join(' · '),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
