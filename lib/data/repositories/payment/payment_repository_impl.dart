import 'package:synamyk/config/app_config.dart';
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/repositories/payment/payment_repository.dart';
import 'package:synamyk/domain/enums/payment_status.dart';
import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/payment/init_payment_info.dart';
import 'package:synamyk/domain/models/payment/payment_history_entry.dart';
import 'package:synamyk/error/api_error_parser.dart';
import 'package:synamyk/error/app_exception.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl({required this.synamykApi});

  final SynamykApiClient synamykApi;

  @override
  Future<InitPaymentInfo> initPayment(int testId) async {
    try {
      final response = await synamykApi.auth.apiPaymentsInitPost(
        testId: testId,
      );
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(
          response.statusCode,
          response.error,
        );
      }

      final body = response.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      final paymentId = body.paymentId;
      final amount = body.amount;
      if (paymentId == null || amount == null) {
        throw AppException.unknown('Некорректный ответ платежного сервиса');
      }

      return InitPaymentInfo(
        paymentId: paymentId,
        accountId: AppConfig.finikAccountId,
        amount: amount,
        nameEn: body.nameEn ?? 'Synamyk ORT Test',
        callbackUrl: body.callbackUrl ?? '',
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<String?> getPaymentStatus(String paymentId) async {
    final response = await synamykApi.auth.apiPaymentsPaymentIdStatusGet(
      paymentId: paymentId,
    );
    if (!response.isSuccessful) {
      throw ExceptionParser.parseResponse(
        response.statusCode,
        response.error,
      );
    }

    return response.body?.status;
  }

  @override
  Future<PagedResult<PaymentHistoryEntry>> getMyPayments({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await synamykApi.auth.apiPaymentsMyGet(
        page: page,
        size: size,
      );
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(
          response.statusCode,
          response.error,
        );
      }

      final body = response.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      final content =
          (body.content ?? [])
              .map(
                (e) => PaymentHistoryEntry(
                  paymentId: e.paymentId ?? (throw AppException.unknown()),
                  testId: e.testId ?? (throw AppException.unknown()),
                  testTitle: e.testTitle ?? '',
                  amount: e.amount ?? 0,
                  status: PaymentStatus.fromJson(e.status),
                  receiptNumber: e.receiptNumber,
                  paymentUrl: e.paymentUrl,
                  createdAt: e.createdAt ?? (throw AppException.unknown()),
                  paidAt: e.paidAt,
                ),
              )
              .toList();

      return PagedResult(
        content: content,
        totalElements: body.totalElements ?? content.length,
        number: body.number ?? page,
        last: body.last ?? true,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
