import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:synamyk/ui/core/ui/tr.dart';

/// «03 саат 35 мүн» / «3 ч 35 мин».
String formatHoursMinutes(BuildContext context, int totalMinutes) {
  final h = totalMinutes ~/ 60, m = totalMinutes % 60;
  if (context.isKy) {
    return h > 0
        ? '${h.toString().padLeft(2, '0')} саат ${m.toString().padLeft(2, '0')} мүн'
        : '$m мүн';
  }
  return h > 0 ? '$h ч ${m.toString().padLeft(2, '0')} мин' : '$m мин';
}

String formatMinutes(BuildContext context, int minutes) =>
    context.tr('$minutes мин', '$minutes мүн');

String formatQuestions(BuildContext context, int count) => context.isKy
    ? '$count суроо'
    : '$count ${_plural(count, 'вопрос', 'вопроса', 'вопросов')}';

/// `mm:ss`, or `h:mm:ss` past an hour.
String formatClock(int totalSeconds) {
  final s = totalSeconds < 0 ? 0 : totalSeconds;
  final h = s ~/ 3600, m = (s % 3600) ~/ 60, sec = s % 60;
  final mm = m.toString().padLeft(2, '0'), ss = sec.toString().padLeft(2, '0');
  return h > 0 ? '$h:$mm:$ss' : '$mm:$ss';
}

String formatDate(DateTime? date) =>
    date == null ? '' : DateFormat('dd.MM.yyyy').format(date);

String formatPercent(double value) => '${value.toStringAsFixed(1)}%';

String formatSom(double value) =>
    '${value == value.roundToDouble() ? value.toInt() : value.toStringAsFixed(2)} сом';

/// «242 күн 4 саат калды» / «242 дня 4 часа».
String formatCountdown(BuildContext context, int seconds) {
  final days = seconds ~/ 86400, hours = (seconds % 86400) ~/ 3600;
  if (context.isKy) return '$days күн $hours саат калды';
  return '$days ${_plural(days, 'день', 'дня', 'дней')} '
      '$hours ${_plural(hours, 'час', 'часа', 'часов')}';
}

String _plural(int n, String one, String few, String many) {
  final mod10 = n % 10, mod100 = n % 100;
  if (mod10 == 1 && mod100 != 11) return one;
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) return few;
  return many;
}
