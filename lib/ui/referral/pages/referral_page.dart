import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';
import 'package:synamyk/data/repositories/ort_attempt/ort_attempt_repository.dart';
import 'package:synamyk/data/repositories/referral/referral_repository.dart';
import 'package:synamyk/domain/models/ort_attempt/full_test.dart';
import 'package:synamyk/domain/models/referral/referral_info.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/ort_attempt/widgets/ort_format.dart';
import 'package:synamyk/utils/app_refresh.dart';

/// «Пригласи друга»: code, share, rewards, redeem a free test.
class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  final _codeController = TextEditingController();
  ReferralInfo? _info;
  Object? _error;
  bool _applying = false;

  ReferralRepository get _repo => GetIt.I<ReferralRepository>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final info = await _repo.getMyInfo();
      if (mounted) setState(() => _info = info);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _copy(ReferralInfo info) async {
    await Clipboard.setData(ClipboardData(text: info.code));
    if (mounted) {
      showSySnack(context, context.tr('Код скопирован', 'Код көчүрүлдү'));
    }
  }

  Future<void> _share(ReferralInfo info) async {
    final link = info.inviteLink;
    var text = info.shareText.isEmpty ? info.code : info.shareText;
    if (link != null && link.isNotEmpty && !text.contains(link)) {
      text = '$text\n$link';
    }
    await SharePlus.instance.share(ShareParams(text: text));
  }

  Future<void> _apply() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    setState(() => _applying = true);
    try {
      final info = await _repo.applyCode(code);
      if (!mounted) return;
      setState(() => _info = info);
      _codeController.clear();
      showSySnack(
        context,
        context.tr('Код друга применён', 'Досуңдун коду кабыл алынды'),
      );
    } catch (e) {
      if (mounted) showSySnack(context, errorMessage(context, e), error: true);
    } finally {
      if (mounted) setState(() => _applying = false);
    }
  }

  Future<void> _redeem() async {
    final test = await showModalBottomSheet<FullTestListItem>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _LockedTestPicker(),
    );
    if (test == null || !mounted) return;
    final ok = await showSyConfirm(
      context,
      title: context.tr(
        'Открыть «${test.title}»?',
        '«${test.title}» ачасызбы?',
      ),
      message: context.tr(
        'Тест откроется бесплатно навсегда.',
        'Тест түбөлүккө акысыз ачылат.',
      ),
      confirm: context.tr('Открыть', 'Ачуу'),
    );
    if (!ok || !mounted) return;
    try {
      final info = await _repo.redeemReward(test.id);
      if (!mounted) return;
      setState(() => _info = info);
      AppRefresh.notifyPurchased();
      showSySnack(context, context.tr('Тест открыт!', 'Тест ачылды!'));
    } catch (e) {
      if (mounted) showSySnack(context, errorMessage(context, e), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = _info;
    return Scaffold(
      appBar: SyAppBar(title: context.tr('Пригласи друга', 'Досторду чакыруу')),
      body: SyCanvas(
        child: info == null
            ? (_error != null
                  ? SyStateView.error(error: _error, onRetry: _load)
                  : const SyStateView.loading())
            : RefreshIndicator(onRefresh: _load, child: _buildBody(info)),
      ),
    );
  }

  Widget _buildBody(ReferralInfo info) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.headerGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.tr(
                  'Друг купит тест — тебе откроется любой 1 тест бесплатно',
                  'Досуң тест сатып алса — сага каалаган 1 тест акысыз ачылат',
                ),
                textAlign: TextAlign.center,
                style: AppTextStyles.h4.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _copy(info),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr('Твой код', 'Сенин кодуң'),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                              Text(
                                info.code,
                                style: AppTextStyles.h2.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 4,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SyIconTile(icon: Icons.copy_rounded, size: 42),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => _share(info),
                  icon: const Icon(
                    Icons.ios_share_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    context.tr('Поделиться', 'Бөлүшүү'),
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _Counter(
                value: info.invitedCount,
                label: context.tr('Приглашено', 'Чакырылды'),
                icon: Icons.group_add_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Counter(
                value: info.purchasedCount,
                label: context.tr('Купили', 'Сатып алды'),
                icon: Icons.shopping_bag_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Counter(
                value: info.availableRewards,
                label: context.tr('Наград', 'Сыйлык'),
                icon: Icons.redeem_rounded,
                highlight: info.availableRewards > 0,
              ),
            ),
          ],
        ),
        if (info.availableRewards > 0) ...[
          const SizedBox(height: 14),
          SyButton(
            label: context.tr('Открыть тест бесплатно', 'Тестти акысыз ачуу'),
            icon: Icons.lock_open_rounded,
            onPressed: _redeem,
          ),
        ],
        if (info.canApplyCode) ...[
          const SizedBox(height: 14),
          SyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SySectionTitle(
                  context.tr('Есть код друга?', 'Досуңдун коду барбы?'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _codeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: context.tr('Код друга', 'Досуңдун коду'),
                  ),
                  onSubmitted: (_) => _apply(),
                ),
                const SizedBox(height: 10),
                SyButton(
                  label: context.tr('Применить', 'Колдонуу'),
                  style: SyButtonStyle.secondary,
                  height: 46,
                  loading: _applying,
                  onPressed: _apply,
                ),
              ],
            ),
          ),
        ] else if (info.referredByName != null) ...[
          const SizedBox(height: 14),
          SyCard(
            shadow: false,
            color: AppColors.primarySoft,
            child: Row(
              children: [
                const Icon(Icons.handshake_rounded, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.tr(
                      'Вас пригласил(а) ${info.referredByName}',
                      'Сизди ${info.referredByName} чакырды',
                    ),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        SySectionTitle(context.tr('Награды', 'Сыйлыктар')),
        const SizedBox(height: 10),
        if (info.rewards.isEmpty)
          SyCard(
            child: Text(
              context.tr(
                'Пока нет наград. Поделитесь кодом с одноклассниками!',
                'Азырынча сыйлык жок. Кодуңду классташтарың менен бөлүш!',
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        for (final reward in info.rewards) ...[
          SyCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                SyIconTile(
                  icon: reward.available
                      ? Icons.redeem_rounded
                      : Icons.check_rounded,
                  color: reward.available
                      ? AppColors.warning
                      : AppColors.success,
                  background: reward.available
                      ? AppColors.warningSoft
                      : AppColors.successSoft,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reward.friendName,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        reward.available
                            ? context.tr(
                                'Награда доступна · ${formatDate(reward.earnedAt)}',
                                'Сыйлык жеткиликтүү · ${formatDate(reward.earnedAt)}',
                              )
                            : context.tr(
                                'Открыт: ${reward.redeemedTestTitle ?? '—'}',
                                'Ачылды: ${reward.redeemedTestTitle ?? '—'}',
                              ),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.value,
    required this.label,
    required this.icon,
    this.highlight = false,
  });

  final int value;
  final String label;
  final IconData icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return SyCard(
      borderColor: highlight ? AppColors.warning : null,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: highlight ? AppColors.warning : AppColors.primary),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet listing tests the user can't open yet.
class _LockedTestPicker extends StatefulWidget {
  const _LockedTestPicker();

  @override
  State<_LockedTestPicker> createState() => _LockedTestPickerState();
}

class _LockedTestPickerState extends State<_LockedTestPicker> {
  late final Future<List<FullTestListItem>> _future =
      GetIt.I<OrtAttemptRepository>().getTests().then(
        (tests) => tests.where((t) => !t.hasAccess).toList(),
      );

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              context.tr('Выберите тест', 'Тестти тандаңыз'),
              style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<FullTestListItem>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SyStateView.error(error: snapshot.error);
                }
                final tests = snapshot.data;
                if (tests == null) return const SyStateView.loading();
                if (tests.isEmpty) {
                  return SyStateView.empty(
                    emptyText: context.tr(
                      'Все тесты уже открыты',
                      'Бардык тесттер ачык',
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: tests.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final t = tests[i];
                    return SyCard(
                      shadow: false,
                      borderColor: AppColors.divider,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      onTap: () => Navigator.of(context).pop(t),
                      child: Row(
                        children: [
                          SyIconTile(
                            icon: Icons.assignment_rounded,
                            imageUrl: t.iconUrl,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              t.title,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
