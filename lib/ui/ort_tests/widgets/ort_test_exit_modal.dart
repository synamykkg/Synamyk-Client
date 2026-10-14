import 'package:flutter/material.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';

class OrtTestExitModal extends StatelessWidget {
  const OrtTestExitModal({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.onDismiss,
    required this.title,
    required this.subTitle,
    required this.confirmText,
    required this.cancelText,
  });
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onDismiss;

  final String title;
  final String subTitle;
  final String confirmText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return PopScope(
      canPop: false, // перехватываем кнопку назад
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onDismiss(); // ✅ кнопка назад Android
          Navigator.pop(context);
        }
      },

      child: Dialog(
        child: Container(
          width: 308,
          // height: 41,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // l10n.exitTestTitle,
                title,
                style: AppTextStyles.h2,
              ),
              SizedBox(height: 8),

              Text(
                // l10n.exitTestMessage,
                subTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      width: 130,
                      height: 48,
                      child: Center(
                        child: Text(
                          // l10n.exitTestConfirm,
                          confirmText,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Color(0xFF6D35E0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      width: 130,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFF6D35E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          // l10n.exitTestCancel,
                          cancelText,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
