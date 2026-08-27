// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get errorNetwork => 'Check your internet connection';

  @override
  String get errorConnectionTimeout => 'Connection timed out';

  @override
  String get errorUnauthorized => 'Authorization required';

  @override
  String get errorTokenExpired => 'Session expired, please sign in again';

  @override
  String get errorServer => 'Server error, please try again later';

  @override
  String get errorNotFound => 'Resource not found';

  @override
  String get errorValidation => 'Please check your input';

  @override
  String get errorNoContent => 'No content found';

  @override
  String get errorUnknown => 'Unknown error';

  @override
  String get navHome => 'Home';

  @override
  String get navFeed => 'Feed';

  @override
  String get navAnalysis => 'Analysis';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeTests => 'Tests ';

  @override
  String get appName => 'Synamyk';

  @override
  String get ortTitle => 'ORT';

  @override
  String get ortDescription =>
      'ORT is an entrance exam whose results are taken into account when applying to universities in Kyrgyzstan.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get points => 'points';

  @override
  String get score => 'score';

  @override
  String get rating => 'rating';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get settingsData => 'Data Settings';

  @override
  String get settingsLanguage => 'Interface Language';

  @override
  String get next => 'Next';

  @override
  String get skipQuestion => 'Skip question';

  @override
  String get levelOne => 'Level 1';

  @override
  String get calculationSum => 'Sum calculation';

  @override
  String get yourResult => 'Your result';

  @override
  String get resultSuccessMessage => 'Excellent! You are a true math expert!';

  @override
  String get correctAnswers => 'correct answers';

  @override
  String get testLabel => 'test';

  @override
  String get timeLabel => 'time';

  @override
  String get viewErrors => 'View errors in answers.';

  @override
  String get zeroMinutes => '0 minutes';

  @override
  String get freeLevel => 'Free level';

  @override
  String minutes(int count) {
    return '$count minutes';
  }

  @override
  String questions(int count) {
    return '$count questions';
  }

  @override
  String get subjectUnavailable => 'Subject is temporarily unavailable';

  @override
  String get periodWeek => 'Week';

  @override
  String get periodMonth => 'Month';

  @override
  String get periodYear => 'Year';

  @override
  String get periodSixMonths => 'Six Months';

  @override
  String get periodThreeMonths => 'Three Months';

  @override
  String get totalScore => 'Total score';

  @override
  String analystError(String message) {
    return 'Error: $message';
  }

  @override
  String get tabAnalytics => 'Analytics chart';

  @override
  String get tabVideoLessons => 'Video lessons';

  @override
  String get selectOption => 'Select option';

  @override
  String get newsDetails => 'News Details';

  @override
  String get aiAnalysis => 'AI Analysis';

  @override
  String questionNumber(int number) {
    return 'Question $number';
  }

  @override
  String get yourAnswer => 'Your answer:';

  @override
  String get correctAnswer => 'Correct answer:';

  @override
  String get aiExplanation => 'AI Explanation:';

  @override
  String get analyzeWithAi => 'Analyze with AI';

  @override
  String get results => 'Results';

  @override
  String correctAnswersOf(int correct, int total) {
    return '$correct out of $total';
  }

  @override
  String get exitTestTitle => 'Quit the test?';

  @override
  String get exitTestMessage => 'Are you sure you want to quit the test?';

  @override
  String get exitTestConfirm => 'Yes, quit';

  @override
  String get exitTestCancel => 'No';

  @override
  String get changePassword => 'Change password';

  @override
  String get oldPassword => 'Old password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get saveData => 'Save';

  @override
  String get passwordChanged => 'Password changed successfully';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get changePhone => 'Change phone number';

  @override
  String get oldPhone => 'Old phone number';

  @override
  String get newPhone => 'New phone number';

  @override
  String get changeRegion => 'Change region';

  @override
  String get region => 'Region';

  @override
  String get regionChanged => 'Region changed successfully';

  @override
  String get langRussian => 'Русский';

  @override
  String get langEnglish => 'English';

  @override
  String get langKyrgyz => 'Кыргызча';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get description => 'Description';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountMessage =>
      'Are you sure you want to delete your account?';
}
