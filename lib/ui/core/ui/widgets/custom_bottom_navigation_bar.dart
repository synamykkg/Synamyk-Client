import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';

/// Flat white tab bar: Негизги · Рейтинг · Оюндар · Жыйынтык · Профиль.
/// Branch order must match the `StatefulShellRoute` in `router.dart`.
class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        Icons.home_outlined,
        Icons.home_rounded,
        context.tr('Главная', 'Негизги'),
      ),
      (
        Icons.bar_chart_outlined,
        Icons.bar_chart_rounded,
        context.tr('Рейтинг', 'Рейтинг'),
      ),
      (
        Icons.sports_esports_outlined,
        Icons.sports_esports_rounded,
        context.tr('Игры', 'Оюндар'),
      ),
      (
        Icons.history_rounded,
        Icons.history_rounded,
        context.tr('Итоги', 'Жыйынтык'),
      ),
      (
        Icons.person_outline_rounded,
        Icons.person_rounded,
        context.tr('Профиль', 'Профиль'),
      ),
    ];
    final current = navigationShell.currentIndex;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 68,
        margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F4A22B0),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap:
                      () => navigationShell.goBranch(
                        i,
                        initialLocation: i == current,
                      ),
                  child: _NavItem(
                    icon: i == current ? items[i].$2 : items[i].$1,
                    label: items[i].$3,
                    active: i == current,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textMuted;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
          decoration: BoxDecoration(
            gradient: active ? AppColors.headerGradient : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: active ? Colors.white : color, size: 22),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            fontSize: 11,
            color: color,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
