// Demo entry point: the real app UI with sample data and no backend.
// Run: flutter run -t lib/demo/demo_main.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synamyk/data/repositories/analyst/analyst_repository.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/data/repositories/catalog/catalog_repository.dart';
import 'package:synamyk/data/repositories/game/game_repository.dart';
import 'package:synamyk/data/repositories/home/home_repository.dart';
import 'package:synamyk/data/repositories/language/language_repository.dart';
import 'package:synamyk/data/repositories/news/news_repository.dart';
import 'package:synamyk/data/repositories/notifications/notifications_repository.dart';
import 'package:synamyk/data/repositories/ort_attempt/ort_attempt_repository.dart';
import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';
import 'package:synamyk/data/repositories/payment/payment_repository.dart';
import 'package:synamyk/data/repositories/profile/profile_repository.dart';
import 'package:synamyk/data/repositories/referral/referral_repository.dart';
import 'package:synamyk/data/repositories/regions/regions_repository.dart';
import 'package:synamyk/data/repositories/school/school_repository.dart';
import 'package:synamyk/data/repositories/user/image/image_repository.dart';
import 'package:synamyk/data/repositories/user/user_repository.dart';
import 'package:synamyk/data/repositories/video_lessons/video_lessons_repository.dart';
import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart' show ProfileResponse;
import 'package:synamyk/domain/models/auth/auth_token.dart';
import 'package:synamyk/domain/models/catalog/catalog_models.dart';
import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/game/game_history_entry.dart';
import 'package:synamyk/domain/models/game/game_rating.dart';
import 'package:synamyk/domain/models/game/game_test_model.dart';
import 'package:synamyk/domain/models/ort_attempt/attempt_result.dart';
import 'package:synamyk/domain/models/ort_attempt/attempt_state.dart';
import 'package:synamyk/domain/models/ort_attempt/full_test.dart';
import 'package:synamyk/domain/models/ort_attempt/section_questions.dart';
import 'package:synamyk/domain/models/referral/referral_info.dart';
import 'package:synamyk/domain/models/region/region_model.dart';
import 'package:synamyk/domain/models/school/school_models.dart';
import 'package:synamyk/domain/models/user/user_model.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/routing/router.dart';
import 'package:synamyk/synamyk_app.dart';
import 'package:synamyk/ui/auth/bloc/app_auth_bloc.dart';
import 'package:synamyk/ui/core/features/language/bloc/language_bloc.dart';

Future<Never> _unavailable() =>
    Future.error(AppException.unknown('Демо-режимде жеткиликсиз'));

mixin _Demo {
  // Anything not faked below fails like an offline request.
  dynamic noSuchMethod(Invocation invocation) => _unavailable();
}

Future<T> _later<T>(T value) =>
    Future.delayed(const Duration(milliseconds: 350), () => value);

class DemoAuth with _Demo implements AuthRepository {
  @override
  Future<AuthToken?> getSavedSession() async =>
      AuthToken(accessToken: 'demo', refreshToken: 'demo');
  @override
  Future<AuthToken> refreshSession() async =>
      AuthToken(accessToken: 'demo', refreshToken: 'demo');
}

class DemoAttempts with _Demo implements OrtAttemptRepository {
  int _section = 0;
  bool _completed = false;

  @override
  Future<List<FullTestListItem>> getTests() => _later([
    for (var i = 1; i <= 6; i++)
      FullTestListItem.fromJson({
        'id': i,
        'title': 'Негизги тест $i',
        'description': 'Толук ЖРТ форматындагы сынамык',
        'totalDurationMinutes': 215,
        'totalQuestions': 150,
        'maxScore': 245,
        'isFree': i == 1,
        'hasAccess': i <= 2,
        'price': 290,
        'bestOrtScore': i == 1 && _completed ? 163 : (i == 2 ? 141 : null),
        'resumableAttemptId': i == 2 ? 7 : null,
      }),
  ]);

