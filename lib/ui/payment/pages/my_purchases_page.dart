import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:synamyk/data/repositories/payment/payment_repository.dart';
import 'package:synamyk/domain/enums/payment_status.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/domain/models/payment/payment_history_entry.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/game/widgets/game_motion.dart';
import 'package:synamyk/ui/payment/models/payment_confirm_args.dart';
import 'package:synamyk/ui/payment/pages/finik_payment_page.dart';
import 'package:synamyk/utils/app_messenger.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPurchasesPage extends StatefulWidget {
  const MyPurchasesPage({super.key});

  @override
  State<MyPurchasesPage> createState() => _MyPurchasesPageState();
}

class _MyPurchasesPageState extends State<MyPurchasesPage> {
  static const _pageSize = 20;

  final List<PaymentHistoryEntry> _entries = [];
  final ScrollController _scrollController = ScrollController();

  bool _initialLoading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  bool _hasError = false;
  int _nextPage = 0;
  String? _payingId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadNextPage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _loadingMore || _initialLoading) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadNextPage();
    }
  }

  Future<void> _loadNextPage() async {
    setState(() {
      if (_entries.isEmpty) {
        _initialLoading = true;
      } else {
        _loadingMore = true;
      }
      _hasError = false;
    });

    try {
      final page = await GetIt.I<PaymentRepository>().getMyPayments(
        page: _nextPage,
        size: _pageSize,
      );
      setState(() {
        _entries.addAll(page.content);
        _hasMore = !page.last;
        _nextPage = page.number + 1;
      });
    } catch (_) {
      setState(() => _hasError = true);
    } finally {
      setState(() {
        _initialLoading = false;
        _loadingMore = false;
      });
    }
  }

  Future<void> _pay(PaymentHistoryEntry entry) async {
    if (entry.paymentUrl != null) {
      final uri = Uri.tryParse(entry.paymentUrl!);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }

    setState(() => _payingId = entry.paymentId);
    try {
      final repository = GetIt.I<PaymentRepository>();
      final isSubTestPurchase = entry.subTestId != null;
      final paymentInfo =
          isSubTestPurchase
              ? await repository.initPaymentForSubTest(entry.subTestId!)
              : await repository.initPaymentForTest(entry.testId);
      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => FinikPaymentPage(
                paymentInfo: paymentInfo,
                confirmArgs: PaymentConfirmArgs(
                  target:
                      isSubTestPurchase
                          ? PaymentTarget.subTest
                          : PaymentTarget.test,
                  testId: entry.testId,
                  subTestId: entry.subTestId,
                  testTitle: entry.testTitle,
                  subTestTitle: entry.subTestTitle,
                  price: entry.amount,
                  language: entry.testId.toString(),
                ),
              ),
        ),
      );
    } on AppException catch (e) {
      if (!mounted) return;
      AppMessenger.showError(context, e.message ?? 'Не удалось начать оплату');
    } catch (_) {
      if (!mounted) return;
      AppMessenger.showError(context, 'Не удалось начать оплату');
    } finally {
      if (mounted) setState(() => _payingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
            onPressed: () => context.pop(),
          ),
          title: Text('Мои покупки', style: AppTextStyles.appBarTitle),
          centerTitle: true,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_initialLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasError && _entries.isEmpty) {
      return Center(
        child: Text(
          'Не удалось загрузить покупки',
          style: AppTextStyles.bodyMedium,
        ),
      );
    }
    if (_entries.isEmpty) {
      return Center(
        child: Text('У вас пока нет покупок', style: AppTextStyles.bodyMedium),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: _entries.length + (_hasMore ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index >= _entries.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final entry = _entries[index];
        return FadeSlideIn(
          delay: Duration(milliseconds: 30 * index),
          child: _PurchaseTile(
            entry: entry,
            isPaying: _payingId == entry.paymentId,
            onPay: () => _pay(entry),
            onOpenTest:
                () => context.push('/home/tests/${entry.testId}'),
          ),
        );
      },
    );
  }
}

class _PurchaseTile extends StatelessWidget {
  const _PurchaseTile({
    required this.entry,
    required this.isPaying,
    required this.onPay,
    required this.onOpenTest,
  });

  final PaymentHistoryEntry entry;
  final bool isPaying;
  final VoidCallback onPay;
  final VoidCallback onOpenTest;

  @override
  Widget build(BuildContext context) {
    final Color badgeColor;
    final String badgeText;
    switch (entry.status) {
      case PaymentStatus.completed:
        badgeColor = Colors.green;
        badgeText = 'Оплачено';
      case PaymentStatus.pending:
        badgeColor = Colors.orange;
        badgeText = 'Ожидает оплаты';
      case PaymentStatus.expired:
        badgeColor = const Color(0xFFB3B3B3);
        badgeText = 'Истёк';
      case PaymentStatus.cancelled:
        badgeColor = const Color(0xFFB3B3B3);
        badgeText = 'Отменён';
      case PaymentStatus.unknown:
        badgeColor = const Color(0xFFB3B3B3);
        badgeText = '—';
    }

    return GestureDetector(
      onTap: entry.status == PaymentStatus.completed ? onOpenTest : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEDF8F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.subTestId != null
                        ? (entry.subTestTitle ?? entry.testTitle)
                        : entry.testTitle,
                    style: AppTextStyles.testCardTitle,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              entry.subTestId != null ? 'Подтест' : 'Полный доступ',
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFF7B1FA2),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${entry.amount.toStringAsFixed(0)} сом · ${DateFormat('dd.MM.yyyy HH:mm').format(entry.createdAt)}',
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFF808080),
              ),
            ),
            if (entry.receiptNumber != null) ...[
              const SizedBox(height: 2),
              Text(
                'Чек: ${entry.receiptNumber}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFF808080),
                ),
              ),
            ],
            if (entry.status == PaymentStatus.pending) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: isPaying ? null : onPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B1FA2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      isPaying
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            'Оплатить',
                            style: TextStyle(color: Colors.white),
                          ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
