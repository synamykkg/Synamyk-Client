import 'package:flutter/material.dart';
import 'package:synamyk/domain/enums/region.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/auth/widgets/show_modal_bottom_sheet_regions.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';

enum SelectOptionForDateType { period, subject }

class SelectOptionForDate extends StatelessWidget {
  const SelectOptionForDate({
    super.key,
    this.value,
    required this.items,
    required this.onChanged,
    required this.type,
    this.selectedIndex,
  });

  final String? value;
  final List<String> items;
  final ValueChanged<int> onChanged;
  final int? selectedIndex;
  final SelectOptionForDateType type;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return SizedBox(
      width: type == SelectOptionForDateType.period ? 113 : 23,
      height: 45,
      child: GestureDetector(
        onTap: () async {
          final result = await showModalBottomSheet<int>(
            backgroundColor: Colors.white,
            context: context,
            builder: (context) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: Text(
                        l10n.selectOption,
                        // textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      // decoration: BoxDecoration(color: Colors.white),
                      // padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(items.length, (index) {
                            final isSelected = selectedIndex == index;
                            return ListTile(
                              trailing: Container(
                                width: 23,
                                height: 23,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF6F6F6),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: isSelected ? 5 : 1,
                                    color: const Color.fromARGB(
                                      255,
                                      147,
                                      37,
                                      167,
                                    ),
                                  ),
                                ),
                              ),
                              leading: Text(
                                items[index],
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context, index);
                              },
                            );
                          }),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );

          if (result != null) {
            onChanged(result);
          }
        },
        child:
            type == SelectOptionForDateType.period
                ? InputDecorator(
                  decoration: InputDecoration(
                    isDense: true,
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    labelStyle: const TextStyle(color: Colors.amber),
                  ),
                  child: Text(
                    value ?? l10n.selectOption,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
                : const Icon(Icons.align_horizontal_right),
      ),
    );
  }
}
