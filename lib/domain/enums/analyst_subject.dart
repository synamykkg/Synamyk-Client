enum AnalystSubject {
  general,
  english,
  russian,
  kyrgyz,
  arabic;

  String get label {
    switch (this) {
      case AnalystSubject.general:
        return 'Общий тест';
      case AnalystSubject.english:
        return 'Английский';
      case AnalystSubject.russian:
        return 'Русский';
      case AnalystSubject.kyrgyz:
        return 'Кыргызский';
      case AnalystSubject.arabic:
        return 'Арабский';
    }
  }
}
