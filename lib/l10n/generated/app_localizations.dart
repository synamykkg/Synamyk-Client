import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ky'),
    Locale('ru'),
  ];

  /// Ошибка сети
  ///
  /// In ru, this message translates to:
  /// **'Проверьте подключение к интернету'**
  String get errorNetwork;

  /// Таймаут соединения
  ///
  /// In ru, this message translates to:
  /// **'Превышено время ожидания'**
  String get errorConnectionTimeout;

  /// Не авторизован
  ///
  /// In ru, this message translates to:
  /// **'Необходима авторизация'**
  String get errorUnauthorized;

  /// Токен протух
  ///
  /// In ru, this message translates to:
  /// **'Сессия истекла, войдите снова'**
  String get errorTokenExpired;

  /// 500 Internal Server Error
  ///
  /// In ru, this message translates to:
  /// **'Ошибка сервера, попробуйте позже'**
  String get errorServer;

  /// 404 Not Found
  ///
  /// In ru, this message translates to:
  /// **'Ресурс не найден'**
  String get errorNotFound;

  /// Ошибка валидации
  ///
  /// In ru, this message translates to:
  /// **'Проверьте правильность данных'**
  String get errorValidation;

  /// 204 No Content
  ///
  /// In ru, this message translates to:
  /// **'Контент не найден'**
  String get errorNoContent;

  /// Неизвестная ошибка
  ///
  /// In ru, this message translates to:
  /// **'Неизвестная ошибка'**
  String get errorUnknown;

  /// Нижняя навигация — Главная
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get navHome;

  /// Нижняя навигация — Лента
  ///
  /// In ru, this message translates to:
  /// **'Лента'**
  String get navFeed;

  /// Нижняя навигация — Анализ
  ///
  /// In ru, this message translates to:
  /// **'Анализ'**
  String get navAnalysis;

  /// Нижняя навигация — Профиль
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get navProfile;

  /// Заголовок главной страницы
  ///
  /// In ru, this message translates to:
  /// **'Тесты '**
  String get homeTests;

  /// Название приложения
  ///
  /// In ru, this message translates to:
  /// **'Synamyk'**
  String get appName;

  /// Название экзамена
  ///
  /// In ru, this message translates to:
  /// **'ОРТ'**
  String get ortTitle;

  /// Описание ОРТ
  ///
  /// In ru, this message translates to:
  /// **'ОРТ — это вступительный экзамен, результаты которого учитываются при поступлении в университеты Кыргызстана.'**
  String get ortDescription;

  /// Заголовок страницы профиля
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileTitle;

  /// Очки
  ///
  /// In ru, this message translates to:
  /// **'очков'**
  String get points;

  /// Баллы
  ///
  /// In ru, this message translates to:
  /// **'балла'**
  String get score;

  /// Рейтинг
  ///
  /// In ru, this message translates to:
  /// **'рейтинг'**
  String get rating;

  /// Кнопка редактирования профиля
  ///
  /// In ru, this message translates to:
  /// **'Редактировать профиль'**
  String get editProfile;

  /// Настройки данных
  ///
  /// In ru, this message translates to:
  /// **'Настройка данных'**
  String get settingsData;

  /// Настройка языка
  ///
  /// In ru, this message translates to:
  /// **'Язык интерфейса'**
  String get settingsLanguage;

  /// Кнопка следующий
  ///
  /// In ru, this message translates to:
  /// **'Следующий'**
  String get next;

  /// Кнопка пропуска вопроса
  ///
  /// In ru, this message translates to:
  /// **'Пропустить вопрос'**
  String get skipQuestion;

  /// Первый уровень
  ///
  /// In ru, this message translates to:
  /// **'1-уровень'**
  String get levelOne;

  /// Тип задания
  ///
  /// In ru, this message translates to:
  /// **'Вычисление суммы'**
  String get calculationSum;

  /// Результат теста
  ///
  /// In ru, this message translates to:
  /// **'Ваш результат'**
  String get yourResult;

  /// Сообщение об успехе
  ///
  /// In ru, this message translates to:
  /// **'Отлично! Ты настоящий знаток математики!'**
  String get resultSuccessMessage;

  /// Правильные ответы
  ///
  /// In ru, this message translates to:
  /// **'правильных ответов'**
  String get correctAnswers;

  /// Лейбл теста
  ///
  /// In ru, this message translates to:
  /// **'тест'**
  String get testLabel;

  /// Лейбл времени
  ///
  /// In ru, this message translates to:
  /// **'время'**
  String get timeLabel;

  /// Кнопка просмотра ошибок
  ///
  /// In ru, this message translates to:
  /// **'Просмотр ошибок в ответах.'**
  String get viewErrors;

  /// Ноль минут
  ///
  /// In ru, this message translates to:
  /// **'0 минут'**
  String get zeroMinutes;

  /// Лейбл бесплатного теста
  ///
  /// In ru, this message translates to:
  /// **'Бесплатный уровень'**
  String get freeLevel;

  /// Количество минут
  ///
  /// In ru, this message translates to:
  /// **'{count} минут'**
  String minutes(int count);

  /// Количество вопросов
  ///
  /// In ru, this message translates to:
  /// **'{count} вопросов'**
  String questions(int count);

  /// Ошибка загрузки предмета
  ///
  /// In ru, this message translates to:
  /// **'Предмет временно недоступен'**
  String get subjectUnavailable;

  /// Период — неделя
  ///
  /// In ru, this message translates to:
  /// **'Неделя'**
  String get periodWeek;

  /// Период — месяц
  ///
  /// In ru, this message translates to:
  /// **'Месяц'**
  String get periodMonth;

  /// Период — год
  ///
  /// In ru, this message translates to:
  /// **'Год'**
  String get periodYear;

  /// Период — шесть месяцев
  ///
  /// In ru, this message translates to:
  /// **'Шесть месяцев'**
  String get periodSixMonths;

  /// Период — три месяца
  ///
  /// In ru, this message translates to:
  /// **'Три месяца'**
  String get periodThreeMonths;

  /// Общий балл аналитики
  ///
  /// In ru, this message translates to:
  /// **'Общий балл'**
  String get totalScore;

  /// Ошибка на странице аналитики
  ///
  /// In ru, this message translates to:
  /// **'Ошибка: {message}'**
  String analystError(String message);

  /// Таб — график аналитики
  ///
  /// In ru, this message translates to:
  /// **'График аналитики'**
  String get tabAnalytics;

  /// Таб — видео уроки
  ///
  /// In ru, this message translates to:
  /// **'Видео уроки'**
  String get tabVideoLessons;

  /// Плейсхолдер выбора опции
  ///
  /// In ru, this message translates to:
  /// **'Выберите опцию'**
  String get selectOption;

  /// Заголовок страницы новости
  ///
  /// In ru, this message translates to:
  /// **'Детали новости'**
  String get newsDetails;

  /// Заголовок страницы ИИ анализа
  ///
  /// In ru, this message translates to:
  /// **'Анализ ИИ'**
  String get aiAnalysis;

  /// Номер вопроса
  ///
  /// In ru, this message translates to:
  /// **'Вопрос {number}'**
  String questionNumber(int number);

  /// Лейбл ответа пользователя
  ///
  /// In ru, this message translates to:
  /// **'Ваш ответ:'**
  String get yourAnswer;

  /// Лейбл правильного ответа
  ///
  /// In ru, this message translates to:
  /// **'Правильный ответ:'**
  String get correctAnswer;

  /// Лейбл объяснения ИИ
  ///
  /// In ru, this message translates to:
  /// **'Объяснение ИИ:'**
  String get aiExplanation;

  /// Кнопка анализа через ИИ
  ///
  /// In ru, this message translates to:
  /// **'Анализ при помощи ИИ'**
  String get analyzeWithAi;

  /// Заголовок результатов
  ///
  /// In ru, this message translates to:
  /// **'Результаты'**
  String get results;

  /// Правильных ответов из total
  ///
  /// In ru, this message translates to:
  /// **'{correct} из {total}'**
  String correctAnswersOf(int correct, int total);

  /// Заголовок модала выхода из теста
  ///
  /// In ru, this message translates to:
  /// **'Прервать тест?'**
  String get exitTestTitle;

  /// Сообщение модала выхода из теста
  ///
  /// In ru, this message translates to:
  /// **'Вы уверены, что хотите прервать тест?'**
  String get exitTestMessage;

  /// Кнопка подтверждения выхода
  ///
  /// In ru, this message translates to:
  /// **'Да, хочу'**
  String get exitTestConfirm;

  /// Кнопка отмены выхода
  ///
  /// In ru, this message translates to:
  /// **'Нет'**
  String get exitTestCancel;

  /// Заголовок модала смены пароля
  ///
  /// In ru, this message translates to:
  /// **'Изменить пароль'**
  String get changePassword;

  /// Поле старого пароля
  ///
  /// In ru, this message translates to:
  /// **'Старый пароль'**
  String get oldPassword;

  /// Поле нового пароля
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль'**
  String get newPassword;

  /// Поле подтверждения пароля
  ///
  /// In ru, this message translates to:
  /// **'Подтвердите новый пароль'**
  String get confirmNewPassword;

  /// Кнопка сохранения
  ///
  /// In ru, this message translates to:
  /// **'Сохранить данные'**
  String get saveData;

  /// Успешная смена пароля
  ///
  /// In ru, this message translates to:
  /// **'Пароль успешно изменен'**
  String get passwordChanged;

  /// Общая ошибка
  ///
  /// In ru, this message translates to:
  /// **'Произошла ошибка'**
  String get errorOccurred;

  /// Заголовок модала смены телефона
  ///
  /// In ru, this message translates to:
  /// **'Изменить номер телефона'**
  String get changePhone;

  /// Поле старого номера телефона
  ///
  /// In ru, this message translates to:
  /// **'Старый номер телефона'**
  String get oldPhone;

  /// Поле нового номера телефона
  ///
  /// In ru, this message translates to:
  /// **'Новый номер телефона'**
  String get newPhone;

  /// Заголовок модала смены региона
  ///
  /// In ru, this message translates to:
  /// **'Изменить регион'**
  String get changeRegion;

  /// Лейбл поля региона
  ///
  /// In ru, this message translates to:
  /// **'Регион'**
  String get region;

  /// Успешная смена региона
  ///
  /// In ru, this message translates to:
  /// **'Регион успешно изменен'**
  String get regionChanged;

  /// Язык — русский
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get langRussian;

  /// Язык — английский
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// Язык — кыргызский
  ///
  /// In ru, this message translates to:
  /// **'Кыргызча'**
  String get langKyrgyz;

  /// Поле имени
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get firstName;

  /// Поле фамилии
  ///
  /// In ru, this message translates to:
  /// **'Фамилия'**
  String get lastName;

  /// Поле описания профиля
  ///
  /// In ru, this message translates to:
  /// **'Описание'**
  String get description;

  /// Кнопка удаления аккаунта
  ///
  /// In ru, this message translates to:
  /// **'Удалить аккаунт'**
  String get deleteAccount;

  /// Сообщение модала удаления аккаунта
  ///
  /// In ru, this message translates to:
  /// **'Вы уверены, что хотите удалить аккаунт?'**
  String get deleteAccountMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ky', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ky':
      return AppLocalizationsKy();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