  @override
  Future<FullTestDetail> getTest(int testId) => _later(
    FullTestDetail.fromJson({
      'id': testId,
      'title': 'Негизги тест $testId',
      'hasAccess': testId <= 2,
      'isFree': testId == 1,
      'price': 290,
      'totalDurationMinutes': 215,
      'totalQuestions': 150,
      'maxScore': 245,
      'bestOrtScore': testId == 2 ? 141 : null,
      'resumableAttemptId': testId == 2 ? 7 : null,
      'resumableSectionIndex': testId == 2 ? 1 : null,
      'subTests': [
        {'id': 1, 'title': 'Математика 1', 'durationMinutes': 30, 'questionCount': 30, 'maxScore': 49},
        {'id': 2, 'title': 'Математика 2', 'durationMinutes': 60, 'questionCount': 30, 'maxScore': 49},
        {'id': 3, 'title': 'Окшоштуктар жана сүйлөмдөрдү толуктоо', 'durationMinutes': 30, 'questionCount': 30, 'maxScore': 49},
        {'id': 4, 'title': 'Окуу жана түшүнүү 1', 'durationMinutes': 60, 'questionCount': 30, 'maxScore': 49},
        {'id': 5, 'title': 'Грамматика 1', 'durationMinutes': 35, 'questionCount': 30, 'maxScore': 49},
      ],
    }),
  );

  @override
  Future<AttemptState> start(int testId, {required bool restart}) {
    if (restart) _section = 0;
    return _later(_state('IN_PROGRESS'));
  }

  AttemptState _state(String status) => AttemptState.fromJson({
    'attemptId': 7,
    'testId': 1,
    'status': status,
    'currentSectionIndex': _section,
    'totalSections': 3,
    'sections': [],
  });

  @override
  Future<AttemptState> getState(int attemptId) =>
      _later(_state(_completed ? 'COMPLETED' : 'IN_PROGRESS'));

  @override
  Future<SectionQuestions> getSection(int attemptId) =>
      _later(SectionQuestions.fromJson(_sections[_section.clamp(0, 2)]));

  @override
  Future<void> saveAnswer(int attemptId, {required int questionId, required List<int> optionIds}) =>
      _later(null);

  @override
  Future<AttemptState> finishSection(int attemptId) {
    if (_section >= 2) {
      _completed = true;
      _section = 0;
      return _later(_state('COMPLETED'));
    }
    _section++;
    return _later(_state('IN_PROGRESS'));
  }

  @override
  Future<void> pause(int attemptId) async {}

  @override
  Future<AttemptResult> finish(int attemptId) {
    _completed = true;
    _section = 0;
    return getResult(attemptId);
  }

  @override
  Future<AttemptResult> getResult(int attemptId) => _later(
    AttemptResult.fromJson({
      'attemptId': 7,
      'testId': 1,
      'testTitle': 'Негизги тест 1',
      'userFullName': 'Айназик Токтомаматова',
      'completedAt': '2026-09-17T12:40:00',
      'ortScore': 163,
      'maxScore': 245,
      'thresholdScore': 110,
      'passedThreshold': true,
      'correctAnswers': 98,
      'wrongAnswers': 40,
      'skippedAnswers': 12,
      'timeTakenSeconds': 9120,
      'percentage': 65.3,
      'motivationalMessage': 'Мыкты жыйынтык! Ушундай эле уланта бер.',
      'sections': [
        {'subTestId': 1, 'title': 'Математика 1', 'percentage': 66.7, 'ortScore': 33, 'maxScore': 49, 'correctAnswers': 20, 'totalQuestions': 30},
        {'subTestId': 2, 'title': 'Математика 2', 'percentage': 80.0, 'ortScore': 39, 'maxScore': 49, 'correctAnswers': 24, 'totalQuestions': 30},
        {'subTestId': 3, 'title': 'Окшоштуктар', 'percentage': 56.7, 'ortScore': 28, 'maxScore': 49, 'correctAnswers': 17, 'totalQuestions': 30},
        {'subTestId': 4, 'title': 'Окуу жана түшүнүү 1', 'percentage': 70.0, 'ortScore': 34, 'maxScore': 49, 'correctAnswers': 21, 'totalQuestions': 30},
        {'subTestId': 5, 'title': 'Грамматика 1', 'percentage': 53.3, 'ortScore': 29, 'maxScore': 49, 'correctAnswers': 16, 'totalQuestions': 30},
      ],
      'topics': [
        {'topic': 'Бөлчөктөр', 'totalQuestions': 6, 'correctAnswers': 5, 'percentage': 83.3},
        {'topic': 'Сөз түркүмдөрү', 'totalQuestions': 4, 'correctAnswers': 2, 'percentage': 50.0},
        {'topic': 'Функциялар', 'totalQuestions': 5, 'correctAnswers': 2, 'percentage': 40.0},
      ],
    }),
  );

