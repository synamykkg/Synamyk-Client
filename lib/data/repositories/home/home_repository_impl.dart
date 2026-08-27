import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/repositories/home/home_repository.dart';
import 'package:synamyk/domain/models/home/subject_list.dart';
import 'package:synamyk/domain/models/home/subject_model.dart';
import 'package:synamyk/domain/models/home/subject_tests.dart';
import 'package:synamyk/error/api_error_parser.dart';
import 'package:synamyk/error/app_exception.dart';

class HomeRepositoryImpl implements HomeRepository {
  final SynamykApiClient synamykApi;

  HomeRepositoryImpl({required this.synamykApi});

  @override
  Future<List<SubjectList>> getHomeSubjectsList() async {
    try {
      final response = await synamykApi.auth.apiTestsGet();
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(response.statusCode, response.error);
      }
      final body = response.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      return body.map((test) => SubjectList(
        id: test.id?.toString() ?? '',
        title: test.title ?? '',
        subTitle: test.description ?? '',
        image: test.iconUrl ?? '',
        price: test.price,
        subTestCount: test.subTestCount ?? 0,
        completedSubTestCount: test.completedSubTestCount ?? 0,
        progressPercent: test.progressPercent ?? 0,
      )).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<SubjectModel> getSubjectTests(String subjectId) async {
    try {
      final id = int.tryParse(subjectId);
      if (id == null) throw AppException.unknown('Неверный ID предмета');

      final response = await synamykApi.auth.apiTestsTestIdGet(testId: id);
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(response.statusCode, response.error);
      }
      
      final testDetail = response.body;
      if (testDetail == null) throw AppException.unknown('Пустой ответ');

      final testsList = (testDetail.subTests ?? []).map((subTest) {
        return SubjectTests(
          id: subTest.id?.toString() ?? '',
          level: subTest.levelName ?? '',
          isFree: !(subTest.isPaid ?? false),
          title: subTest.title ?? '',
          image: '', // No image in SubTestResponse
          minutes: subTest.durationMinutes ?? 0,
          questions: subTest.questionCount ?? 0,
          hasAccess: subTest.hasAccess ?? !(subTest.isPaid ?? false),
          hasCompleted: subTest.hasCompleted ?? false,
          bestScore: subTest.bestScore,
          bestSessionId: subTest.bestSessionId,
          attemptsCount: subTest.attemptsCount ?? 0,
        );
      }).toList();

      return SubjectModel(
        id: testDetail.id?.toString() ?? '',
        title: testDetail.title ?? '',
        tarif: testDetail.price?.toString() ?? '',
        testsList: testsList,
        hasPaidAccess: testDetail.hasPaidAccess ?? false
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<SubjectModel> changeTarif(String subjectId) {
    throw UnimplementedError();
  }
}
