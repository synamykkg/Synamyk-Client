import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/payment/init_payment_info.dart';
import 'package:synamyk/domain/models/payment/payment_history_entry.dart';

abstract class PaymentRepository {
  Future<InitPaymentInfo> initPayment(int testId);

  /// Returns the raw payment status string (e.g. "PENDING", "COMPLETED", "FAILED").
  Future<String?> getPaymentStatus(String paymentId);

  /// The current user's payment history, newest first.
  Future<PagedResult<PaymentHistoryEntry>> getMyPayments({
    int page = 0,
    int size = 20,
  });
}
