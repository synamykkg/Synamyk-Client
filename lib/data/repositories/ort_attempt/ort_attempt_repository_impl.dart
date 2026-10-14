import 'package:synamyk/data/api/dio/synamyk_rest_client.dart';
import 'package:synamyk/data/repositories/ort_attempt/ort_attempt_repository.dart';
import 'package:synamyk/domain/models/common/json_read.dart';
import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/ort_attempt/attempt_result.dart';
import 'package:synamyk/domain/models/ort_attempt/attempt_state.dart';
import 'package:synamyk/domain/models/ort_attempt/full_test.dart';
import 'package:synamyk/domain/models/ort_attempt/section_questions.dart';

class OrtAttemptRepositoryImpl implements OrtAttemptRepository {
  OrtAttemptRepositoryImpl({required SynamykRestClient client})
    : _client = client;

  final SynamykRestClient _client;

  @override
  Future<List<FullTestListItem>> getTests() async {
    final response = await _client.get('/api/tests');
    return readMapList(response.list).map(FullTestListItem.fromJson).toList();
  }

  @override
  Future<FullTestDetail> getTest(int testId) async {
    final response = await _client.get('/api/tests/$testId');
    return FullTestDetail.fromJson(response.map);
  }

  @override
  Future<AttemptState?> getResumable(int testId) async {
    final response = await _client.get('/api/tests/$testId/attempts/resumable');
    if (response.isNoContent) return null;
    return AttemptState.fromJson(response.map);
  }

  @override
  Future<AttemptState> start(int testId, {required bool restart}) async {
    final response = await _client.post(
      '/api/tests/$testId/attempts',
      body: {'restart': restart},
    );
    return AttemptState.fromJson(response.map);
  }

  @override
  Future<AttemptState> getState(int attemptId) async {
    final response = await _client.get('/api/attempts/$attemptId');
    return AttemptState.fromJson(response.map);
  }

  @override
  Future<SectionQuestions> getSection(int attemptId) async {
    final response = await _client.get('/api/attempts/$attemptId/section');
    return SectionQuestions.fromJson(response.map);
  }

  @override
  Future<void> saveAnswer(
    int attemptId, {
    required int questionId,
    required List<int> optionIds,
  }) async {
    await _client.put(
      '/api/attempts/$attemptId/answers',
      body: {'questionId': questionId, 'selectedOptionIds': optionIds},
    );
  }

  @override
  Future<AttemptState> finishSection(int attemptId) async {
    final response = await _client.post(
      '/api/attempts/$attemptId/section/finish',
    );
    return AttemptState.fromJson(response.map);
  }

  @override
  Future<void> pause(int attemptId) async {
    await _client.post('/api/attempts/$attemptId/pause');
  }

  @override
  Future<AttemptResult> finish(int attemptId) async {
    final response = await _client.post('/api/attempts/$attemptId/finish');
    return AttemptResult.fromJson(response.map);
  }

  @override
  Future<AttemptResult> getResult(int attemptId) async {
    final response = await _client.get('/api/attempts/$attemptId/result');
    return AttemptResult.fromJson(response.map);
  }

  @override
  Future<PagedResult<AttemptHistoryItem>> getHistory({
    int page = 0,
    int size = 20,
  }) async {
    final response = await _client.get(
      '/api/attempts/history',
      query: {'page': page, 'size': size},
    );
    return readPage(response.map, AttemptHistoryItem.fromJson, page);
  }
}
