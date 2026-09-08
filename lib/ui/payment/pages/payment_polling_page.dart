import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/payment/payment_repository.dart';
import 'package:synamyk/ui/auth/widgets/button_for_auth.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/payment/models/payment_confirm_args.dart';

/// Shown right after the Finik SDK reports a locally successful payment.
///
/// Real access is only granted once the backend processes Finik's webhook
/// asynchronously, so we poll `GET /api/payments/{paymentId}/status` until it
/// reports `COMPLETED` (max ~15 attempts, 1.5s apart).
class PaymentPollingPage extends StatefulWidget {
  const PaymentPollingPage({
    super.key,
    required this.args,
    required this.paymentId,
  });

  final PaymentConfirmArgs args;
  final String paymentId;

  @override
  State<PaymentPollingPage> createState() => _PaymentPollingPageState();
}

class _PaymentPollingPageState extends State<PaymentPollingPage> {
  static const _maxAttempts = 15;
  static const _pollInterval = Duration(milliseconds: 1500);

  bool _timedOut = false;

  @override
  void initState() {
    super.initState();
    _poll();
  }

  Future<void> _poll() async {
    setState(() => _timedOut = false);

    for (var attempt = 0; attempt < _maxAttempts; attempt++) {
      if (!mounted) return;

      try {
        final status = await GetIt.I<PaymentRepository>().getPaymentStatus(
          widget.paymentId,
        );

        if (status == 'COMPLETED') {
          if (!mounted) return;
          // A sub-test purchase jumps straight into what was just bought;
          // a bundle purchase has no single sub-test to land on, so it
          // goes back to the (now-unlocked) test list instead.
          if (widget.args.target == PaymentTarget.subTest) {
            context.go(
              '/ort_test/${widget.args.language}/${widget.args.subTestId}',
            );
          } else {
            context.go('/home/tests/${widget.args.language}');
          }
          return;
        }
      } catch (_) {
        // Ignore transient errors while polling and just retry.
      }

      await Future.delayed(_pollInterval);
    }

    if (mounted) setState(() => _timedOut = true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    _timedOut
                        ? [
                          Text(
                            'Оплата обрабатывается',
                            style: AppTextStyles.h3,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Это может занять до минуты. Попробуйте проверить ещё раз или откройте тест позже.',
                            style: AppTextStyles.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ButtonForAuth(
                            isValid: true,
                            text: 'Проверить снова',
                            color: const Color(0xFF7B1FA2),
                            textColor: Colors.white,
                            onTap: _poll,
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed:
                                () => context.go(
                                  '/home/tests/${widget.args.language}',
                                ),
                            child: const Text('Назад к тестам'),
                          ),
                        ]
                        : [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            'Проверяем оплату…',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
