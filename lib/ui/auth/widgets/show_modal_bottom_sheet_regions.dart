import 'package:flutter/material.dart';
import 'package:synamyk/domain/enums/region.dart';
import 'package:synamyk/domain/models/region/region_model.dart';

class ShowModalBottomSheetRegions {
  const ShowModalBottomSheetRegions({
    required this.items,
    required this.onChanged,
    this.region,
  });

  final ValueChanged<int?> onChanged;
  final List<Region> items;
  final Region? region;

  void show(BuildContext context) {
    final selectedIndex = items.indexWhere((item) => item.id == region?.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        if (items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return RadioListTile<int>(
                  title: Text(items[index].name),
                  value: index,
                  groupValue: selectedIndex == -1 ? null : selectedIndex,
                  onChanged: onChanged,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
