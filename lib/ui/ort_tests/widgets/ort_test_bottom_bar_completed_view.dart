import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';

class OrtTestBottomBarCompletedView extends StatelessWidget {
  const OrtTestBottomBarCompletedView({
    super.key,
    required this.language,
    required this.id,
  });

  final String language;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SyButton(
            label: context.tr('На главную', 'Башкы бет'),
            icon: Icons.home_outlined,
            style: SyButtonStyle.secondary,
            onPressed: () => context.go('/home'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SyButton(
            label: context.tr('Ещё раз', 'Кайталоо'),
            icon: Icons.replay_rounded,
            onPressed: () => context.go('/ort_test/$language/$id'),
          ),
        ),
      ],
    );
  }
}
