enum AppLanguage {
  russian,
  kyrgyz,
  english;

  // Для API
  String get apiCode => switch (this) {
    AppLanguage.russian  => 'RU',
    AppLanguage.kyrgyz   => 'KY',
    AppLanguage.english  => 'EN',
  };

  // Для MaterialApp и UI
  String get materialApp => switch (this) {
    AppLanguage.russian  => 'ru',
    AppLanguage.kyrgyz   => 'ky',
    AppLanguage.english  => 'en',
  };

  // Для i18next / локализации
  String get locale => switch (this) {
    AppLanguage.russian  => 'ru_RU',
    AppLanguage.kyrgyz   => 'ky_KG',
    AppLanguage.english  => 'en_US',
  };

  // Человекочитаемое название
  String get displayName => switch (this) {
    AppLanguage.russian  => 'Русский',
    AppLanguage.kyrgyz   => 'Кыргызча',
    AppLanguage.english  => 'English',
  };

  // Из строки (например из SharedPreferences)
  static AppLanguage fromCode(String code) => switch (code) {
    'ru' => AppLanguage.russian,
    'ky' => AppLanguage.kyrgyz,
    'en' => AppLanguage.english,
    _    => AppLanguage.russian, // дефолт
  };
}