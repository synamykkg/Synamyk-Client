import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart'
    hide UserNotificationEntry;
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/repositories/notifications/notifications_repository.dart';
import 'package:synamyk/domain/enums/push_data_type.dart';
import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/notifications/notification_settings.dart';
import 'package:synamyk/domain/models/notifications/user_notification_entry.dart';
import 'package:synamyk/error/api_error_parser.dart';
import 'package:synamyk/error/app_exception.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl({required this.synamykApi});

  final SynamykApiClient synamykApi;

  RegisterDeviceRequestPlatform _platformFrom(String platform) =>
      switch (platform) {
        'ANDROID' => RegisterDeviceRequestPlatform.android,
        'IOS' => RegisterDeviceRequestPlatform.ios,
        _ => RegisterDeviceRequestPlatform.web,
      };

  @override
  Future<void> registerDeviceToken(String token, String platform) async {
    try {
      final response = await synamykApi.auth.apiNotificationsDeviceTokenPost(
        body: RegisterDeviceRequest(
          token: token,
          platform: _platformFrom(platform),
        ),
      );
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(response.statusCode, response.error);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<void> deleteDeviceToken(String token) async {
    try {
      final response = await synamykApi.auth.apiNotificationsDeviceTokenDelete(
        token: token,
      );
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(response.statusCode, response.error);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<NotificationSettings> getSettings() async {
    try {
      final response = await synamykApi.auth.apiNotificationsSettingsGet();
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(response.statusCode, response.error);
      }
      final body = response.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      return NotificationSettings(
        results: body.results ?? true,
        reminders: body.reminders ?? true,
        marketing: body.marketing ?? true,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<NotificationSettings> updateSettings({
    bool? results,
    bool? reminders,
    bool? marketing,
  }) async {
    try {
      final response = await synamykApi.auth.apiNotificationsSettingsPatch(
        body: NotificationSettingsRequest(
          results: results,
          reminders: reminders,
          marketing: marketing,
        ),
      );
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(response.statusCode, response.error);
      }
      final body = response.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      return NotificationSettings(
        results: body.results ?? true,
        reminders: body.reminders ?? true,
        marketing: body.marketing ?? true,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<PagedResult<UserNotificationEntry>> getInbox({
    int page = 0,
    int size = 20,
    bool unreadOnly = false,
  }) async {
    try {
      final response = await synamykApi.auth.apiNotificationsGet(
        page: page,
        size: size,
        unreadOnly: unreadOnly,
      );
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(response.statusCode, response.error);
      }
      final body = response.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      final content =
          (body.content ?? [])
              .map(
                (e) => UserNotificationEntry(
                  id: e.id ?? (throw AppException.unknown()),
                  title: e.title ?? '',
                  body: e.body ?? '',
                  dataType: PushDataType.fromJson(e.dataType?.value),
                  dataEntityId: e.dataEntityId,
                  read: e.read ?? false,
                  createdAt: e.createdAt ?? (throw AppException.unknown()),
                ),
              )
              .toList();

      return PagedResult(
        content: content,
        totalElements: body.totalElements ?? content.length,
        number: body.number ?? page,
        last: body.last ?? true,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await synamykApi.auth.apiNotificationsUnreadCountGet();
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(response.statusCode, response.error);
      }
      return response.body?.count ?? 0;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<void> markRead(int id) async {
    try {
      final response = await synamykApi.auth.apiNotificationsIdReadPost(id: id);
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(response.statusCode, response.error);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<void> markAllRead() async {
    try {
      final response = await synamykApi.auth.apiNotificationsReadAllPost();
      if (!response.isSuccessful) {
        throw ExceptionParser.parseResponse(response.statusCode, response.error);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
