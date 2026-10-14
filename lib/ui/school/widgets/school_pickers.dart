import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:synamyk/data/repositories/school/school_repository.dart';
import 'package:synamyk/domain/models/region/region_model.dart';
import 'package:synamyk/domain/models/school/school_models.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';

/// Tappable read-only field that opens a picker.
class SySelectField extends StatelessWidget {
  const SySelectField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.icon = Icons.expand_more_rounded,
    this.enabled = true,
  });

  final String label;
  final String? value;
  final VoidCallback onTap;
  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.divider),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasValue ? value! : context.tr('Выберите', 'Тандаңыз'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: hasValue
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(icon, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<Region?> showRegionPicker(BuildContext context, List<Region> regions) {
  return _showListPicker<Region>(
    context,
    title: context.tr('Регион', 'Аймак'),
    load: () async => regions,
    label: (r) => context.isKy && r.nameKy.isNotEmpty ? r.nameKy : r.name,
  );
}

Future<District?> showDistrictPicker(BuildContext context, int regionId) {
  final ky = context.isKy;
  return _showListPicker<District>(
    context,
    title: context.tr('Район', 'Район'),
    load: () => GetIt.I<SchoolRepository>().getDistricts(regionId),
    label: (d) => d.localizedName(ky),
  );
}

Future<T?> _showListPicker<T>(
  BuildContext context, {
  required String title,
  required Future<List<T>> Function() load,
  required String Function(T) label,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => FractionallySizedBox(
      heightFactor: 0.75,
      child: _PickerScaffold(
        title: title,
        child: FutureBuilder<List<T>>(
          future: load(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              return SyStateView.error(error: snapshot.error);
            }
            final items = snapshot.data;
            if (items == null) return const SyStateView.loading();
            if (items.isEmpty) {
              return SyStateView.empty(
                emptyText: ctx.tr('Список пуст', 'Тизме бош'),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
              itemCount: items.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (ctx, i) => ListTile(
                title: Text(label(items[i]), style: AppTextStyles.bodyLarge),
                onTap: () => Navigator.of(ctx).pop(items[i]),
              ),
            );
          },
        ),
      ),
    ),
  );
}

Future<School?> showSchoolPicker(BuildContext context, int districtId) {
  return showModalBottomSheet<School>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => FractionallySizedBox(
      heightFactor: 0.9,
      child: _SchoolSearch(districtId: districtId),
    ),
  );
}

class _PickerScaffold extends StatelessWidget {
  const _PickerScaffold({
    required this.title,
    required this.child,
    this.header,
  });

  final String title;
  final Widget child;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(
            title,
            style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        ?header,
        Expanded(child: child),
      ],
    );
  }
}

class _SchoolSearch extends StatefulWidget {
  const _SchoolSearch({required this.districtId});

  final int districtId;

  @override
  State<_SchoolSearch> createState() => _SchoolSearchState();
}

class _SchoolSearchState extends State<_SchoolSearch> {
  Timer? _debounce;
  List<School>? _schools;
  Object? _error;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(query));
  }

  Future<void> _search(String query) async {
    final id = ++_requestId;
    setState(() => _error = null);
    try {
      final page = await GetIt.I<SchoolRepository>().getSchools(
        widget.districtId,
        search: query,
      );
      // Drop responses for superseded queries.
      if (mounted && id == _requestId) setState(() => _schools = page.content);
    } catch (e) {
      if (mounted && id == _requestId) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ky = context.isKy;
    final schools = _schools;
    return _PickerScaffold(
      title: context.tr('Школа', 'Мектеп'),
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: TextField(
          autofocus: false,
          onChanged: _onChanged,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded),
            hintText: context.tr('Поиск по названию', 'Аты боюнча издөө'),
          ),
        ),
      ),
      child: _error != null
          ? SyStateView.error(error: _error)
          : schools == null
          ? const SyStateView.loading()
          : schools.isEmpty
          ? SyStateView.empty(
              emptyText: context.tr('Школы не найдены', 'Мектеп табылган жок'),
            )
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(
                8,
                0,
                8,
                24 + MediaQuery.of(context).viewInsets.bottom,
              ),
              itemCount: schools.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (ctx, i) => ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(
                  schools[i].localizedName(ky),
                  style: AppTextStyles.bodyLarge,
                ),
                onTap: () => Navigator.of(ctx).pop(schools[i]),
              ),
            ),
    );
  }
}
