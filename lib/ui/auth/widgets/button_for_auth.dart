import 'package:flutter/material.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';

class ButtonForAuth extends StatelessWidget {
  const ButtonForAuth({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    required this.textColor,
    this.isLoading = false,
    required this.isValid,
  });

  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final bool isLoading;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    final background = isValid ? color : const Color(0xFFDDE3EC);
    final foreground = isValid ? textColor : AppColors.textMuted;
    return Center(
      child: SizedBox(
        width: 350,
        height: 52,
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: isLoading ? null : onTap,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(foreground),
                      ),
                    )
                  : Text(
                      text,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: foreground,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
