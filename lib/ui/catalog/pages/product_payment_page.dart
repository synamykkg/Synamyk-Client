import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:synamyk/data/repositories/catalog/catalog_repository.dart';
import 'package:synamyk/data/repositories/payment/payment_repository.dart';
import 'package:synamyk/domain/models/catalog/catalog_models.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/ui/ort_attempt/widgets/ort_format.dart';
import 'package:synamyk/ui/payment/models/payment_confirm_args.dart';
import 'package:synamyk/ui/payment/pages/finik_payment_page.dart';

/// «Төлөм» for a catalog product (`ALL_TESTS` / `ALL_TEXTS`).
class ProductPaymentPage extends StatefulWidget {
  const ProductPaymentPage({super.key, required this.code});

  final String code;

  @override
  State<ProductPaymentPage> createState() => _ProductPaymentPageState();
}

class _ProductPaymentPageState extends State<ProductPaymentPage> {
  ProductModel? _product;
  Object? _error;
  bool _paying = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final product = await GetIt.I<CatalogRepository>().getProduct(
        widget.code,
      );
      if (mounted) setState(() => _product = product);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _pay(ProductModel product) async {
    setState(() => _paying = true);
    try {
      final info = await GetIt.I<PaymentRepository>().initPaymentForProduct(
        product.code,
      );
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FinikPaymentPage(
            paymentInfo: info,
            confirmArgs: PaymentConfirmArgs(
              target: PaymentTarget.product,
              productCode: product.code,
              testTitle: product.title,
              price: product.price,
              language: '',
              returnLocation: '/home',
            ),
          ),
        ),
      );
    } catch (e) {
      if (mounted) showSySnack(context, errorMessage(context, e), error: true);
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = _product;
    return Scaffold(
      appBar: SyAppBar(title: context.tr('Оплата', 'Төлөм')),
      body: SyCanvas(
        child: product == null
            ? (_error != null
                  ? SyStateView.error(error: _error, onRetry: _load)
                  : const SyStateView.loading())
            : _buildBody(product),
      ),
    );
  }

  Widget _buildBody(ProductModel product) {
    final isTexts = product.code == ProductCodes.allTexts;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        Center(
          child: Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: AppColors.cardShadow,
            ),
            child: Icon(
              isTexts ? Icons.auto_stories_rounded : Icons.emoji_events_rounded,
              size: 56,
              color: isTexts ? AppColors.primary : AppColors.gold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          product.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
        ),
        if (product.description.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            product.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: 20),
        SyCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('Разовый платёж', 'Бир жолку төлөм'),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatSom(product.price),
                    style: AppTextStyles.displayLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (product.oldPrice != null &&
                      product.oldPrice! > product.price) ...[
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        formatSom(product.oldPrice!),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textMuted,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: SyBadge(
                        label:
                            '−${(100 - product.price / product.oldPrice! * 100).round()}%',
                        color: AppColors.danger,
                        background: AppColors.dangerSoft,
                      ),
                    ),
                  ],
                ],
              ),
              if (product.features.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Divider(height: 1),
                ),
                for (final feature in product.features)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            feature,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (product.owned)
          SyCard(
            color: AppColors.successSoft,
            shadow: false,
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: AppColors.success),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.tr(
                      'У вас уже есть этот доступ',
                      'Бул мүмкүнчүлүк сизде бар',
                    ),
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          SyButton(
            label: context.tr('Перейти к оплате', 'Төлөмгө өтүү'),
            icon: Icons.lock_open_rounded,
            loading: _paying,
            onPressed: product.available ? () => _pay(product) : null,
          ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shield_outlined,
              size: 16,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              context.tr(
                'Безопасная оплата · QR, банковские приложения, VISA',
                'Коопсуз төлөм · QR, банк тиркемелери, VISA',
              ),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
