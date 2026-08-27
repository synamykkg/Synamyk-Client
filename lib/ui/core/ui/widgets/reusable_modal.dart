import 'package:flutter/material.dart';

/// Переиспользуемый модальный виджет с поддержкой Sliver-виджетов
class ReusableModal extends StatelessWidget {
  final String title;
  final List<Widget> slivers;
  final double heightFactor;

  const ReusableModal({
    super.key,
    required this.title,
    required this.slivers,
    this.heightFactor = 0.8,
  });

  /// Показать модальное окно
  static void show({
    required BuildContext context,
    required String title,
    required List<Widget> slivers,
    double heightFactor = 0.8,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => ReusableModal(
            title: title,
            slivers: slivers,
            heightFactor: heightFactor,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      widthFactor: 1.0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Content with Slivers
            Expanded(child: CustomScrollView(slivers: slivers)),
          ],
        ),
      ),
    );
  }
}
