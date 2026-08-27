class NotificationSettings {
  NotificationSettings({
    required this.results,
    required this.reminders,
    required this.marketing,
  });

  final bool results;
  final bool reminders;
  final bool marketing;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      results: json['results'] as bool? ?? true,
      reminders: json['reminders'] as bool? ?? true,
      marketing: json['marketing'] as bool? ?? true,
    );
  }
}