  @override
  Future<PagedResult<AttemptHistoryItem>> getHistory({int page = 0, int size = 20}) => _later(
    PagedResult(
      content: [
        AttemptHistoryItem.fromJson({'attemptId': 7, 'testId': 1, 'testTitle': 'Негизги тест 1', 'ortScore': 163, 'maxScore': 245, 'percentage': 65.3, 'completedAt': '2026-09-17T12:40:00'}),
        AttemptHistoryItem.fromJson({'attemptId': 6, 'testId': 2, 'testTitle': 'Негизги тест 2', 'ortScore': 141, 'maxScore': 245, 'percentage': 57.5, 'completedAt': '2026-09-12T18:05:00'}),
        AttemptHistoryItem.fromJson({'attemptId': 5, 'testId': 1, 'testTitle': 'Негизги тест 1', 'ortScore': 118, 'maxScore': 245, 'percentage': 48.0, 'completedAt': '2026-09-03T10:20:00'}),
      ],
      totalElements: 3,
      number: 0,
      last: true,
    ),
  );

  static final _options = [
    {'id': 1, 'label': 'А', 'text': 'Колонка А чоң', 'orderIndex': 0},
    {'id': 2, 'label': 'Б', 'text': 'Колонка Б чоң', 'orderIndex': 1},
    {'id': 3, 'label': 'В', 'text': 'Тең', 'orderIndex': 2},
    {'id': 4, 'label': 'Г', 'text': 'Аныктоо мүмкүн эмес', 'orderIndex': 3},
  ];

