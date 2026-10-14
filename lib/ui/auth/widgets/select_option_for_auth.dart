import 'package:flutter/material.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/domain/enums/region.dart';
import 'package:synamyk/domain/models/region/region_model.dart';
import 'package:synamyk/ui/auth/widgets/show_modal_bottom_sheet_regions.dart';

class SelectOptionForAuth extends StatelessWidget {
  const SelectOptionForAuth({
    super.key,
    this.value,
    required this.region,
    required this.items,
    required this.onChanged,
    required this.label,
  });

  final String? value;
  final List<Region> items;
  final ValueChanged<int?> onChanged;
  final String label;
  final Region? region;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        child: GestureDetector(
          onTap: () {
            ShowModalBottomSheetRegions(
              items: items,
              onChanged: onChanged,
              region: region,
            ).show(context);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              isDense: true,
              suffixIcon: const Icon(Icons.expand_more_rounded),
              labelStyle: const TextStyle(color: AppColors.textMuted),
              labelText: label,
            ),
            child: Text(
              value ?? 'Выберите опцию',
              style: TextStyle(
                color: value == null
                    ? AppColors.textMuted
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
