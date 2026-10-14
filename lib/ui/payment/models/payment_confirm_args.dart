enum PaymentTarget { subTest, test, product }

class PaymentConfirmArgs {
  const PaymentConfirmArgs({
    required this.target,
    this.testId,
    this.subTestId,
    this.productCode,
    required this.testTitle,
    this.subTestTitle,
    required this.price,
    required this.language,
    this.returnLocation,
  });

  /// What is being bought: one sub-test, the whole test, or a catalog
  /// product (`ALL_TESTS` / `ALL_TEXTS`).
  final PaymentTarget target;

  /// Required when [target] is [PaymentTarget.test] or [PaymentTarget.subTest].
  final int? testId;

  /// Required when [target] is [PaymentTarget.subTest].
  final int? subTestId;

  /// Required when [target] is [PaymentTarget.product].
  final String? productCode;

  final String testTitle;

  /// Required when [target] is [PaymentTarget.subTest].
  final String? subTestTitle;

  final double price;

  /// Route param used by `/ort_test/:language/:id` — historically the parent test id.
  final String language;

  /// Where to land once the payment is confirmed. `null` keeps the legacy
  /// sub-test flow destinations.
  final String? returnLocation;
}
