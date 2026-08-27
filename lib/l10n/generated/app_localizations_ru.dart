// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get errorNetwork => 'Проверьте подключение к интернету';

  @override
  String get errorConnectionTimeout => 'Превышено время ожидания';

  @override
  String get errorUnauthorized => 'Необходима авторизация';

  @override
  String get errorTokenExpired => 'Сессия истекла, войдите снова';

  @override
  String get errorServer => 'Ошибка сервера, попробуйте позже';

  @override
  String get errorNotFound => 'Ресурс не найден';

  @override
  String get errorValidation => 'Проверьте правильность данных';

  @override
  String get errorNoContent => 'Контент не найден';

  @override
  String get errorUnknown => 'Неизвестная ошибка';

  @override
  String get navHome => 'Главная';

  @override
  String get navFeed => 'Лента';

  @override
  String get navAnalysis => 'Анализ';

  @override
  String get navProfile => 'Профиль';

  @override
  String get homeTests => 'Тесты ';

  @override
  String get appName => 'Synamyk';

  @override
  String get ortTitle => 'ОРТ';

  @override
  String get ortDescription =>
      'ОРТ — это вступительный экзамен, результаты которого учитываются при поступлении в университеты Кыргызстана.';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get points => 'очков';

  @override
  String get score => 'балла';

  @override
  String get rating => 'рейтинг';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get settingsData => 'Настройка данных';

  @override
  String get settingsLanguage => 'Язык интерфейса';

  @override
  String get next => 'Следующий';

  @override
  String get skipQuestion => 'Пропустить вопрос';

  @override
  String get levelOne => '1-уровень';

  @override
  String get calculationSum => 'Вычисление суммы';

  @override
  String get yourResult => 'Ваш результат';

  @override
  String get resultSuccessMessage => 'Отлично! Ты настоящий знаток математики!';

  @override
  String get correctAnswers => 'правильных ответов';

  @override
  String get testLabel => 'тест';

  @override
  String get timeLabel => 'время';

  @override
  String get viewErrors => 'Просмотр ошибок в ответах.';

  @override
  String get zeroMinutes => '0 минут';

  @override
  String get freeLevel => 'Бесплатный уровень';

  @override
  String minutes(int count) {
    return '$count минут';
  }

  @override
  String questions(int count) {
    return '$count вопросов';
  }

  @override
  String get subjectUnavailable => 'Предмет временно недоступен';

  @override
  String get periodWeek => 'Неделя';

  @override
  String get periodMonth => 'Месяц';

  @override
  String get periodYear => 'Год';

  @override
  String get periodSixMonths => 'Шесть месяцев';

  @override
  String get periodThreeMonths => 'Три месяца';

  @override
  String get totalScore => 'Общий балл';

  @override
  String analystError(String message) {
    return 'Ошибка: $message';
  }

  @override
  String get tabAnalytics => 'График аналитики';

  @override
  String get tabVideoLessons => 'Видео уроки';

  @override
  String get selectOption => 'Выберите опцию';

  @override
  String get newsDetails => 'Детали новости';

  @override
  String get aiAnalysis => 'Анализ ИИ';

  @override
  String questionNumber(int number) {
    return 'Вопрос $number';
  }

  @override
  String get yourAnswer => 'Ваш ответ:';

  @override
  String get correctAnswer => 'Правильный ответ:';

  @override
  String get aiExplanation => 'Объяснение ИИ:';

  @override
  String get analyzeWithAi => 'Анализ при помощи ИИ';

  @override
  String get results => 'Результаты';

  @override
  String correctAnswersOf(int correct, int total) {
    return '$correct из $total';
  }

  @override
  String get exitTestTitle => 'Прервать тест?';

  @override
  String get exitTestMessage => 'Вы уверены, что хотите прервать тест?';

  @override
  String get exitTestConfirm => 'Да, хочу';

  @override
  String get exitTestCancel => 'Нет';

  @override
  String get changePassword => 'Изменить пароль';

  @override
  String get oldPassword => 'Старый пароль';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get confirmNewPassword => 'Подтвердите новый пароль';

  @override
  String get saveData => 'Сохранить данные';

  @override
  String get passwordChanged => 'Пароль успешно изменен';

  @override
  String get errorOccurred => 'Произошла ошибка';

  @override
  String get changePhone => 'Изменить номер телефона';

  @override
  String get oldPhone => 'Старый номер телефона';

  @override
  String get newPhone => 'Новый номер телефона';

  @override
  String get changeRegion => 'Изменить регион';

  @override
  String get region => 'Регион';

  @override
  String get regionChanged => 'Регион успешно изменен';

  @override
  String get langRussian => 'Русский';

  @override
  String get langEnglish => 'English';

  @override
  String get langKyrgyz => 'Кыргызча';

  @override
  String get firstName => 'Имя';

  @override
  String get lastName => 'Фамилия';

  @override
  String get description => 'Описание';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountMessage => 'Вы уверены, что хотите удалить аккаунт?';
}
