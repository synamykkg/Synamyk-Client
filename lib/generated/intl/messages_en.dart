// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(message) => "Error: ${message}";

  static String m1(correct, total) => "${correct} out of ${total}";

  static String m2(count) => "${count} minutes";

  static String m3(number) => "Question ${number}";

  static String m4(count) => "${count} questions";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aiAnalysis": MessageLookupByLibrary.simpleMessage("AI Analysis"),
    "aiExplanation": MessageLookupByLibrary.simpleMessage("AI Explanation:"),
    "analystError": m0,
    "analyzeWithAi": MessageLookupByLibrary.simpleMessage("Analyze with AI"),
    "appName": MessageLookupByLibrary.simpleMessage("Synamyk"),
    "calculationSum": MessageLookupByLibrary.simpleMessage("Sum calculation"),
    "changePassword": MessageLookupByLibrary.simpleMessage("Change password"),
    "changePhone": MessageLookupByLibrary.simpleMessage("Change phone number"),
    "changeRegion": MessageLookupByLibrary.simpleMessage("Change region"),
    "confirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Confirm new password",
    ),
    "correctAnswer": MessageLookupByLibrary.simpleMessage("Correct answer:"),
    "correctAnswers": MessageLookupByLibrary.simpleMessage("correct answers"),
    "correctAnswersOf": m1,
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete account"),
    "deleteAccountMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete your account?",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "errorConnectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Connection timed out",
    ),
    "errorNetwork": MessageLookupByLibrary.simpleMessage(
      "Check your internet connection",
    ),
    "errorNoContent": MessageLookupByLibrary.simpleMessage("No content found"),
    "errorNotFound": MessageLookupByLibrary.simpleMessage("Resource not found"),
    "errorOccurred": MessageLookupByLibrary.simpleMessage("An error occurred"),
    "errorServer": MessageLookupByLibrary.simpleMessage(
      "Server error, please try again later",
    ),
    "errorTokenExpired": MessageLookupByLibrary.simpleMessage(
      "Session expired, please sign in again",
    ),
    "errorUnauthorized": MessageLookupByLibrary.simpleMessage(
      "Authorization required",
    ),
    "errorUnknown": MessageLookupByLibrary.simpleMessage("Unknown error"),
    "errorValidation": MessageLookupByLibrary.simpleMessage(
      "Please check your input",
    ),
    "exitTestCancel": MessageLookupByLibrary.simpleMessage("No"),
    "exitTestConfirm": MessageLookupByLibrary.simpleMessage("Yes, quit"),
    "exitTestMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to quit the test?",
    ),
    "exitTestTitle": MessageLookupByLibrary.simpleMessage("Quit the test?"),
    "firstName": MessageLookupByLibrary.simpleMessage("First name"),
    "freeLevel": MessageLookupByLibrary.simpleMessage("Free level"),
    "homeTests": MessageLookupByLibrary.simpleMessage("Tests "),
    "langEnglish": MessageLookupByLibrary.simpleMessage("English"),
    "langKyrgyz": MessageLookupByLibrary.simpleMessage("Кыргызча"),
    "langRussian": MessageLookupByLibrary.simpleMessage("Русский"),
    "lastName": MessageLookupByLibrary.simpleMessage("Last name"),
    "levelOne": MessageLookupByLibrary.simpleMessage("Level 1"),
    "minutes": m2,
    "navAnalysis": MessageLookupByLibrary.simpleMessage("Analysis"),
    "navFeed": MessageLookupByLibrary.simpleMessage("Feed"),
    "navHome": MessageLookupByLibrary.simpleMessage("Home"),
    "navProfile": MessageLookupByLibrary.simpleMessage("Profile"),
    "newPassword": MessageLookupByLibrary.simpleMessage("New password"),
    "newPhone": MessageLookupByLibrary.simpleMessage("New phone number"),
    "newsDetails": MessageLookupByLibrary.simpleMessage("News Details"),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "oldPassword": MessageLookupByLibrary.simpleMessage("Old password"),
    "oldPhone": MessageLookupByLibrary.simpleMessage("Old phone number"),
    "ortDescription": MessageLookupByLibrary.simpleMessage(
      "ORT is an entrance exam whose results are taken into account when applying to universities in Kyrgyzstan.",
    ),
    "ortTitle": MessageLookupByLibrary.simpleMessage("ORT"),
    "passwordChanged": MessageLookupByLibrary.simpleMessage(
      "Password changed successfully",
    ),
    "periodMonth": MessageLookupByLibrary.simpleMessage("Month"),
    "periodSixMonths": MessageLookupByLibrary.simpleMessage("Six Months"),
    "periodThreeMonths": MessageLookupByLibrary.simpleMessage("Three Months"),
    "periodWeek": MessageLookupByLibrary.simpleMessage("Week"),
    "periodYear": MessageLookupByLibrary.simpleMessage("Year"),
    "points": MessageLookupByLibrary.simpleMessage("points"),
    "profileTitle": MessageLookupByLibrary.simpleMessage("Profile"),
    "questionNumber": m3,
    "questions": m4,
    "rating": MessageLookupByLibrary.simpleMessage("rating"),
    "region": MessageLookupByLibrary.simpleMessage("Region"),
    "regionChanged": MessageLookupByLibrary.simpleMessage(
      "Region changed successfully",
    ),
    "resultSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Excellent! You are a true math expert!",
    ),
    "results": MessageLookupByLibrary.simpleMessage("Results"),
    "saveData": MessageLookupByLibrary.simpleMessage("Save"),
    "score": MessageLookupByLibrary.simpleMessage("score"),
    "selectOption": MessageLookupByLibrary.simpleMessage("Select option"),
    "settingsData": MessageLookupByLibrary.simpleMessage("Data Settings"),
    "settingsLanguage": MessageLookupByLibrary.simpleMessage(
      "Interface Language",
    ),
    "skipQuestion": MessageLookupByLibrary.simpleMessage("Skip question"),
    "subjectUnavailable": MessageLookupByLibrary.simpleMessage(
      "Subject is temporarily unavailable",
    ),
    "tabAnalytics": MessageLookupByLibrary.simpleMessage("Analytics chart"),
    "tabVideoLessons": MessageLookupByLibrary.simpleMessage("Video lessons"),
    "testLabel": MessageLookupByLibrary.simpleMessage("test"),
    "timeLabel": MessageLookupByLibrary.simpleMessage("time"),
    "totalScore": MessageLookupByLibrary.simpleMessage("Total score"),
    "viewErrors": MessageLookupByLibrary.simpleMessage(
      "View errors in answers.",
    ),
    "yourAnswer": MessageLookupByLibrary.simpleMessage("Your answer:"),
    "yourResult": MessageLookupByLibrary.simpleMessage("Your result"),
    "zeroMinutes": MessageLookupByLibrary.simpleMessage("0 minutes"),
  };
}
