import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static String policyUrl = 'https://ainaziiiiiii.github.io/privacy-policy/';
  static String tosUrl = 'https://app.notion.com/p/Terms-of-Service-Synamyk-3aea21ee902d802b9c60c579f2890643?source=copy_link';

  static String finikApiKey = dotenv.env['FINIK_API_KEY'] ?? '';
  static bool finikIsBeta = (dotenv.env['FINIK_IS_BETA'] ?? 'false').toLowerCase() == 'true';
  static String finikAccountId = dotenv.env['FINIK_ACCOUNT_ID'] ?? '';
}
