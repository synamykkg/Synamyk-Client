import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';

/// Blue gradient header used by every redesigned screen.
class SyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SyAppBar({
    super.key,
    required this.title,
    this.showBack,
    this.onBack,
    this.actions,
    this.bottom,
    this.titleWidget,
  });

  final String title;
  final Widget? titleWidget;

  /// Defaults to "can pop".
  final bool? showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + 8 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final canPop = showBack ?? Navigator.of(context).canPop();
    return AppBar(
      toolbarHeight: kToolbarHeight + 8,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: const ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
        child: SizedBox.expand(child: SyHeaderBackground()),
      ),
      titleSpacing: canPop ? 0 : 20,
      leading: canPop
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              color: Colors.white,
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      title:
          titleWidget ??
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
      actions: actions,
      bottom: bottom,
    );
  }
}

/// Underlined white tabs sitting inside [SyAppBar.bottom].
class SyHeaderTabs extends StatelessWidget implements PreferredSizeWidget {
  const SyHeaderTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 14),
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  final EdgeInsets padding;

  @override
  Size get preferredSize => Size.fromHeight(44 + padding.vertical);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelected(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: i == selected
                            ? AppColors.primary
                            : Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w600,
                      ),
                      child: Text(
                        labels[i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Header gradient with two soft light blobs, so the brand header doesn't
/// read as a flat color bar.
class SyHeaderBackground extends StatelessWidget {
  const SyHeaderBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            right: -40,
            top: -60,
            child: _Blob(size: 180, alpha: 0.10),
          ),
          Positioned(
            left: -30,
            bottom: -70,
            child: _Blob(size: 140, alpha: 0.07),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.alpha});

  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }
}

/// Soft gradient canvas behind the cards.
class SyCanvas extends StatelessWidget {
  const SyCanvas({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.canvasGradient),
      child: child,
    );
  }
}

/// White rounded card with a soft shadow; optionally tappable/highlighted.
class SyCard extends StatelessWidget {
  const SyCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.surface,
    this.borderColor,
    this.radius = 18,
    this.shadow = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color? borderColor;
  final double radius;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: borderColor != null
          ? BorderSide(color: borderColor!, width: 1.4)
          : BorderSide.none,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow ? AppColors.cardShadow : null,
      ),
      child: Material(
        color: color,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Small rounded pill: «✓ Акысыз», «🔒 Премиум», scores.
class SyBadge extends StatelessWidget {
  const SyBadge({
    super.key,
    required this.label,
    this.icon,
    this.color = AppColors.primary,
    this.background = AppColors.primarySoft,
  });

  const SyBadge.free({super.key, required this.label})
    : icon = Icons.check_circle_outline_rounded,
      color = AppColors.success,
      background = AppColors.successSoft;

  const SyBadge.premium({super.key, required this.label})
    : icon = Icons.lock_outline_rounded,
      color = AppColors.primary,
      background = AppColors.primarySoft;

  final String label;
  final IconData? icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum SyButtonStyle { primary, secondary, danger, ghost }

class SyButton extends StatelessWidget {
  const SyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.style = SyButtonStyle.primary,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final SyButtonStyle style;
  final double height;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (style) {
      SyButtonStyle.primary => (AppColors.primary, Colors.white),
      SyButtonStyle.secondary => (AppColors.primarySoft, AppColors.primary),
      SyButtonStyle.danger => (AppColors.dangerSoft, AppColors.danger),
      SyButtonStyle.ghost => (Colors.transparent, AppColors.primary),
    };
    final enabled = onPressed != null && !loading;
    final gradient = style == SyButtonStyle.primary && (enabled || loading);
    return SizedBox(
      height: height,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: gradient ? AppColors.headerGradient : null,
        ),
        child: Material(
          color: gradient
              ? Colors.transparent
              : (enabled || loading ? bg : const Color(0xFFE7E3F0)),
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: enabled ? onPressed : null,
            child: Center(
              child: loading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: fg,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            size: 20,
                            color: enabled ? fg : AppColors.textMuted,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: enabled ? fg : AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pill segmented control: «Упай / Активдүүлүк / Өсүш».
class SySegmented extends StatelessWidget {
  const SySegmented({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelected(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: i == selected ? AppColors.primary : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: i == selected
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Rounded square icon — section icons, list leading icons.
class SyIconTile extends StatelessWidget {
  const SyIconTile({
    super.key,
    required this.icon,
    this.color = AppColors.primary,
    this.background = AppColors.primarySoft,
    this.size = 44,
    this.imageUrl,
  });

  /// Deterministic color pair for the n-th item in a list.
  factory SyIconTile.indexed(int index, IconData icon, {String? imageUrl}) {
    final (color, bg) =
        AppColors.tilePalette[index % AppColors.tilePalette.length];
    return SyIconTile(
      icon: icon,
      color: color,
      background: bg,
      imageUrl: imageUrl,
    );
  }

  final IconData icon;
  final Color color;
  final Color background;
  final double size;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(icon, color: color, size: size * 0.5);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      alignment: Alignment.center,
      child: imageUrl == null || imageUrl!.isEmpty
          ? fallback
          : Padding(
              padding: EdgeInsets.all(size * 0.18),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => fallback,
              ),
            ),
    );
  }
}

class SyProgressBar extends StatelessWidget {
  const SyProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.primary,
    this.trackColor = const Color(0xFFE6EBF2),
    this.height = 6,
  });

  final double value;
  final Color color;
  final Color trackColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: value.clamp(0, 1)),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        builder: (_, v, _) => LinearProgressIndicator(
          value: v,
          minHeight: height,
          color: color,
          backgroundColor: trackColor,
        ),
      ),
    );
  }
}

