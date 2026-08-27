import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/notifications/notification_settings.dart';
import 'package:synamyk/domain/models/notifications/user_notification_entry.dart';

abstract class NotificationsRepository {
  Future<void> registerDeviceToken(String token, String platform);

  Future<void> deleteDeviceToken(String token);

  Future<NotificationSettings> getSettings();

  Future<NotificationSettings> updateSettings({
    bool? results,
    bool? reminders,
    bool? marketing,
  });

  Future<PagedResult<UserNotificationEntry>> getInbox({
    int page = 0,
    int size = 20,
    bool unreadOnly = false,
  });

  Future<int> getUnreadCount();

  Future<void> markRead(int id);

  Future<void> markAllRead();
}
