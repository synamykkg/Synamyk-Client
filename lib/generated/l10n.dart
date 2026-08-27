// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Check your internet connection`
  String get errorNetwork {
    return Intl.message(
      'Check your internet connection',
      name: 'errorNetwork',
      desc: 'Network error',
      args: [],
    );
  }

  /// `Connection timed out`
  String get errorConnectionTimeout {
    return Intl.message(
      'Connection timed out',
      name: 'errorConnectionTimeout',
      desc: 'Connection timeout',
      args: [],
    );
  }

  /// `Authorization required`
  String get errorUnauthorized {
    return Intl.message(
      'Authorization required',
      name: 'errorUnauthorized',
      desc: 'Unauthorized',
      args: [],
    );
  }

  /// `Session expired, please sign in again`
  String get errorTokenExpired {
    return Intl.message(
      'Session expired, please sign in again',
      name: 'errorTokenExpired',
      desc: 'Token expired',
      args: [],
    );
  }

  /// `Server error, please try again later`
  String get errorServer {
    return Intl.message(
      'Server error, please try again later',
      name: 'errorServer',
      desc: '500 Internal Server Error',
      args: [],
    );
  }

  /// `Resource not found`
  String get errorNotFound {
    return Intl.message(
      'Resource not found',
      name: 'errorNotFound',
      desc: '404 Not Found',
      args: [],
    );
  }

  /// `Please check your input`
  String get errorValidation {
    return Intl.message(
      'Please check your input',
      name: 'errorValidation',
      desc: 'Validation error',
      args: [],
    );
  }

  /// `No content found`
  String get errorNoContent {
    return Intl.message(
      'No content found',
      name: 'errorNoContent',
      desc: '204 No Content',
      args: [],
    );
  }

  /// `Unknown error`
  String get errorUnknown {
    return Intl.message(
      'Unknown error',
      name: 'errorUnknown',
      desc: 'Unknown error',
      args: [],
    );
  }

  /// `Home`
  String get navHome {
    return Intl.message('Home', name: 'navHome', desc: '', args: []);
  }

  /// `Feed`
  String get navFeed {
    return Intl.message('Feed', name: 'navFeed', desc: '', args: []);
  }

  /// `Analysis`
  String get navAnalysis {
    return Intl.message('Analysis', name: 'navAnalysis', desc: '', args: []);
  }

  /// `Profile`
  String get navProfile {
    return Intl.message('Profile', name: 'navProfile', desc: '', args: []);
  }

  /// `Tests `
  String get homeTests {
    return Intl.message('Tests ', name: 'homeTests', desc: '', args: []);
  }

  /// `Synamyk`
  String get appName {
    return Intl.message('Synamyk', name: 'appName', desc: '', args: []);
  }

  /// `ORT`
  String get ortTitle {
    return Intl.message('ORT', name: 'ortTitle', desc: '', args: []);
  }

  /// `ORT is an entrance exam whose results are taken into account when applying to universities in Kyrgyzstan.`
  String get ortDescription {
    return Intl.message(
      'ORT is an entrance exam whose results are taken into account when applying to universities in Kyrgyzstan.',
      name: 'ortDescription',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTitle {
    return Intl.message('Profile', name: 'profileTitle', desc: '', args: []);
  }

  /// `points`
  String get points {
    return Intl.message('points', name: 'points', desc: '', args: []);
  }

  /// `score`
  String get score {
    return Intl.message('score', name: 'score', desc: '', args: []);
  }

  /// `rating`
  String get rating {
    return Intl.message('rating', name: 'rating', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Data Settings`
  String get settingsData {
    return Intl.message(
      'Data Settings',
      name: 'settingsData',
      desc: '',
      args: [],
    );
  }

  /// `Interface Language`
  String get settingsLanguage {
    return Intl.message(
      'Interface Language',
      name: 'settingsLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Skip question`
  String get skipQuestion {
    return Intl.message(
      'Skip question',
      name: 'skipQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Level 1`
  String get levelOne {
    return Intl.message('Level 1', name: 'levelOne', desc: '', args: []);
  }

  /// `Sum calculation`
  String get calculationSum {
    return Intl.message(
      'Sum calculation',
      name: 'calculationSum',
      desc: '',
      args: [],
    );
  }

  /// `Your result`
  String get yourResult {
    return Intl.message('Your result', name: 'yourResult', desc: '', args: []);
  }

  /// `Excellent! You are a true math expert!`
  String get resultSuccessMessage {
    return Intl.message(
      'Excellent! You are a true math expert!',
      name: 'resultSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `correct answers`
  String get correctAnswers {
    return Intl.message(
      'correct answers',
      name: 'correctAnswers',
      desc: '',
      args: [],
    );
  }

  /// `test`
  String get testLabel {
    return Intl.message('test', name: 'testLabel', desc: '', args: []);
  }

  /// `time`
  String get timeLabel {
    return Intl.message('time', name: 'timeLabel', desc: '', args: []);
  }

  /// `View errors in answers.`
  String get viewErrors {
    return Intl.message(
      'View errors in answers.',
      name: 'viewErrors',
      desc: '',
      args: [],
    );
  }

  /// `0 minutes`
  String get zeroMinutes {
    return Intl.message('0 minutes', name: 'zeroMinutes', desc: '', args: []);
  }

  /// `Free level`
  String get freeLevel {
    return Intl.message('Free level', name: 'freeLevel', desc: '', args: []);
  }

  /// `{count} minutes`
  String minutes(Object count) {
    return Intl.message(
      '$count minutes',
      name: 'minutes',
      desc: '',
      args: [count],
    );
  }

  /// `{count} questions`
  String questions(Object count) {
    return Intl.message(
      '$count questions',
      name: 'questions',
      desc: '',
      args: [count],
    );
  }

  /// `Subject is temporarily unavailable`
  String get subjectUnavailable {
    return Intl.message(
      'Subject is temporarily unavailable',
      name: 'subjectUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get periodWeek {
    return Intl.message('Week', name: 'periodWeek', desc: '', args: []);
  }

  /// `Month`
  String get periodMonth {
    return Intl.message('Month', name: 'periodMonth', desc: '', args: []);
  }

  /// `Year`
  String get periodYear {
    return Intl.message('Year', name: 'periodYear', desc: '', args: []);
  }

  /// `Six Months`
  String get periodSixMonths {
    return Intl.message(
      'Six Months',
      name: 'periodSixMonths',
      desc: '',
      args: [],
    );
  }

  /// `Three Months`
  String get periodThreeMonths {
    return Intl.message(
      'Three Months',
      name: 'periodThreeMonths',
      desc: '',
      args: [],
    );
  }

  /// `Total score`
  String get totalScore {
    return Intl.message('Total score', name: 'totalScore', desc: '', args: []);
  }

  /// `Error: {message}`
  String analystError(Object message) {
    return Intl.message(
      'Error: $message',
      name: 'analystError',
      desc: '',
      args: [message],
    );
  }

  /// `Analytics chart`
  String get tabAnalytics {
    return Intl.message(
      'Analytics chart',
      name: 'tabAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Video lessons`
  String get tabVideoLessons {
    return Intl.message(
      'Video lessons',
      name: 'tabVideoLessons',
      desc: '',
      args: [],
    );
  }

  /// `Select option`
  String get selectOption {
    return Intl.message(
      'Select option',
      name: 'selectOption',
      desc: '',
      args: [],
    );
  }

  /// `News Details`
  String get newsDetails {
    return Intl.message(
      'News Details',
      name: 'newsDetails',
      desc: '',
      args: [],
    );
  }

  /// `AI Analysis`
  String get aiAnalysis {
    return Intl.message('AI Analysis', name: 'aiAnalysis', desc: '', args: []);
  }

  /// `Question {number}`
  String questionNumber(Object number) {
    return Intl.message(
      'Question $number',
      name: 'questionNumber',
      desc: '',
      args: [number],
    );
  }

  /// `Your answer:`
  String get yourAnswer {
    return Intl.message('Your answer:', name: 'yourAnswer', desc: '', args: []);
  }

  /// `Correct answer:`
  String get correctAnswer {
    return Intl.message(
      'Correct answer:',
      name: 'correctAnswer',
      desc: '',
      args: [],
    );
  }

  /// `AI Explanation:`
  String get aiExplanation {
    return Intl.message(
      'AI Explanation:',
      name: 'aiExplanation',
      desc: '',
      args: [],
    );
  }

  /// `Analyze with AI`
  String get analyzeWithAi {
    return Intl.message(
      'Analyze with AI',
      name: 'analyzeWithAi',
      desc: '',
      args: [],
    );
  }

  /// `Results`
  String get results {
    return Intl.message('Results', name: 'results', desc: '', args: []);
  }

  /// `{correct} out of {total}`
  String correctAnswersOf(Object correct, Object total) {
    return Intl.message(
      '$correct out of $total',
      name: 'correctAnswersOf',
      desc: '',
      args: [correct, total],
    );
  }

  /// `Quit the test?`
  String get exitTestTitle {
    return Intl.message(
      'Quit the test?',
      name: 'exitTestTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to quit the test?`
  String get exitTestMessage {
    return Intl.message(
      'Are you sure you want to quit the test?',
      name: 'exitTestMessage',
      desc: '',
      args: [],
    );
  }

  /// `Yes, quit`
  String get exitTestConfirm {
    return Intl.message(
      'Yes, quit',
      name: 'exitTestConfirm',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get exitTestCancel {
    return Intl.message('No', name: 'exitTestCancel', desc: '', args: []);
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Old password`
  String get oldPassword {
    return Intl.message(
      'Old password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get newPassword {
    return Intl.message(
      'New password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm new password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get saveData {
    return Intl.message('Save', name: 'saveData', desc: '', args: []);
  }

  /// `Password changed successfully`
  String get passwordChanged {
    return Intl.message(
      'Password changed successfully',
      name: 'passwordChanged',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get errorOccurred {
    return Intl.message(
      'An error occurred',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Change phone number`
  String get changePhone {
    return Intl.message(
      'Change phone number',
      name: 'changePhone',
      desc: '',
      args: [],
    );
  }

  /// `Old phone number`
  String get oldPhone {
    return Intl.message(
      'Old phone number',
      name: 'oldPhone',
      desc: '',
      args: [],
    );
  }

  /// `New phone number`
  String get newPhone {
    return Intl.message(
      'New phone number',
      name: 'newPhone',
      desc: '',
      args: [],
    );
  }

  /// `Change region`
  String get changeRegion {
    return Intl.message(
      'Change region',
      name: 'changeRegion',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get region {
    return Intl.message('Region', name: 'region', desc: '', args: []);
  }

  /// `Region changed successfully`
  String get regionChanged {
    return Intl.message(
      'Region changed successfully',
      name: 'regionChanged',
      desc: '',
      args: [],
    );
  }

  /// `Русский`
  String get langRussian {
    return Intl.message('Русский', name: 'langRussian', desc: '', args: []);
  }

  /// `English`
  String get langEnglish {
    return Intl.message('English', name: 'langEnglish', desc: '', args: []);
  }

  /// `Кыргызча`
  String get langKyrgyz {
    return Intl.message('Кыргызча', name: 'langKyrgyz', desc: '', args: []);
  }

  /// `First name`
  String get firstName {
    return Intl.message('First name', name: 'firstName', desc: '', args: []);
  }

  /// `Last name`
  String get lastName {
    return Intl.message('Last name', name: 'lastName', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Delete account`
  String get deleteAccount {
    return Intl.message(
      'Delete account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account?`
  String get deleteAccountMessage {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'deleteAccountMessage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ky'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