  static final _sections = <Map<String, dynamic>>[
    {
      'attemptId': 7, 'sectionIndex': 0, 'totalSections': 3, 'title': 'Математика 1', 'remainingSeconds': 1797, 'totalQuestions': 3,
      'passages': [],
      'questions': [
        {'questionId': 1, 'index': 0, 'number': 1, 'questionType': 'COMPARISON', 'text': '', 'columnA': r'$\frac{7}{4}-\frac{3}{4}$', 'columnB': r'$\frac{7}{8}-\frac{1}{8}$', 'options': _options, 'selectedOptionIds': []},
        {'questionId': 2, 'index': 1, 'number': 2, 'questionType': 'COMPARISON', 'text': '', 'columnA': r'$160 \times \frac{5}{8}$', 'columnB': r'$160 \times 0.625$', 'options': _options, 'selectedOptionIds': []},
        {'questionId': 3, 'index': 2, 'number': 3, 'text': r'$y = x^2 - 2$ параболасы жана түз сызык берилген. Алар канча чекитте кесилишет?',
          'figure': {'type': 'COORDINATE_PLANE', 'xMin': -4, 'xMax': 4, 'yMin': -3, 'yMax': 5, 'elements': [
            {'kind': 'FUNCTION', 'expression': 'x^2-2'},
            {'kind': 'LINE', 'from': [0, 1], 'to': [1, 2], 'color': '#E5484D'},
            {'kind': 'POINT', 'x': 0, 'y': 1, 'label': 'A'},
          ]},
          'options': [
            {'id': 5, 'label': 'А', 'text': '0', 'orderIndex': 0},
            {'id': 6, 'label': 'Б', 'text': '1', 'orderIndex': 1},
            {'id': 7, 'label': 'В', 'text': '2', 'orderIndex': 2},
            {'id': 8, 'label': 'Г', 'text': '3', 'orderIndex': 3},
          ], 'selectedOptionIds': []},
      ],
    },
    {
      'attemptId': 7, 'sectionIndex': 1, 'totalSections': 3, 'title': 'Геометрия', 'remainingSeconds': 1500, 'totalQuestions': 1,
      'passages': [],
      'questions': [
        {'questionId': 20, 'index': 0, 'number': 1, 'text': r'Тик бурчтуу үч бурчтуктун катеттери 3 жана 4. Гипотенузаны тапкыла.',
          'figure': {'type': 'GEOMETRY', 'elements': [
            {'kind': 'POLYGON', 'points': [[0, 0], [4, 0], [0, 3]], 'labels': ['C', 'B', 'A'], 'fill': '#1F6D35E0'},
            {'kind': 'ANGLE', 'vertex': [0, 0], 'from': [4, 0], 'to': [0, 3], 'right': true},
            {'kind': 'SEGMENT', 'from': [0, 0], 'to': [4, 0], 'label': '4'},
            {'kind': 'SEGMENT', 'from': [0, 3], 'to': [0, 0], 'label': '3'},
          ]},
          'options': [
            {'id': 21, 'label': 'А', 'text': '5', 'orderIndex': 0},
            {'id': 22, 'label': 'Б', 'text': r'$\sqrt{7}$', 'orderIndex': 1},
            {'id': 23, 'label': 'В', 'text': '7', 'orderIndex': 2},
          ], 'selectedOptionIds': []},
      ],
    },
    {
      'attemptId': 7, 'sectionIndex': 2, 'totalSections': 3, 'isLastSection': true, 'title': 'Окуу жана түшүнүү 1', 'remainingSeconds': 3589, 'totalQuestions': 2,
      'passages': [
        {'id': 9, 'number': 1, 'title': '1-текст', 'questionIds': [31, 32], 'text': [
          'Жалгыздык — азыркы коомдун эң чоң көйгөйлөрүнүн бири.',
          'Окумуштуулар аны суусоо же ачкачылык сыяктуу',
          'табигый сигнал катары карашат: ал адамга',
          'башкалар менен байланыш керек экенин эскертет.',
          'Манчестер университетинин окумуштуусу Памела',
          'Куолтер өз изилдөөсүндө өспүрүм курактагылардын',
          'дагы ушул абалга түшкөн учурлары бар экенин',
          'аныктаган. Деген менен улгайган кишилердин',
          '50–60 пайызы жалгыздык тууралуу көп даттанышкан.',
          'Ошондуктан жалгыздыкты «жаңы эпидемия» деп аташат.',
        ].join('\n')},
      ],
      'questions': [
        {'questionId': 31, 'index': 0, 'number': 1, 'passageId': 9, 'text': 'Автор жалгыздыкты эмне менен салыштырат?', 'options': [
          {'id': 1, 'label': 'А', 'text': 'Суусоо менен', 'orderIndex': 0},
          {'id': 2, 'label': 'Б', 'text': 'Уйкусуздук менен', 'orderIndex': 1},
          {'id': 3, 'label': 'В', 'text': 'Жокчулук менен', 'orderIndex': 2},
        ], 'selectedOptionIds': []},
        {'questionId': 32, 'index': 1, 'number': 2, 'passageId': 9, 'text': 'Текстке ылайык, жалгыздык эмне үчүн «эпидемия» деп аталат?', 'options': [
          {'id': 4, 'label': 'А', 'text': 'Анын таасири күчтүү жана тез жайылат', 'orderIndex': 0},
          {'id': 5, 'label': 'Б', 'text': 'Ал жугуштуу оору', 'orderIndex': 1},
          {'id': 6, 'label': 'В', 'text': 'Аны дарылоо мүмкүн эмес', 'orderIndex': 2},
        ], 'selectedOptionIds': []},
      ],
    },
  ];
}

class DemoCatalog with _Demo implements CatalogRepository {
  static final _products = [
    ProductModel.fromJson({'code': 'ALL_TESTS', 'title': 'Бардык тесттерди ач', 'description': 'Бир жолку төлөм менен бардык ЖРТ сынамыктары ачылат', 'price': 990, 'oldPrice': 1490, 'available': true, 'owned': false, 'features': ['Бардык ЖРТ сынамыктары', 'Бөлүктөр жана темалар боюнча талдоо', 'Чектөөсүз колдонуу — бир жолку төлөм']}),
    ProductModel.fromJson({'code': 'ALL_TEXTS', 'title': 'Окуу тексттерин ач', 'description': 'Бир жолку төлөм менен бардык окуу түшүнүү тексттери ачылат', 'price': 200, 'available': true, 'owned': false, 'features': ['Бардык окуу түшүнүү тексттери ачылат', 'PDF форматында, каалаган убакта оку', 'Чектөөсүз колдонуу — бир жолку төлөм']}),
  ];

