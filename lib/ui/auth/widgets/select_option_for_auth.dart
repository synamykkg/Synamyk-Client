import 'package:flutter/material.dart';
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
    return SizedBox(
      width: 350,
      height: 45,
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
            suffixIcon: const Icon(Icons.arrow_drop_down),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            labelStyle: const TextStyle(color: Colors.grey),
            labelText: 'text',
          ),
          child: Text(value ?? 'Выберите опцию'),
        ),
      ),
    );
  }
}
