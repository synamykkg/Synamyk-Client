import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/payment/payment_repository.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/ui/auth/widgets/button_for_auth.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/payment/models/payment_confirm_args.dart';
import 'package:synamyk/ui/payment/pages/finik_payment_page.dart';
import 'package:synamyk/utils/app_messenger.dart';

class PaymentConfirmPage extends StatefulWidget {
  const PaymentConfirmPage({super.key, required this.args});

  final PaymentConfirmArgs args;

  @override
  State<PaymentConfirmPage> createState() => _PaymentConfirmPageState();
}

class _PaymentConfirmPageState extends State<PaymentConfirmPage> {
  bool _isLoading = false;

  Future<void> _pay() async {
    setState(() => _isLoading = true);
    try {
      final repository = GetIt.I<PaymentRepository>();
      final paymentInfo =
          widget.args.target == PaymentTarget.subTest
              ? await repository.initPaymentForSubTest(widget.args.subTestId!)
              : await repository.initPaymentForTest(widget.args.testId);
      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => FinikPaymentPage(
                paymentInfo: paymentInfo,
                confirmArgs: widget.args,
              ),
        ),
      );
    } on AppException catch (e) {
      if (!mounted) return;
      AppMessenger.showError(context, e.message ?? 'Не удалось начать оплату');
    } catch (e) {
      if (!mounted) return;
      AppMessenger.showError(context, 'Не удалось начать оплату');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          title: Text('Оплата', style: AppTextStyles.appBarTitle),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.args.testTitle, style: AppTextStyles.h3),
              const SizedBox(height: 8),
              Text(
                widget.args.target == PaymentTarget.subTest
                    ? (widget.args.subTestTitle ?? '')
                    : 'Полный доступ ко всем уровням',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF808080),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF8F2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Стоимость доступа', style: AppTextStyles.bodyMedium),
                    Text(
                      '${widget.args.price.toStringAsFixed(0)} сом',
                      style: AppTextStyles.h3,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: ButtonForAuth(
                  isValid: true,
                  isLoading: _isLoading,
                  text: 'Оплатить',
                  color: const Color(0xFF7B1FA2),
                  textColor: Colors.white,
                  onTap: _pay,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
