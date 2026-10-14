import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';

/// «Жыйынтык» tab: finished tests, analytics and video lessons.
class AnalystTabsShell extends StatelessWidget {
  const AnalystTabsShell({super.key, required this.child});

  final Widget child;

  static const _paths = ['/results', '/analyst', '/analyst/video_lessons'];

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final location = GoRouterState.of(context).uri.path;
    final selected = _paths.indexOf(location).clamp(0, _paths.length - 1);
    return Scaffold(
      appBar: SyAppBar(
        title: context.tr('Итоги', 'Жыйынтык'),
        showBack: false,
        bottom: SyHeaderTabs(
          labels: [
            context.tr('Тесты', 'Тесттер'),
            l10n.tabAnalytics,
            l10n.tabVideoLessons,
          ],
          selected: selected,
          onSelected: (i) => context.go(_paths[i]),
        ),
      ),
      body: SyCanvas(child: child),
    );
  }
}
