import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/game/game_repository.dart';
import 'package:synamyk/data/repositories/school/school_repository.dart';
import 'package:synamyk/domain/models/game/game_rating.dart';
import 'package:synamyk/domain/models/school/school_models.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/utils/app_refresh.dart';

/// «Рейтинг»: schools of my district, districts, students, games.
class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int _view = 0;

  @override
  Widget build(BuildContext context) {
    final labels = [
      (Icons.school_rounded, context.tr('Школы', 'Мектептер')),
      (Icons.map_rounded, context.tr('Районы', 'Райондор')),
      (Icons.person_rounded, context.tr('Ученики', 'Окуучулар')),
      (Icons.sports_esports_rounded, context.tr('Игры', 'Оюндар')),
    ];
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            itemCount: labels.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final selected = i == _view;
              return ChoiceChip(
                selected: selected,
                showCheckmark: false,
                avatar: Icon(
                  labels[i].$1,
                  size: 18,
                  color: selected ? Colors.white : AppColors.primary,
                ),
                label: Text(labels[i].$2),
                labelStyle: AppTextStyles.bodyMedium.copyWith(
                  color: selected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: selected ? AppColors.primary : AppColors.divider,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (_) => setState(() => _view = i),
              );
            },
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _view,
            children: const [
              _SchoolsView(),
              _DistrictsView(),
              _StudentsView(),
              _GamesView(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Loads [load] once, reloads on pull-to-refresh and on [AppRefresh].
abstract class _LoaderState<W extends StatefulWidget, T> extends State<W> {
  T? data;
  Object? error;

  Future<T> load();

  @override
  void initState() {
    super.initState();
    reload();
    AppRefresh.accessVersion.addListener(reload);
  }

  @override
  void dispose() {
    AppRefresh.accessVersion.removeListener(reload);
    super.dispose();
  }

  Future<void> reload() async {
    try {
      final value = await load();
      if (mounted) {
        setState(() {
          data = value;
          error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => error = e);
    }
  }

  Widget buildData(BuildContext context, T data);

  Widget buildError(BuildContext context, Object error) => SyStateView.error(
    error: error,
    onRetry: () {
      setState(() => this.error = null);
      reload();
    },
  );

  @override
  Widget build(BuildContext context) {
    final value = data;
    if (value == null) {
      return error != null
          ? buildError(context, error!)
          : const SyStateView.loading();
    }
    return RefreshIndicator(
      onRefresh: reload,
      child: buildData(context, value),
    );
  }
}

// ─── Schools ────────────────────────────────────────────────

class _SchoolsView extends StatefulWidget {
  const _SchoolsView();

  @override
  State<_SchoolsView> createState() => _SchoolsViewState();
}

class _SchoolsViewState extends _LoaderState<_SchoolsView, SchoolRating> {
  SchoolRatingSort _sort = SchoolRatingSort.score;

  @override
  Future<SchoolRating> load() =>
      GetIt.I<SchoolRepository>().getSchoolRating(sort: _sort);

  void _setSort(SchoolRatingSort sort) {
    if (sort == _sort) return;
    setState(() {
      _sort = sort;
      data = null;
    });
    reload();
  }

  Future<void> _chooseSchool() async {
    await context.push('/profile/school');
    if (!mounted) return;
    setState(() {
      error = null;
      data = null;
    });
    reload();
  }

  @override
  Widget buildError(BuildContext context, Object error) {
    // 400 — the user hasn't picked a school, so there's no district to rank.
    if (error is AppException && error.type == ExceptionType.validation) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SyCard(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SyIconTile(icon: Icons.school_rounded, size: 64),
                const SizedBox(height: 14),
                Text(
                  context.tr('Выберите свою школу', 'Мектебиңизди тандаңыз'),
                  style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  context.tr(
                    'Чтобы увидеть рейтинг школ своего района',
                    'Районуңуздагы мектептердин рейтингин көрүү үчүн',
                  ),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                SyButton(
                  label: context.tr('Выбрать школу', 'Мектеп тандоо'),
                  icon: Icons.search_rounded,
                  onPressed: _chooseSchool,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return super.buildError(context, error);
  }

  @override
  Widget buildData(BuildContext context, SchoolRating rating) {
    final my = rating.mySchool;
    final unit = switch (_sort) {
      SchoolRatingSort.score => context.tr('балл', 'балл'),
      SchoolRatingSort.activity => context.tr('тестов', 'тест'),
      SchoolRatingSort.growth => context.tr('балл', 'балл'),
    };
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          rating.districtName,
          style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          context.tr(
            'Соревнование только начинается — будь среди первых!',
            'Мелдеш жаңы башталууда — биринчилерден бол!',
          ),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (my != null && !my.inRating) ...[
          const SizedBox(height: 14),
          SyCard(
            color: AppColors.primarySoft,
            borderColor: AppColors.primaryBorder,
            shadow: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.tr(
                    'До рейтинга: ${my.studentCount}/${my.minStudents} учеников',
                    'Рейтингге кирүүгө: ${my.studentCount}/${my.minStudents} окуучу',
                  ),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                SyProgressBar(
                  value: my.minStudents == 0
                      ? 0
                      : my.studentCount / my.minStudents,
                  color: AppColors.warning,
                  height: 8,
                ),
                const SizedBox(height: 10),
                Text(
                  context.tr(
                    'Нужно ещё ${my.studentsNeeded} одноклассника — пригласи и добавь школу в рейтинг!',
                    'Дагы ${my.studentsNeeded} классташың керек — чакырып, мектебиңди рейтингге кошуп кой!',
                  ),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                SyButton(
                  label: context.tr('Пригласить друзей', 'Досторду чакыруу'),
                  icon: Icons.person_add_alt_1_rounded,
                  height: 48,
                  onPressed: () => context.push('/referrals'),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 14),
        SySegmented(
          labels: [
            context.tr('Баллы', 'Упай'),
            context.tr('Активность', 'Активдүүлүк'),
            context.tr('Рост', 'Өсүш'),
          ],
          selected: _sort.index,
          onSelected: (i) => _setSort(SchoolRatingSort.values[i]),
        ),
        const SizedBox(height: 12),
        if (rating.entries.isEmpty)
          SyStateView.empty(
            emptyText: context.tr('Школ пока нет', 'Азырынча мектептер жок'),
          ),
        for (final e in rating.entries) ...[
          _RankRow(
            rank: e.rank,
            highlighted: e.isMine,
            dimmed: !e.inRating,
            title: e.name,
            leadingIcon: Icons.groups_rounded,
            trailing: e.inRating && e.value != null
                ? _ValueText(
                    '${_sort == SchoolRatingSort.growth && e.value! > 0 ? '+' : ''}${_fmt(e.value!)} $unit',
                  )
                : Text(
                    context.tr(
                      '${e.studentCount}/${rating.minStudents} уч.',
                      '${e.studentCount}/${rating.minStudents} окуучу',
                    ),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
            bottom: e.inRating
                ? null
                : SyProgressBar(
                    value: rating.minStudents == 0
                        ? 0
                        : e.studentCount / rating.minStudents,
                    color: AppColors.warning,
                    height: 5,
                  ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

String _fmt(double v) =>
    v == v.roundToDouble() ? '${v.toInt()}' : v.toStringAsFixed(1);

// ─── Districts ──────────────────────────────────────────────

class _DistrictsView extends StatefulWidget {
  const _DistrictsView();

  @override
  State<_DistrictsView> createState() => _DistrictsViewState();
}

class _DistrictsViewState extends _LoaderState<_DistrictsView, DistrictRating> {
  @override
  Future<DistrictRating> load() =>
      GetIt.I<SchoolRepository>().getDistrictRating();

  @override
  Widget buildData(BuildContext context, DistrictRating rating) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (rating.regionName != null) ...[
          Text(
            rating.regionName!,
            style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            context.tr(
              'Средний лучший балл ОРТ учеников района',
              'Райондогу окуучулардын орточо эң жакшы ЖРТ баллы',
            ),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
        ],
        if (rating.entries.isEmpty)
          SyStateView.empty(
            emptyText: context.tr('Пока нет данных', 'Азырынча маалымат жок'),
          ),
        for (final e in rating.entries) ...[
          _RankRow(
            rank: e.rank,
            highlighted: e.isMine,
            title: e.name,
            subtitle: context.tr(
              '${e.studentsWithResults} учеников с результатами',
              '${e.studentsWithResults} окуучунун жыйынтыгы бар',
            ),
            leadingIcon: Icons.location_city_rounded,
            trailing: _ValueText(
              e.averageScore == null
                  ? '—'
                  : '${_fmt(e.averageScore!)} ${context.tr('б.', 'б.')}',
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

// ─── Students ───────────────────────────────────────────────

class _StudentsView extends StatefulWidget {
  const _StudentsView();

  @override
  State<_StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends _LoaderState<_StudentsView, StudentRating> {
  StudentRatingScope _scope = StudentRatingScope.school;

  @override
  Future<StudentRating> load() =>
      GetIt.I<SchoolRepository>().getStudentRating(_scope);

  void _setScope(StudentRatingScope scope) {
    if (scope == _scope) return;
    setState(() {
      _scope = scope;
      data = null;
    });
    reload();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: SySegmented(
            labels: [
              context.tr('Школа', 'Мектеп'),
              context.tr('Район', 'Район'),
              context.tr('Регион', 'Аймак'),
              context.tr('Все', 'Баары'),
            ],
            selected: _scope.index,
            onSelected: (i) => _setScope(StudentRatingScope.values[i]),
          ),
        ),
        Expanded(child: super.build(context)),
      ],
    );
  }

  @override
  Widget buildData(BuildContext context, StudentRating rating) {
    final me = rating.me;
    final meInList = rating.entries.any((e) => e.isMe);
    return Column(
      children: [
        Expanded(
          child: rating.entries.isEmpty
              ? ListView(
                  children: [
                    const SizedBox(height: 60),
                    SyStateView.empty(
                      emptyText: context.tr(
                        'Пока нет результатов',
                        'Азырынча жыйынтык жок',
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: rating.entries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) =>
                      _studentRow(context, rating.entries[i]),
                ),
        ),
        if (me != null && !meInList)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x141E3A5F),
                  blurRadius: 12,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: _studentRow(context, me),
          ),
      ],
    );
  }

  Widget _studentRow(BuildContext context, StudentRatingEntry e) {
    return _RankRow(
      rank: e.rank,
      highlighted: e.isMe,
      title: e.isMe ? '${e.fullName} (${context.tr('вы', 'сиз')})' : e.fullName,
      subtitle: e.schoolName,
      avatarUrl: e.avatarUrl,
      leadingIcon: Icons.person_rounded,
      trailing: _ValueText(
        e.score == null ? '—' : '${e.score} ${context.tr('б.', 'б.')}',
      ),
    );
  }
}

// ─── Games ──────────────────────────────────────────────────

class _GamesView extends StatefulWidget {
  const _GamesView();

  @override
  State<_GamesView> createState() => _GamesViewState();
}

class _GamesViewState extends _LoaderState<_GamesView, List<GameRating>> {
  @override
  Future<List<GameRating>> load() async =>
      (await GetIt.I<GameRepository>().getLeaderboard()).content;

  @override
  Widget buildData(BuildContext context, List<GameRating> players) {
    if (players.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 60),
          SyStateView.empty(
            icon: Icons.sports_esports_outlined,
            emptyText: context.tr(
              'Сыграйте первую дуэль!',
              'Биринчи дуэлди ойноңуз!',
            ),
          ),
        ],
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: players.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final p = players[i];
        return _RankRow(
          rank: p.rank ?? i + 1,
          title: p.fullName,
          subtitle: p.leagueName,
          avatarUrl: p.avatarUrl,
          leadingIcon: Icons.person_rounded,
          trailing: _ValueText('${p.rating}'),
        );
      },
    );
  }
}

// ─── shared rows ────────────────────────────────────────────

class _ValueText extends StatelessWidget {
  const _ValueText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.rank,
    required this.title,
    required this.leadingIcon,
    required this.trailing,
    this.subtitle,
    this.highlighted = false,
    this.dimmed = false,
    this.avatarUrl,
    this.bottom,
  });

  final int? rank;
  final String title;
  final String? subtitle;
  final IconData leadingIcon;
  final Widget trailing;
  final bool highlighted;
  final bool dimmed;
  final String? avatarUrl;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final medal = switch (rank) {
      1 => AppColors.gold,
      2 => const Color(0xFF9AA5B1),
      3 => const Color(0xFFCD7F32),
      _ => null,
    };
    return SyCard(
      color: highlighted ? AppColors.primarySoft : Colors.white,
      borderColor: highlighted ? AppColors.primary : null,
      shadow: !highlighted,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: rank == null
                ? null
                : medal != null
                ? Icon(Icons.workspace_premium_rounded, color: medal, size: 26)
                : Text(
                    '$rank',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          _Avatar(url: avatarUrl, icon: leadingIcon, dimmed: dimmed),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: dimmed ? AppColors.textMuted : AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                if (bottom != null) ...[const SizedBox(height: 6), bottom!],
              ],
            ),
          ),
          const SizedBox(width: 10),
          trailing,
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.icon, required this.dimmed});

  final String? url;
  final IconData icon;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final fallback = CircleAvatar(
      radius: 20,
      backgroundColor: dimmed ? const Color(0xFFF1F5F9) : AppColors.primarySoft,
      child: Icon(
        icon,
        size: 20,
        color: dimmed ? AppColors.textMuted : AppColors.primary,
      ),
    );
    if (url == null || url!.isEmpty) return fallback;
    return ClipOval(
      child: Image.network(
        url!,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}
