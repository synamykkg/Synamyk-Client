import 'package:flutter/material.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:synamyk/data/repositories/notifications/notifications_repository.dart';
import 'package:synamyk/domain/models/notifications/user_notification_entry.dart';
import 'package:synamyk/routing/notification_routing.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/game/widgets/game_motion.dart';

class NotificationsInboxPage extends StatefulWidget {
  const NotificationsInboxPage({super.key});

  @override
  State<NotificationsInboxPage> createState() =>
      _NotificationsInboxPageState();
}

class _NotificationsInboxPageState extends State<NotificationsInboxPage> {
  static const _pageSize = 20;

  final List<UserNotificationEntry> _entries = [];
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
      final page = await GetIt.I<NotificationsRepository>().getInbox(
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

  Future<void> _markAllRead() async {
    try {
      await GetIt.I<NotificationsRepository>().markAllRead();
      setState(() {
        for (var i = 0; i < _entries.length; i++) {
          if (!_entries[i].read) {
            _entries[i] = UserNotificationEntry(
              id: _entries[i].id,
              title: _entries[i].title,
              body: _entries[i].body,
              dataType: _entries[i].dataType,
              dataEntityId: _entries[i].dataEntityId,
              read: true,
              createdAt: _entries[i].createdAt,
            );
          }
        }
      });
    } catch (_) {
      // Best-effort — leave state as-is on failure.
    }
  }

  void _onTapEntry(int index) {
    final entry = _entries[index];
    if (!entry.read) {
      GetIt.I<NotificationsRepository>().markRead(entry.id);
      setState(() {
        _entries[index] = UserNotificationEntry(
          id: entry.id,
          title: entry.title,
          body: entry.body,
          dataType: entry.dataType,
          dataEntityId: entry.dataEntityId,
          read: true,
          createdAt: entry.createdAt,
        );
      });
    }
    navigateForNotificationData(
      GoRouter.of(context),
      entry.dataType,
      entry.dataEntityId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: SyAppBar(
          title: 'Уведомления',
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white54,
              ),
              onPressed: _entries.any((e) => !e.read) ? _markAllRead : null,
              child: const Text('Прочитать все'),
            ),
          ],
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
          'Не удалось загрузить уведомления',
          style: AppTextStyles.bodyMedium,
        ),
      );
    }
    if (_entries.isEmpty) {
      return Center(
        child: Text('Уведомлений пока нет', style: AppTextStyles.bodyMedium),
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
          child: GestureDetector(
            onTap: () => _onTapEntry(index),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    entry.read
                        ? const Color(0xFFF6F6F6)
                        : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  if (!entry.read)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6D35E0),
                        shape: BoxShape.circle,
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.title, style: AppTextStyles.testCardTitle),
                        const SizedBox(height: 4),
                        Text(entry.body, style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat(
                            'dd.MM.yyyy HH:mm',
                          ).format(entry.createdAt),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: const Color(0xFF808080),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
