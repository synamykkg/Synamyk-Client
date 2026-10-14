import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/regions/regions_repository.dart';
import 'package:synamyk/data/repositories/school/school_repository.dart';
import 'package:synamyk/domain/models/region/region_model.dart';
import 'package:synamyk/domain/models/school/school_models.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/school/widgets/school_pickers.dart';
import 'package:synamyk/utils/app_refresh.dart';

/// Pick or change the user's school: region → district → school.
/// Pops with `true` once a school was saved.
class MySchoolPage extends StatefulWidget {
  const MySchoolPage({super.key});

  @override
  State<MySchoolPage> createState() => _MySchoolPageState();
}

class _MySchoolPageState extends State<MySchoolPage> {
  MySchool? _current;
  List<Region> _regions = const [];
  Region? _region;
  District? _district;
  School? _school;
  bool _loading = true;
  bool _saving = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        GetIt.I<SchoolRepository>().getMySchool(),
        GetIt.I<RegionsRepository>().getRegions(),
      ]);
      if (!mounted) return;
      setState(() {
        _current = results[0] as MySchool?;
        _regions = results[1] as List<Region>;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _loading = false;
        });
      }
    }
  }

  Future<void> _pickRegion() async {
    final region = await showRegionPicker(context, _regions);
    if (region == null || !mounted) return;
    setState(() {
      _region = region;
      _district = null;
      _school = null;
    });
  }

  Future<void> _pickDistrict() async {
    final region = _region;
    if (region == null) return;
    final district = await showDistrictPicker(context, region.id);
    if (district == null || !mounted) return;
    setState(() {
      _district = district;
      _school = null;
    });
  }

  Future<void> _pickSchool() async {
    final district = _district;
    if (district == null) return;
    final school = await showSchoolPicker(context, district.id);
    if (school != null && mounted) setState(() => _school = school);
  }

  Future<void> _save() async {
    final school = _school;
    if (school == null) return;
    setState(() => _saving = true);
    try {
      final saved = await GetIt.I<SchoolRepository>().setMySchool(school.id);
      if (!mounted) return;
      setState(() {
        _current = saved;
        _region = null;
        _district = null;
        _school = null;
      });
      AppRefresh.notifyPurchased();
      showSySnack(context, context.tr('Школа сохранена', 'Мектеп сакталды'));
      if (context.canPop()) context.pop(true);
    } catch (e) {
      if (mounted) showSySnack(context, errorMessage(context, e), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ky = context.isKy;
    final current = _current;
    return Scaffold(
      appBar: SyAppBar(title: context.tr('Моя школа', 'Менин мектебим')),
      body: SyCanvas(
        child: _loading
            ? const SyStateView.loading()
            : _error != null
            ? SyStateView.error(error: _error, onRetry: _load)
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (current != null) ...[
                    SyCard(
                      child: Row(
                        children: [
                          const SyIconTile(
                            icon: Icons.school_rounded,
                            size: 52,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  current.schoolName,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  [
                                    current.districtName,
                                    current.regionName,
                                  ].whereType<String>().join(', '),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                current.inRating
                                    ? SyBadge.free(
                                        label: context.tr(
                                          'В рейтинге',
                                          'Рейтингде',
                                        ),
                                      )
                                    : SyBadge(
                                        icon: Icons.group_add_outlined,
                                        label: context.tr(
                                          '${current.studentCount}/${current.minStudents} учеников',
                                          '${current.studentCount}/${current.minStudents} окуучу',
                                        ),
                                        color: AppColors.warning,
                                        background: AppColors.warningSoft,
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SySectionTitle(
                      context.tr('Сменить школу', 'Мектепти алмаштыруу'),
                    ),
                  ] else
                    SySectionTitle(
                      context.tr(
                        'Выберите свою школу',
                        'Мектебиңизди тандаңыз',
                      ),
                    ),
                  const SizedBox(height: 12),
                  SySelectField(
                    label: context.tr('Регион', 'Аймак'),
                    value: _region == null
                        ? null
                        : (ky && _region!.nameKy.isNotEmpty
                              ? _region!.nameKy
                              : _region!.name),
                    onTap: _pickRegion,
                  ),
                  const SizedBox(height: 10),
                  SySelectField(
                    label: context.tr('Район', 'Район'),
                    value: _district?.localizedName(ky),
                    enabled: _region != null,
                    onTap: _pickDistrict,
                  ),
                  const SizedBox(height: 10),
                  SySelectField(
                    label: context.tr('Школа', 'Мектеп'),
                    value: _school?.localizedName(ky),
                    enabled: _district != null,
                    icon: Icons.search_rounded,
                    onTap: _pickSchool,
                  ),
                  const SizedBox(height: 20),
                  SyButton(
                    label: context.tr('Сохранить', 'Сактоо'),
                    loading: _saving,
                    onPressed: _school == null ? null : _save,
                  ),
                ],
              ),
      ),
    );
  }
}
