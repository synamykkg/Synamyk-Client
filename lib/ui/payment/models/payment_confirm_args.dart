enum PaymentTarget { subTest, test }

class PaymentConfirmArgs {
  const PaymentConfirmArgs({
    required this.target,
    required this.testId,
    this.subTestId,
    required this.testTitle,
    this.subTestTitle,
    required this.price,
    required this.language,
  });

  /// Whether this purchase is for one sub-test or the whole test (bundle).
  final PaymentTarget target;

  final int testId;

  /// Required when [target] is [PaymentTarget.subTest].
  final int? subTestId;

  final String testTitle;

  /// Required when [target] is [PaymentTarget.subTest].
  final String? subTestTitle;

  final double price;

  /// Route param used by `/ort_test/:language/:id` — historically the parent test id.
  final String language;
}
