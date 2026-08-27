enum AnalyticsPeriod {
  week,
  month,
  threeMonths,
  sixMonths,
  year;

  String get label {
    switch (this) {
      case AnalyticsPeriod.week:
        return 'Неделя';
      case AnalyticsPeriod.month:
        return 'Месяц';
      case AnalyticsPeriod.threeMonths:
        return '3 месяца';
      case AnalyticsPeriod.sixMonths:
        return 'Полгода';
      case AnalyticsPeriod.year:
        return 'Год';
    }
  }
}
