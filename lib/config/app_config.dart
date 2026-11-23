import 'dart:io' show Platform;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static String policyUrl = 'https://ainaziiiiiii.github.io/privacy-policy/';
  static String tosUrl = 'https://app.notion.com/p/Terms-of-Service-Synamyk-3aea21ee902d802b9c60c579f2890643?source=copy_link';

  /// «Разбор с ИИ» is off until the Anthropic balance is topped up.
  /// Build with --dart-define=AI_ANALYSIS=true to turn it back on.
  static const bool aiAnalysisEnabled =
      bool.fromEnvironment('AI_ANALYSIS', defaultValue: false);

  /// Paid unlocks go through Finik, which App Store guideline 3.1.1 forbids
  /// for digital content, so iOS hides every purchase entry point. Access
  /// bought on Android or earned via referrals still works after sign-in.
  static final bool paymentsEnabled = !Platform.isIOS;

  static String finikApiKey = dotenv.env['FINIK_API_KEY'] ?? '';
  static bool finikIsBeta = (dotenv.env['FINIK_IS_BETA'] ?? 'false').toLowerCase() == 'true';
  static String finikAccountId = dotenv.env['FINIK_ACCOUNT_ID'] ?? '';
}
