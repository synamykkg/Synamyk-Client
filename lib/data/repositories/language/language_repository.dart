import 'package:shared_preferences/shared_preferences.dart';
import 'package:synamyk/domain/enums/app_language.dart';

class LanguageRepository {
  final SharedPreferences _prefs;

  LanguageRepository(this._prefs);

  AppLanguage get current {
    final code = _prefs.getString('lang') ?? 'ru';
    return AppLanguage.fromCode(code);
  }

  Future<void> save(AppLanguage language) async {
    await _prefs.setString('lang', language.apiCode);
  }
}