class SySectionTitle extends StatelessWidget {
  const SySectionTitle(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// Loading / error-with-retry / empty placeholder.
class SyStateView extends StatelessWidget {
  const SyStateView.loading({super.key})
    : error = null,
      onRetry = null,
      emptyText = null,
      icon = null;

  const SyStateView.error({super.key, required this.error, this.onRetry})
    : emptyText = null,
      icon = Icons.cloud_off_rounded;

  const SyStateView.empty({
    super.key,
    required this.emptyText,
    this.icon = Icons.inbox_outlined,
  }) : error = null,
       onRetry = null;

  final Object? error;
  final VoidCallback? onRetry;
  final String? emptyText;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final message = emptyText ?? errorMessage(context, error);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SyIconTile(
              icon: icon!,
              size: 64,
              color: AppColors.textMuted,
              background: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: SyButton(
                  label: context.tr('Повторить', 'Кайталоо'),
                  icon: Icons.refresh_rounded,
                  style: SyButtonStyle.secondary,
                  height: 44,
                  onPressed: onRetry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The server's localized message when there is one, else a generic text.
String errorMessage(BuildContext context, Object? error) {
  if (error is AppException) {
    final msg = error.message;
    if (msg != null && msg.isNotEmpty && !msg.startsWith('DioException')) {
      return msg;
    }
    if (error.isNetworkError) {
      return context.tr(
        'Нет подключения к интернету',
        'Интернет байланышы жок',
      );
    }
  }
  return context.tr(
    'Не удалось загрузить данные',
    'Маалыматтарды жүктөө мүмкүн болгон жок',
  );
}

void showSySnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? AppColors.danger : AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
}

/// Two-button confirm dialog; resolves to `true` on confirm.
Future<bool> showSyConfirm(
  BuildContext context, {
  required String title,
  String? message,
  required String confirm,
  String? cancel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        title,
        style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
      ),
      content: message == null
          ? null
          : Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: SyButton(
                label: cancel ?? ctx.tr('Отмена', 'Жокко чыгаруу'),
                style: SyButtonStyle.secondary,
                height: 46,
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SyButton(
                label: confirm,
                style: destructive
                    ? SyButtonStyle.danger
                    : SyButtonStyle.primary,
                height: 46,
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  return result ?? false;
}
