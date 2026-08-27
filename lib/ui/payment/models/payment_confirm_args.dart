class PaymentConfirmArgs {
  const PaymentConfirmArgs({
    required this.testId,
    required this.subTestId,
    required this.testTitle,
    required this.subTestTitle,
    required this.price,
    required this.language,
  });

  final int testId;
  final int subTestId;
  final String testTitle;
  final String subTestTitle;
  final double price;

  /// Route param used by `/ort_test/:language/:id` — historically the parent test id.
  final String language;
}
