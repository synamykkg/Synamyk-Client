import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/payment/init_payment_info.dart';
import 'package:synamyk/domain/models/payment/payment_history_entry.dart';

abstract class PaymentRepository {
  /// Buys the whole test (bundle) — opens every paid sub-test under it.
  Future<InitPaymentInfo> initPaymentForTest(int testId);

  /// Buys a single sub-test independently of the rest of the test.
  Future<InitPaymentInfo> initPaymentForSubTest(int subTestId);

  /// Buys a catalog product: `ALL_TESTS` or `ALL_TEXTS`.
  Future<InitPaymentInfo> initPaymentForProduct(String productCode);

  /// Returns the raw payment status string (e.g. "PENDING", "COMPLETED", "FAILED").
  Future<String?> getPaymentStatus(String paymentId);

  /// The current user's payment history, newest first.
  Future<PagedResult<PaymentHistoryEntry>> getMyPayments({
    int page = 0,
    int size = 20,
  });
}