  @override
  Future<AppConfigModel> getAppConfig() => _later(AppConfigModel.fromJson({'ortExamDate': '2027-05-15T08:00:00', 'secondsUntilExam': DateTime(2027, 5, 15, 8).difference(DateTime.now()).inSeconds}));
  @override
  Future<List<ProductModel>> getProducts() => _later(_products);
  @override
  Future<ProductModel> getProduct(String code) => _later(_products.firstWhere((p) => p.code == code));
  @override
  Future<List<ReadingTextItem>> getTexts() => _later([
    for (var i = 1; i <= 8; i++) ReadingTextItem.fromJson({'id': i, 'title': 'Текст $i', 'free': i == 1, 'hasAccess': i == 1, 'hasPdf': true}),
  ]);
  @override
  Future<ReadingTextDetail> getText(int id) => _later(ReadingTextDetail.fromJson({
    'id': id, 'title': 'Текст $id',
    'content': 'Жалгыздык — азыркы коомдун эң чоң көйгөйлөрүнүн бири. Окумуштуулар аны суусоо же ачкачылык сыяктуу табигый сигнал катары карашат: ал адамга башкалар менен байланыш керек экенин эскертет.\n\nМанчестер университетинин окумуштуусу Памела Куолтер өз изилдөөсүндө өспүрүм курактагылардын дагы ушул абалга түшкөн учурлары бар экенин аныктаган.',
  }));
}

class DemoSchools with _Demo implements SchoolRepository {
  @override
  Future<SchoolRating> getSchoolRating({required SchoolRatingSort sort, int? districtId}) => _later(SchoolRating.fromJson({
    'districtName': 'Октябрь району', 'minStudents': 3,
    'mySchool': {'schoolId': 9, 'schoolName': 'Мектеп №61', 'studentCount': 1, 'minStudents': 3, 'inRating': false, 'studentsNeeded': 2},
    'entries': [
      {'rank': 1, 'schoolId': 2, 'name': 'Мектеп-гимназия №5', 'studentCount': 12, 'inRating': true, 'value': sort == SchoolRatingSort.score ? 171.4 : sort == SchoolRatingSort.activity ? 48 : 12.5},
      {'rank': 2, 'schoolId': 3, 'name': 'Лицей №61', 'studentCount': 7, 'inRating': true, 'value': sort == SchoolRatingSort.score ? 158 : sort == SchoolRatingSort.activity ? 31 : 9},
      {'rank': 3, 'schoolId': 4, 'name': 'QSI International School of Bishkek', 'studentCount': 5, 'inRating': true, 'value': sort == SchoolRatingSort.score ? 150.2 : sort == SchoolRatingSort.activity ? 22 : 7.4},
      {'rank': 4, 'schoolId': 5, 'name': 'Мектеп №12', 'studentCount': 3, 'inRating': true, 'value': sort == SchoolRatingSort.score ? 131 : sort == SchoolRatingSort.activity ? 9 : 3},
      {'rank': null, 'schoolId': 9, 'name': 'Мектеп №61', 'studentCount': 1, 'inRating': false, 'isMine': true},
      {'rank': null, 'schoolId': 10, 'name': 'Вечерняя (сменная) общеобразовательная школа №1', 'studentCount': 1, 'inRating': false},
    ],
  }));
  @override
  Future<DistrictRating> getDistrictRating({int? regionId}) => _later(DistrictRating.fromJson({
    'regionName': 'Бишкек шаары',
    'entries': [
      {'rank': 1, 'name': 'Ленин району', 'studentsWithResults': 412, 'averageScore': 152.3},
      {'rank': 2, 'name': 'Октябрь району', 'studentsWithResults': 388, 'averageScore': 147.9, 'isMine': true},
      {'rank': 3, 'name': 'Биринчи май району', 'studentsWithResults': 251, 'averageScore': 141.0},
      {'rank': 4, 'name': 'Свердлов району', 'studentsWithResults': 230, 'averageScore': 139.4},
    ],
  }));
  @override
  Future<StudentRating> getStudentRating(StudentRatingScope scope) => _later(StudentRating.fromJson({
    'entries': [
      {'rank': 1, 'userId': 1, 'fullName': 'Бекзат Асанов', 'schoolName': 'Мектеп-гимназия №5', 'score': 214},
      {'rank': 2, 'userId': 2, 'fullName': 'Айгерим Токтосунова', 'schoolName': 'Лицей №61', 'score': 206},
      {'rank': 3, 'userId': 3, 'fullName': 'Нурлан Абдыкадыров', 'schoolName': 'Мектеп №12', 'score': 199},
      {'rank': 4, 'userId': 4, 'fullName': 'Айназик Токтомаматова', 'schoolName': 'Мектеп №61', 'score': 163, 'isMe': true},
      {'rank': 5, 'userId': 5, 'fullName': 'Элнура Мамытова', 'schoolName': 'Лицей №61', 'score': 158},
    ],
  }));
  @override
  Future<MySchool?> getMySchool() => _later(MySchool.fromJson({'schoolId': 9, 'schoolName': 'Мектеп №61', 'districtName': 'Октябрь району', 'regionName': 'Бишкек', 'studentCount': 1, 'minStudents': 3, 'inRating': false, 'studentsNeeded': 2}));
  @override
  Future<List<District>> getDistricts(int regionId) => _later([
    for (final n in ['Ленин району', 'Октябрь району', 'Биринчи май району', 'Свердлов району']) District(id: n.length, name: n, nameKy: n),
  ]);
  @override
  Future<PagedResult<School>> getSchools(int districtId, {String? search, int page = 0, int size = 50}) {
    final all = [for (var i = 1; i <= 25; i++) School(id: i, name: 'Мектеп №$i', nameKy: 'Мектеп №$i')];
    final q = search?.trim() ?? '';
    final list = all.where((s) => s.name.contains(q)).toList();
    return _later(PagedResult(content: list, totalElements: list.length, number: 0, last: true));
  }
}

