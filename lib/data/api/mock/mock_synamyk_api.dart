import 'package:chopper/src/base.dart';
import 'package:chopper/src/response.dart';
import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:http/http.dart' as http;

class MockSynamykApi implements SynamykApi {
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 500));

  @override
  ChopperClient client = ChopperClient();

  @override
  Future<Response<dynamic>> apiAdminNewsIdDelete({required int? id}) {
    // TODO: implement apiAdminNewsIdDelete
    throw UnimplementedError();
  }

  @override
  Future<Response<NewsDetailResponse>> apiAdminNewsIdPut({
    required int? id,
    required CreateNewsRequest? body,
  }) {
    // TODO: implement apiAdminNewsIdPut
    throw UnimplementedError();
  }

  @override
  Future<Response<NewsDetailResponse>> apiAdminNewsPost({
    required CreateNewsRequest? body,
  }) {
    // TODO: implement apiAdminNewsPost
    throw UnimplementedError();
  }

  @override
  Future<Response<dynamic>> apiAdminQuestionsQuestionIdDelete({
    required int? questionId,
  }) {
    // TODO: implement apiAdminQuestionsQuestionIdDelete
    throw UnimplementedError();
  }

  @override
  Future<Response<AdminQuestionResponse>> apiAdminQuestionsQuestionIdPut({
    required int? questionId,
    required CreateQuestionRequest? body,
  }) {
    // TODO: implement apiAdminQuestionsQuestionIdPut
    throw UnimplementedError();
  }

  @override
  Future<Response<dynamic>> apiAdminSubTestsSubTestIdDelete({
    required int? subTestId,
  }) {
    // TODO: implement apiAdminSubTestsSubTestIdDelete
    throw UnimplementedError();
  }

  @override
  Future<Response<AdminSubTestResponse>> apiAdminSubTestsSubTestIdPaidPatch({
    required int? subTestId,
    required bool? paid,
  }) {
    // TODO: implement apiAdminSubTestsSubTestIdPaidPatch
    throw UnimplementedError();
  }

  @override
  Future<Response<AdminSubTestResponse>> apiAdminSubTestsSubTestIdPut({
    required int? subTestId,
    required CreateSubTestRequest? body,
  }) {
    // TODO: implement apiAdminSubTestsSubTestIdPut
    throw UnimplementedError();
  }

  @override
  Future<Response<List<AdminQuestionResponse>>>
  apiAdminSubTestsSubTestIdQuestionsGet({required int? subTestId}) {
    // TODO: implement apiAdminSubTestsSubTestIdQuestionsGet
    throw UnimplementedError();
  }

  @override
  Future<Response<AdminQuestionResponse>>
  apiAdminSubTestsSubTestIdQuestionsPost({
    required int? subTestId,
    required CreateQuestionRequest? body,
  }) {
    // TODO: implement apiAdminSubTestsSubTestIdQuestionsPost
    throw UnimplementedError();
  }

  @override
  Future<Response<List<AdminTestResponse>>> apiAdminTestsGet() {
    // TODO: implement apiAdminTestsGet
    throw UnimplementedError();
  }

  @override
  Future<Response<AdminTestResponse>> apiAdminTestsPost({
    required CreateTestRequest? body,
  }) {
    // TODO: implement apiAdminTestsPost
    throw UnimplementedError();
  }

  @override
  Future<Response<dynamic>> apiAdminTestsTestIdDelete({required int? testId}) {
    // TODO: implement apiAdminTestsTestIdDelete
    throw UnimplementedError();
  }

  @override
  Future<Response<AdminTestResponse>> apiAdminTestsTestIdGet({
    required int? testId,
  }) {
    // TODO: implement apiAdminTestsTestIdGet
    throw UnimplementedError();
  }

  @override
  Future<Response<AdminTestResponse>> apiAdminTestsTestIdPricingPut({
    required int? testId,
    required UpdateTestPricingRequest? body,
  }) {
    // TODO: implement apiAdminTestsTestIdPricingPut
    throw UnimplementedError();
  }

  @override
  Future<Response<AdminTestResponse>> apiAdminTestsTestIdPut({
    required int? testId,
    required CreateTestRequest? body,
  }) {
    // TODO: implement apiAdminTestsTestIdPut
    throw UnimplementedError();
  }

  @override
  Future<Response<AdminSubTestResponse>> apiAdminTestsTestIdSubTestsPost({
    required int? testId,
    required CreateSubTestRequest? body,
  }) {
    // TODO: implement apiAdminTestsTestIdSubTestsPost
    throw UnimplementedError();
  }

  @override
  Future<Response<dynamic>> apiAdminVideosIdDelete({required int? id}) {
    // TODO: implement apiAdminVideosIdDelete
    throw UnimplementedError();
  }

  @override
  Future<Response<VideoLessonResponse>> apiAdminVideosIdPut({
    required int? id,
    required CreateVideoLessonRequest? body,
  }) {
    // TODO: implement apiAdminVideosIdPut
    throw UnimplementedError();
  }

  @override
  Future<Response<VideoLessonResponse>> apiAdminVideosPost({
    required CreateVideoLessonRequest? body,
  }) {
    // TODO: implement apiAdminVideosPost
    throw UnimplementedError();
  }

  @override
  Future<Response<AnalyticsChartResponse>> apiAnalyticsChartGet({
    int? testId,
    ApiAnalyticsChartGetPeriod? period,
  }) {
    // TODO: implement apiAnalyticsChartGet
    throw UnimplementedError();
  }

  @override
  Future<Response<List<TestListResponse>>> apiAnalyticsFiltersGet() {
    // TODO: implement apiAnalyticsFiltersGet
    throw UnimplementedError();
  }

  @override
  Future<Response<List<VideoLessonResponse>>> apiAnalyticsVideosGet({
    int? testId,
  }) {
    // TODO: implement apiAnalyticsVideosGet
    throw UnimplementedError();
  }

  @override
  Future<Response<AuthResponse>> apiAuthCompleteProfilePost({
    required CompleteProfileRequest? body,
  }) {
    // TODO: implement apiAuthCompleteProfilePost
    throw UnimplementedError();
  }

  @override
  Future<Response<AuthResponse>> apiAuthLoginPost({
    required LoginRequest? body,
  }) async {
    await _delay();

    if (body == null) {
      throw Exception();
    }

    final login = AuthResponse(phone: body.phone ?? (throw Exception()));

    return Response(http.Response('', 200), login);
  }

  @override
  Future<Response<MessageResponse>> apiAuthLogoutPost() {
    // TODO: implement apiAuthLogoutPost
    throw UnimplementedError();
  }

  @override
  Future<Response<AuthResponse>> apiAuthRefreshPost({
    required RefreshRequest? body,
  }) {
    // TODO: implement apiAuthRefreshPost
    throw UnimplementedError();
  }

  @override
  Future<Response<AuthResponse>> apiAuthRegisterPost({
    required RegisterRequest? body,
  }) async {


    // await _delay();

    // final response = AuthResponse

    // TODO: implement apiAuthRegisterPost
    throw UnimplementedError();
  }

  @override
  Future<Response<OtpSendResponse>> apiAuthResendOtpPost({
    required String? phone,
    required String? type,
    String? lang,
  }) {
    // TODO: implement apiAuthResendOtpPost
    throw UnimplementedError();
  }

  @override
  Future<Response<MessageResponse>> apiAuthResetPasswordPost({
    String? lang,
    required ResetPasswordRequest? body,
  }) {
    // TODO: implement apiAuthResetPasswordPost
    throw UnimplementedError();
  }

  @override
  Future<Response<OtpSendResponse>> apiAuthSendOtpPost({
    required String? phone,
    String? type,
    String? lang,
  }) {
    // TODO: implement apiAuthSendOtpPost
    throw UnimplementedError();
  }

  @override
  Future<Response<OtpVerifyResponse>> apiAuthVerifyOtpPost({
    String? lang,
    required VerifyOtpRequest? body,
  }) {
    // TODO: implement apiAuthVerifyOtpPost
    throw UnimplementedError();
  }

  @override
  Future<Response<List<NewsListResponse>>> apiFeedNewsGet({String? lang}) {
    // TODO: implement apiFeedNewsGet
    throw UnimplementedError();
  }

  @override
  Future<Response<NewsDetailResponse>> apiFeedNewsIdGet({
    required int? id,
    String? lang,
  }) {
    // TODO: implement apiFeedNewsIdGet
    throw UnimplementedError();
  }

  @override
  Future<Response<List<TestListResponse>>> apiFeedRatingFiltersGet({
    String? lang,
  }) {
    // TODO: implement apiFeedRatingFiltersGet
    throw UnimplementedError();
  }

  @override
  Future<Response<RatingResponse>> apiFeedRatingTestIdGet({
    required int? testId,
    String? lang,
  }) {
    // TODO: implement apiFeedRatingTestIdGet
    throw UnimplementedError();
  }

  @override
  Future<Response<InitPaymentResponse>> apiPaymentsInitPost({
    required int? testId,
  }) {
    // TODO: implement apiPaymentsInitPost
    throw UnimplementedError();
  }

  @override
  Future<Response<CreatePaymentResponse>> apiPaymentsPaymentIdGet({
    required String? paymentId,
  }) {
    // TODO: implement apiPaymentsPaymentIdGet
    throw UnimplementedError();
  }

  @override
  Future<Response<MessageResponse>> apiProfileChangePasswordPut({
    required ChangePasswordRequest? body,
  }) {
    // TODO: implement apiProfileChangePasswordPut
    throw UnimplementedError();
  }

  @override
  Future<Response<MessageResponse>> apiProfileChangePhoneConfirmPost({
    required ConfirmPhoneChangeRequest? body,
  }) {
    // TODO: implement apiProfileChangePhoneConfirmPost
    throw UnimplementedError();
  }

  @override
  Future<Response<OtpSendResponse>> apiProfileChangePhoneRequestPost({
    required ChangePhoneRequest? body,
  }) {
    // TODO: implement apiProfileChangePhoneRequestPost
    throw UnimplementedError();
  }

  @override
  Future<Response<MessageResponse>> apiProfileChangeRegionPut({
    required ChangeRegionRequest? body,
  }) {
    // TODO: implement apiProfileChangeRegionPut
    throw UnimplementedError();
  }

  @override
  Future<Response<MessageResponse>> apiProfileDelete() {
    // TODO: implement apiProfileDelete
    throw UnimplementedError();
  }

  @override
  Future<Response<ProfileResponse>> apiProfileGet() {
    // TODO: implement apiProfileGet
    throw UnimplementedError();
  }

  @override
  Future<Response<MessageResponse>> apiProfileLanguagePut({
    required ChangeLanguageRequest? body,
  }) {
    // TODO: implement apiProfileLanguagePut
    throw UnimplementedError();
  }

  @override
  Future<Response<ProfileResponse>> apiProfilePut({
    required UpdateProfileRequest? body,
  }) {
    // TODO: implement apiProfilePut
    throw UnimplementedError();
  }

  @override
  Future<Response<List<RegionDto>>> apiRegionsGet() {
    // TODO: implement apiRegionsGet
    throw UnimplementedError();
  }

  @override
  Future<Response<ErrorAnalysisResponse>>
  apiSessionsSessionIdAnalyzeErrorsPost({
    required int? sessionId,
    required ErrorAnalysisRequest? body,
  }) {
    // TODO: implement apiSessionsSessionIdAnalyzeErrorsPost
    throw UnimplementedError();
  }

  @override
  Future<Response<QuestionForSessionResponse>> apiSessionsSessionIdAnswerPost({
    required int? sessionId,
    required SubmitAnswerRequest? body,
  }) {
    // TODO: implement apiSessionsSessionIdAnswerPost
    throw UnimplementedError();
  }

  @override
  Future<Response<SessionResultResponse>> apiSessionsSessionIdFinishPost({
    required int? sessionId,
  }) {
    // TODO: implement apiSessionsSessionIdFinishPost
    throw UnimplementedError();
  }

  @override
  Future<Response<MessageResponse>> apiSessionsSessionIdPausePost({
    required int? sessionId,
  }) {
    // TODO: implement apiSessionsSessionIdPausePost
    throw UnimplementedError();
  }

  @override
  Future<Response<QuestionForSessionResponse>> apiSessionsSessionIdQuestionGet({
    required int? sessionId,
  }) {
    // TODO: implement apiSessionsSessionIdQuestionGet
    throw UnimplementedError();
  }

  @override
  Future<Response<QuestionForSessionResponse>>
  apiSessionsSessionIdQuestionIndexGet({
    required int? sessionId,
    required int? index,
  }) {
    // TODO: implement apiSessionsSessionIdQuestionIndexGet
    throw UnimplementedError();
  }

  @override
  Future<Response<SessionResultResponse>> apiSessionsSessionIdResultGet({
    required int? sessionId,
  }) {
    // TODO: implement apiSessionsSessionIdResultGet
    throw UnimplementedError();
  }

  @override
  Future<Response<QuestionForSessionResponse>> apiSessionsSessionIdSkipPost({
    required int? sessionId,
  }) {
    // TODO: implement apiSessionsSessionIdSkipPost
    throw UnimplementedError();
  }

  @override
  Future<Response<StartSessionResponse>> apiSubTestsSubTestIdStartPost({
    required int? subTestId,
  }) {
    // TODO: implement apiSubTestsSubTestIdStartPost
    throw UnimplementedError();
  }

  @override
  Future<Response<List<TestListResponse>>> apiTestsGet() {
    // TODO: implement apiTestsGet
    throw UnimplementedError();
  }

  @override
  Future<Response<TestDetailResponse>> apiTestsTestIdGet({
    required int? testId,
  }) {
    // TODO: implement apiTestsTestIdGet
    throw UnimplementedError();
  }

  @override
  Future<Response<UploadResponse>> apiUploadPost({
    required ApiUploadPostType? type,
    required List<int> file,
  }) {
    // TODO: implement apiUploadPost
    throw UnimplementedError();
  }

  @override
  Future<Response<dynamic>> apiWebhooksFinikPost({required WebhookData? body}) {
    // TODO: implement apiWebhooksFinikPost
    throw UnimplementedError();
  }

  @override
  // TODO: implement definitionType
  Type get definitionType => throw UnimplementedError();
}
