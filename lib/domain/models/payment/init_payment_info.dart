class InitPaymentInfo {
  InitPaymentInfo({
    required this.paymentId,
    required this.accountId,
    required this.amount,
    required this.nameEn,
    required this.callbackUrl,
  });

  final String paymentId;
  final String accountId;
  final double amount;
  final String nameEn;
  final String callbackUrl;
}