class DemoReferrals with _Demo implements ReferralRepository {
  @override
  Future<ReferralInfo> getMyInfo() => _later(ReferralInfo.fromJson({
    'code': '2T9KES', 'inviteLink': 'https://synamyk.kg/invite/2T9KES', 'shareText': 'ЖРТга мени менен бирге даярдан! Кодум: 2T9KES',
    'invitedCount': 3, 'purchasedCount': 1, 'availableRewards': 1, 'canApplyCode': false, 'referredByName': 'Айбек Т.',
    'rewards': [
      {'rewardId': 5, 'friendName': 'Нурлан А.', 'earnedAt': '2026-09-15T10:00:00', 'available': true},
      {'rewardId': 4, 'friendName': 'Элнура М.', 'earnedAt': '2026-09-01T10:00:00', 'available': false, 'redeemedTestTitle': 'Негизги тест 2'},
    ],
  }));
}

class DemoGames with _Demo implements GameRepository {
  static final _players = [
    for (final (i, name, rating, league) in [
      (1, 'Бекзат Асанов', 1742, 'DIAMOND'),
      (2, 'Айгерим Токтосунова', 1611, 'PLATINUM'),
      (3, 'Нурлан Абдыкадыров', 1488, 'GOLD'),
      (4, 'Элнура Мамытова', 1302, 'GOLD'),
      (5, 'Айназик Токтомаматова', 1234, 'SILVER'),
      (6, 'Азамат Жумабаев', 1090, 'BRONZE'),
    ])
      GameRating.fromJson({'userId': i, 'fullName': name, 'rating': rating, 'rank': i, 'league': league, 'leagueName': switch (league) { 'DIAMOND' => 'Алмаз', 'PLATINUM' => 'Платина', 'GOLD' => 'Алтын', 'SILVER' => 'Күмүш', _ => 'Коло' }}),
  ];

