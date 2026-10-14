import 'package:synamyk/config/app_config.dart';
import 'package:synamyk/data/api/dio/synamyk_rest_client.dart';
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/repositories/payment/payment_repository.dart';
import 'package:synamyk/domain/models/common/json_read.dart';
import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/payment/init_payment_info.dart';
import 'package:synamyk/domain/models/payment/payment_history_entry.dart';
import 'package:synamyk/error/api_error_parser.dart';
import 'package:synamyk/error/app_exception.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl({required this.synamykApi, required this.restClient});

  final SynamykApiClient synamykApi;

  /// `product=` payments and the history's `product` field aren't in the
  /// generated OpenAPI client yet.
  final SynamykRestClient restClient;

  static const _fallbackNameEn = 'Synamyk ORT Test';

  /// Finik requires a Latin-script name; the backend's `nameEn` field is
  /// sometimes populated with the localized (Cyrillic) test name instead,
  /// which Finik rejects with "имя указано неверно". Fall back to a safe
  /// constant whenever the backend value isn't plain ASCII.
  static bool _isAsciiName(String value) =>
      value.isNotEmpty && RegExp(r'^[\x00-\x7F]+$').hasMatch(value);

  @override
  Future<InitPaymentInfo> initPaymentForTest(int testId) =>
      _initPayment(testId: testId);

  @override
  Future<InitPaymentInfo> initPaymentForSubTest(int subTestId) =>
      _initPayment(subTestId: subTestId);

  @override
  Future<InitPaymentInfo> initPaymentForProduct(String productCode) =>
      _initPayment(product: productCode);

  Future<InitPaymentInfo> _initPayment({
    int? testId,
    int? subTestId,
    String? product,
  }) async {
    final response = await restClient.post(
      '/api/payments/init',
      query: {'testId': testId, 'subTestId': subTestId, 'product': product},
    );
    final body = response.map;

    final paymentId = readString(body['paymentId']);
    final amount = readDouble(body['amount']);
    if (paymentId == null || amount == null) {
      throw AppException.unknown('Некорректный ответ платежного сервиса');
    }

    final nameEn = readString(body['nameEn']);
    return InitPaymentInfo(
      paymentId: paymentId,
      accountId: AppConfig.finikAccountId,
      amount: amount,
      nameEn:
          (nameEn != null && _isAsciiName(nameEn)) ? nameEn : _fallbackNameEn,
      callbackUrl: readStringOr(body['callbackUrl']),
    );
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
    final response = await restClient.get(
      '/api/payments/my',
      query: {'page': page, 'size': size},
    );
    return readPage(response.map, PaymentHistoryEntry.fromJson, page);
  }
}
