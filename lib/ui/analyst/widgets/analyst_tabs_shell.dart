import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/generated/l10n.dart';

class AnalystTabsShell extends StatelessWidget {
  const AnalystTabsShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final String location = GoRouterState.of(context).uri.toString();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0,
            title: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  _TabItem(
                    title: l10n.tabAnalytics,
                    isActive: location == '/analyst',
                    onTap: () => context.go('/analyst'),
                  ),
                  _TabItem(
                    title: l10n.tabVideoLessons,
                    isActive: location == '/analyst/video_lessons',
                    onTap: () => context.go('/analyst/video_lessons'),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(hasScrollBody: false, child: child),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                title,
                style: TextStyle(
                  color: isActive ? const Color(0xFF8A2BE2) : Colors.grey[400],
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF8A2BE2) : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