  @override
  Future<GameRating> getMyRating() => _later(GameRating.fromJson({'userId': 5, 'fullName': 'Айназик Токтомаматова', 'rating': 1234, 'league': 'SILVER', 'leagueName': 'Күмүш', 'nextLeagueRating': 1300, 'rank': 5, 'winStreak': 3, 'gamesPlayed': 20, 'wins': 12, 'losses': 7, 'draws': 1}));
  @override
  Future<PagedResult<GameRating>> getLeaderboard({int page = 0, int size = 50}) => _later(PagedResult(content: _players, totalElements: _players.length, number: 0, last: true));
  @override
  Future<List<GameTestModel>> getGameTests({bool unplayedOnly = false}) => _later([
    GameTestModel(id: 1, title: 'Бөлчөктөр', description: 'Тез эсептөө боюнча дуэль', timeLimitSeconds: 20, questionsPerGame: 10, questionCount: 60, played: !unplayedOnly, myBestScore: unplayedOnly ? null : 8, playCount: unplayedOnly ? 0 : 4),
    if (unplayedOnly) GameTestModel(id: 2, title: 'Сөз түркүмдөрү', description: 'Грамматика боюнча дуэль', timeLimitSeconds: 20, questionsPerGame: 10, questionCount: 45),
  ]);
  @override
  Future<List<GameHistoryEntry>> getHistory() => _later([
    GameHistoryEntry(roomId: 1, gameTestId: 1, gameTestTitle: 'Бөлчөктөр', score: 8, opponentScore: 6, totalQuestions: 10, won: true, draw: false, vsBot: false, forfeited: false, opponentName: 'Азамат Ж.', opponentAvatar: null, playedAt: DateTime(2026, 9, 16), ratingChange: 14, ratingAfter: 1234),
    GameHistoryEntry(roomId: 2, gameTestId: 1, gameTestTitle: 'Бөлчөктөр', score: 5, opponentScore: 7, totalQuestions: 10, won: false, draw: false, vsBot: true, forfeited: false, opponentName: 'Бот', opponentAvatar: null, playedAt: DateTime(2026, 9, 15), ratingChange: -5, ratingAfter: 1220),
  ]);
}

class DemoNotifications with _Demo implements NotificationsRepository {
  @override
  Future<int> getUnreadCount() async => 2;
}

class DemoProfile with _Demo implements ProfileRepository {
  @override
  Future<ProfileResponse> getUserInfo() => _later(const ProfileResponse(id: 5, firstName: 'Айназик', lastName: 'Токтомаматова'));
}

class DemoUser with _Demo implements UserRepository {
  @override
  Future<UserModel?> getUser() async => UserModel(
    firstName: 'Айназик',
    lastName: 'Токтомаматова',
    region: 'Бишкек',
    description: 'ЖРТга даярданып жатам',
    regionId: 1,
    totalScore: 163,
    completedTests: 12,
  );
}

class DemoRegions with _Demo implements RegionsRepository {
  @override
  Future<List<Region>> getRegions() => _later(const [
    Region(id: 1, name: 'Бишкек', nameKy: 'Бишкек'),
    Region(id: 2, name: 'Чуйская область', nameKy: 'Чүй облусу'),
    Region(id: 3, name: 'Ошская область', nameKy: 'Ош облусу'),
  ]);
}

class DemoOther with _Demo implements HomeRepository, NewsRepository, AnalystRepository, VideoLessonsRepository, OrtTestsRepository, PaymentRepository, ImageRepository {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
  );
  await dotenv.load();
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('lang', prefs.getString('lang') ?? 'ky');

  final other = DemoOther();
  GetIt.I
    ..registerSingleton<LanguageRepository>(LanguageRepository(prefs))
    ..registerSingleton<Dio>(Dio())
    ..registerSingleton<AuthRepository>(DemoAuth())
    ..registerSingleton<OrtAttemptRepository>(DemoAttempts())
    ..registerSingleton<CatalogRepository>(DemoCatalog())
    ..registerSingleton<SchoolRepository>(DemoSchools())
    ..registerSingleton<ReferralRepository>(DemoReferrals())
    ..registerSingleton<GameRepository>(DemoGames())
    ..registerSingleton<NotificationsRepository>(DemoNotifications())
    ..registerSingleton<ProfileRepository>(DemoProfile())
    ..registerSingleton<UserRepository>(DemoUser())
    ..registerSingleton<RegionsRepository>(DemoRegions())
    ..registerSingleton<HomeRepository>(other)
    ..registerSingleton<NewsRepository>(other)
    ..registerSingleton<AnalystRepository>(other)
    ..registerSingleton<VideoLessonsRepository>(other)
    ..registerSingleton<OrtTestsRepository>(other)
    ..registerSingleton<PaymentRepository>(other)
    ..registerSingleton<ImageRepository>(other);
  GetIt.I.registerLazySingleton<LanguageBloc>(
    () => LanguageBloc(GetIt.I<LanguageRepository>(), GetIt.I<ProfileRepository>()),
  );
  GetIt.I.registerLazySingleton<AppAuthBloc>(
    () => AppAuthBloc(authRepository: GetIt.I<AuthRepository>()),
  );
  GetIt.I.registerLazySingleton<GoRouter>(() => createRouter(GetIt.I<AppAuthBloc>()));

  runApp(SynamykApp(prefs: prefs));
}
