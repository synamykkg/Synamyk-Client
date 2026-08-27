// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(message) => "Ошибка: ${message}";

  static String m1(correct, total) => "${correct} из ${total}";

  static String m2(count) => "${count} минут";

  static String m3(number) => "Вопрос ${number}";

  static String m4(count) => "${count} вопросов";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aiAnalysis": MessageLookupByLibrary.simpleMessage("Анализ ИИ"),
    "aiExplanation": MessageLookupByLibrary.simpleMessage("Объяснение ИИ:"),
    "analystError": m0,
    "analyzeWithAi": MessageLookupByLibrary.simpleMessage(
      "Анализ при помощи ИИ",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("Synamyk"),
    "calculationSum": MessageLookupByLibrary.simpleMessage("Вычисление суммы"),
    "changePassword": MessageLookupByLibrary.simpleMessage("Изменить пароль"),
    "changePhone": MessageLookupByLibrary.simpleMessage(
      "Изменить номер телефона",
    ),
    "changeRegion": MessageLookupByLibrary.simpleMessage("Изменить регион"),
    "confirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Подтвердите новый пароль",
    ),
    "correctAnswer": MessageLookupByLibrary.simpleMessage("Правильный ответ:"),
    "correctAnswers": MessageLookupByLibrary.simpleMessage(
      "правильных ответов",
    ),
    "correctAnswersOf": m1,
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Удалить аккаунт"),
    "deleteAccountMessage": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите удалить аккаунт?",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Описание"),
    "editProfile": MessageLookupByLibrary.simpleMessage(
      "Редактировать профиль",
    ),
    "errorConnectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Превышено время ожидания",
    ),
    "errorNetwork": MessageLookupByLibrary.simpleMessage(
      "Проверьте подключение к интернету",
    ),
    "errorNoContent": MessageLookupByLibrary.simpleMessage("Контент не найден"),
    "errorNotFound": MessageLookupByLibrary.simpleMessage("Ресурс не найден"),
    "errorOccurred": MessageLookupByLibrary.simpleMessage("Произошла ошибка"),
    "errorServer": MessageLookupByLibrary.simpleMessage(
      "Ошибка сервера, попробуйте позже",
    ),
    "errorTokenExpired": MessageLookupByLibrary.simpleMessage(
      "Сессия истекла, войдите снова",
    ),
    "errorUnauthorized": MessageLookupByLibrary.simpleMessage(
      "Необходима авторизация",
    ),
    "errorUnknown": MessageLookupByLibrary.simpleMessage("Неизвестная ошибка"),
    "errorValidation": MessageLookupByLibrary.simpleMessage(
      "Проверьте правильность данных",
    ),
    "exitTestCancel": MessageLookupByLibrary.simpleMessage("Нет"),
    "exitTestConfirm": MessageLookupByLibrary.simpleMessage("Да, хочу"),
    "exitTestMessage": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите прервать тест?",
    ),
    "exitTestTitle": MessageLookupByLibrary.simpleMessage("Прервать тест?"),
    "firstName": MessageLookupByLibrary.simpleMessage("Имя"),
    "freeLevel": MessageLookupByLibrary.simpleMessage("Бесплатный уровень"),
    "homeTests": MessageLookupByLibrary.simpleMessage("Тесты "),
    "langEnglish": MessageLookupByLibrary.simpleMessage("English"),
    "langKyrgyz": MessageLookupByLibrary.simpleMessage("Кыргызча"),
    "langRussian": MessageLookupByLibrary.simpleMessage("Русский"),
    "lastName": MessageLookupByLibrary.simpleMessage("Фамилия"),
    "levelOne": MessageLookupByLibrary.simpleMessage("1-уровень"),
    "minutes": m2,
    "navAnalysis": MessageLookupByLibrary.simpleMessage("Анализ"),
    "navFeed": MessageLookupByLibrary.simpleMessage("Лента"),
    "navHome": MessageLookupByLibrary.simpleMessage("Главная"),
    "navProfile": MessageLookupByLibrary.simpleMessage("Профиль"),
    "newPassword": MessageLookupByLibrary.simpleMessage("Новый пароль"),
    "newPhone": MessageLookupByLibrary.simpleMessage("Новый номер телефона"),
    "newsDetails": MessageLookupByLibrary.simpleMessage("Детали новости"),
    "next": MessageLookupByLibrary.simpleMessage("Следующий"),
    "oldPassword": MessageLookupByLibrary.simpleMessage("Старый пароль"),
    "oldPhone": MessageLookupByLibrary.simpleMessage("Старый номер телефона"),
    "ortDescription": MessageLookupByLibrary.simpleMessage(
      "ОРТ — это вступительный экзамен, результаты которого учитываются при поступлении в университеты Кыргызстана.",
    ),
    "ortTitle": MessageLookupByLibrary.simpleMessage("ОРТ"),
    "passwordChanged": MessageLookupByLibrary.simpleMessage(
      "Пароль успешно изменен",
    ),
    "periodMonth": MessageLookupByLibrary.simpleMessage("Месяц"),
    "periodSixMonths": MessageLookupByLibrary.simpleMessage("Шесть месяцев"),
    "periodThreeMonths": MessageLookupByLibrary.simpleMessage("Три месяца"),
    "periodWeek": MessageLookupByLibrary.simpleMessage("Неделя"),
    "periodYear": MessageLookupByLibrary.simpleMessage("Год"),
    "points": MessageLookupByLibrary.simpleMessage("очков"),
    "profileTitle": MessageLookupByLibrary.simpleMessage("Профиль"),
    "questionNumber": m3,
    "questions": m4,
    "rating": MessageLookupByLibrary.simpleMessage("рейтинг"),
    "region": MessageLookupByLibrary.simpleMessage("Регион"),
    "regionChanged": MessageLookupByLibrary.simpleMessage(
      "Регион успешно изменен",
    ),
    "resultSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Отлично! Ты настоящий знаток математики!",
    ),
    "results": MessageLookupByLibrary.simpleMessage("Результаты"),
    "saveData": MessageLookupByLibrary.simpleMessage("Сохранить данные"),
    "score": MessageLookupByLibrary.simpleMessage("балла"),
    "selectOption": MessageLookupByLibrary.simpleMessage("Выберите опцию"),
    "settingsData": MessageLookupByLibrary.simpleMessage("Настройка данных"),
    "settingsLanguage": MessageLookupByLibrary.simpleMessage("Язык интерфейса"),
    "skipQuestion": MessageLookupByLibrary.simpleMessage("Пропустить вопрос"),
    "subjectUnavailable": MessageLookupByLibrary.simpleMessage(
      "Предмет временно недоступен",
    ),
    "tabAnalytics": MessageLookupByLibrary.simpleMessage("График аналитики"),
    "tabVideoLessons": MessageLookupByLibrary.simpleMessage("Видео уроки"),
    "testLabel": MessageLookupByLibrary.simpleMessage("тест"),
    "timeLabel": MessageLookupByLibrary.simpleMessage("время"),
    "totalScore": MessageLookupByLibrary.simpleMessage("Общий балл"),
    "viewErrors": MessageLookupByLibrary.simpleMessage(
      "Просмотр ошибок в ответах.",
    ),
    "yourAnswer": MessageLookupByLibrary.simpleMessage("Ваш ответ:"),
    "yourResult": MessageLookupByLibrary.simpleMessage("Ваш результат"),
    "zeroMinutes": MessageLookupByLibrary.simpleMessage("0 минут"),
  };
}
