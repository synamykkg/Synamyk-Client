import 'package:finik_sdk/finik_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:synamyk/config/app_config.dart';
import 'package:synamyk/data/repositories/language/language_repository.dart';
import 'package:synamyk/domain/enums/app_language.dart';
import 'package:synamyk/domain/models/payment/init_payment_info.dart';
import 'package:synamyk/ui/payment/models/payment_confirm_args.dart';
import 'package:synamyk/ui/payment/pages/payment_polling_page.dart';
import 'package:synamyk/utils/app_messenger.dart';

class FinikPaymentPage extends StatelessWidget {
  const FinikPaymentPage({
    super.key,
    required this.paymentInfo,
    required this.confirmArgs,
  });

  final InitPaymentInfo paymentInfo;
  final PaymentConfirmArgs confirmArgs;

  FinikSdkLocale get _locale {
    final lang = GetIt.I<LanguageRepository>().current;
    return switch (lang) {
      AppLanguage.kyrgyz => FinikSdkLocale.KY,
      AppLanguage.english => FinikSdkLocale.EN,
      AppLanguage.russian => FinikSdkLocale.RU,
    };
  }

  void _onPayment(BuildContext context, Map? data) {
    final status = data?['status']?.toString().toUpperCase();
    if (status != 'SUCCEEDED') {
      AppMessenger.showError(context, 'Оплата не выполнена');
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) => PaymentPollingPage(
              args: confirmArgs,
              paymentId: paymentInfo.paymentId,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FinikProvider(
      apiKey: AppConfig.finikApiKey,
      isBeta: AppConfig.finikIsBeta,
      locale: _locale,
      onBackPressed: () => Navigator.of(context).pop(),
      onPayment: (data) => _onPayment(context, data),
      widget: CreateItemHandlerWidget(
        accountId: paymentInfo.accountId,
        nameEn: paymentInfo.nameEn,
        requestId: paymentInfo.paymentId,
        amount: FixedAmount(paymentInfo.amount),
        callbackUrl:
            paymentInfo.callbackUrl.isEmpty ? null : paymentInfo.callbackUrl,
        requiredFields: [
          RequiredField(
            fieldId: 'paymentId',
            value: paymentInfo.paymentId,
            isHidden: true,
          ),
        ],
      ),
    );
  }
}
