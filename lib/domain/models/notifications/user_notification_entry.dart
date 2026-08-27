import 'package:synamyk/domain/enums/push_data_type.dart';

class UserNotificationEntry {
  UserNotificationEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.dataType,
    required this.dataEntityId,
    required this.read,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String body;
  final PushDataType dataType;
  final int? dataEntityId;
  final bool read;
  final DateTime createdAt;

  factory UserNotificationEntry.fromJson(Map<String, dynamic> json) {
    return UserNotificationEntry(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      dataType: PushDataType.fromJson(json['dataType'] as String?),
      dataEntityId: json['dataEntityId'] as int?,
      read: json['read'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
