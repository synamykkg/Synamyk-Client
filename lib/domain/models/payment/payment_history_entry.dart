import 'package:synamyk/domain/enums/payment_status.dart';

class PaymentHistoryEntry {
  PaymentHistoryEntry({
    required this.paymentId,
    required this.testId,
    required this.testTitle,
    required this.amount,
    required this.status,
    required this.receiptNumber,
    required this.paymentUrl,
    required this.createdAt,
    required this.paidAt,
  });

  final String paymentId;
  final int testId;
  final String testTitle;
  final double amount;
  final PaymentStatus status;

  /// Null until the payment is completed.
  final String? receiptNumber;
  final String? paymentUrl;
  final DateTime createdAt;

  /// Null until the payment is completed.
  final DateTime? paidAt;

  factory PaymentHistoryEntry.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryEntry(
      paymentId: json['paymentId'] as String,
      testId: json['testId'] as int,
      testTitle: json['testTitle'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      status: PaymentStatus.fromJson(json['status'] as String?),
      receiptNumber: json['receiptNumber'] as String?,
      paymentUrl: json['paymentUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      paidAt:
          json['paidAt'] != null
              ? DateTime.parse(json['paidAt'] as String)
              : null,
    );
  }
}
