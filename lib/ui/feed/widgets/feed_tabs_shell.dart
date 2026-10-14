import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';

/// «Рейтинг» tab: ratings and news.
class FeedTabsShell extends StatelessWidget {
  const FeedTabsShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selected = location == '/feed/news' ? 1 : 0;
    return Scaffold(
      appBar: SyAppBar(
        title: context.tr('Рейтинг', 'Рейтинг'),
        showBack: false,
        bottom: SyHeaderTabs(
          labels: [
            context.tr('Рейтинг', 'Рейтинг'),
            context.tr('Новости', 'Жаңылыктар'),
          ],
          selected: selected,
          onSelected:
              (i) => context.go(i == 0 ? '/feed/rating' : '/feed/news'),
        ),
      ),
      body: SyCanvas(child: child),
    );
  }
}
