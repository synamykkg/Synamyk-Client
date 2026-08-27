// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kirghiz Kyrgyz (`ky`).
class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy([String locale = 'ky']) : super(locale);

  @override
  String get errorNetwork => 'Интернет туташуусун текшериңиз';

  @override
  String get errorConnectionTimeout => 'Туташуу убактысы өттү';

  @override
  String get errorUnauthorized => 'Авторизация талап кылынат';

  @override
  String get errorTokenExpired => 'Сессия аяктады, кайра кириңиз';

  @override
  String get errorServer => 'Сервер катасы, кийинчерээк аракет кылыңыз';

  @override
  String get errorNotFound => 'Ресурс табылган жок';

  @override
  String get errorValidation => 'Маалыматтардын туруктуулугун текшериңиз';

  @override
  String get errorNoContent => 'Мазмун табылган жок';

  @override
  String get errorUnknown => 'Белгисиз ката';

  @override
  String get navHome => 'Башкы бет';

  @override
  String get navFeed => 'Түрмөк';

  @override
  String get navAnalysis => 'Талдоо';

  @override
  String get navProfile => 'Профиль';

  @override
  String get homeTests => 'Тесттер ';

  @override
  String get appName => 'Synamyk';

  @override
  String get ortTitle => 'ОРТ';

  @override
  String get ortDescription =>
      'ОРТ — Кыргызстандын университеттерине түшүүдө эске алынуучу кириш экзамени.';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get points => 'упай';

  @override
  String get score => 'балл';

  @override
  String get rating => 'рейтинг';

  @override
  String get editProfile => 'Профилди өзгөртүү';

  @override
  String get settingsData => 'Маалымат жөндөөлөрү';

  @override
  String get settingsLanguage => 'Интерфейс тили';

  @override
  String get next => 'Кийинки';

  @override
  String get skipQuestion => 'Суроону өткөрүп жибер';

  @override
  String get levelOne => '1-деңгээл';

  @override
  String get calculationSum => 'Суммаларды эсептөө';

  @override
  String get yourResult => 'Сиздин натыйжаңыз';

  @override
  String get resultSuccessMessage =>
      'Мыкты! Сен чыныгы математика билермансың!';

  @override
  String get correctAnswers => 'туура жооп';

  @override
  String get testLabel => 'тест';

  @override
  String get timeLabel => 'убакыт';

  @override
  String get viewErrors => 'Жооптордогу каталарды көрүү.';

  @override
  String get zeroMinutes => '0 мүнөт';

  @override
  String get freeLevel => 'Акысыз деңгээл';

  @override
  String minutes(int count) {
    return '$count мүнөт';
  }

  @override
  String questions(int count) {
    return '$count суроо';
  }

  @override
  String get subjectUnavailable => 'Предмет убактылуу жеткиликсиз';

  @override
  String get periodWeek => 'Апта';

  @override
  String get periodMonth => 'Ай';

  @override
  String get periodYear => 'Жыл';

  @override
  String get periodSixMonths => 'Алты ай';

  @override
  String get periodThreeMonths => 'Үч ай';

  @override
  String get totalScore => 'Жалпы балл';

  @override
  String analystError(String message) {
    return 'Ката: $message';
  }

  @override
  String get tabAnalytics => 'Аналитика графиги';

  @override
  String get tabVideoLessons => 'Видео сабактар';

  @override
  String get selectOption => 'Параметрди тандаңыз';

  @override
  String get newsDetails => 'Жаңылыктын чоо-жайы';

  @override
  String get aiAnalysis => 'ЖИ Талдоосу';

  @override
  String questionNumber(int number) {
    return '$number-суроо';
  }

  @override
  String get yourAnswer => 'Сиздин жообуңуз:';

  @override
  String get correctAnswer => 'Туура жооп:';

  @override
  String get aiExplanation => 'ЖИ түшүндүрмөсү:';

  @override
  String get analyzeWithAi => 'ЖИ аркылуу талдоо';

  @override
  String get results => 'Натыйжалар';

  @override
  String correctAnswersOf(int correct, int total) {
    return '$total дон $correct';
  }

  @override
  String get exitTestTitle => 'Тестти токтотосузбу?';

  @override
  String get exitTestMessage => 'Чынында эле тестти токтоткуңуз келеби?';

  @override
  String get exitTestConfirm => 'Ооба, токтотом';

  @override
  String get exitTestCancel => 'Жок';

  @override
  String get changePassword => 'Сырсөздү өзгөртүү';

  @override
  String get oldPassword => 'Эски сырсөз';

  @override
  String get newPassword => 'Жаңы сырсөз';

  @override
  String get confirmNewPassword => 'Жаңы сырсөздү ырастаңыз';

  @override
  String get saveData => 'Сактоо';

  @override
  String get passwordChanged => 'Сырсөз ийгиликтүү өзгөртүлдү';

  @override
  String get errorOccurred => 'Ката кетти';

  @override
  String get changePhone => 'Телефон номерин өзгөртүү';

  @override
  String get oldPhone => 'Эски телефон номери';

  @override
  String get newPhone => 'Жаңы телефон номери';

  @override
  String get changeRegion => 'Регионду өзгөртүү';

  @override
  String get region => 'Регион';

  @override
  String get regionChanged => 'Регион ийгиликтүү өзгөртүлдү';

  @override
  String get langRussian => 'Русский';

  @override
  String get langEnglish => 'English';

  @override
  String get langKyrgyz => 'Кыргызча';

  @override
  String get firstName => 'Аты';

  @override
  String get lastName => 'Фамилиясы';

  @override
  String get description => 'Сүрөттөмө';

  @override
  String get deleteAccount => 'Аккаунтту жок кылуу';

  @override
  String get deleteAccountMessage =>
      'Чынында эле аккаунтуңузду жок кылгыңыз келеби?';
}
