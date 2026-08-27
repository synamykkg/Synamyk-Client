import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synamyk/data/repositories/notifications/notifications_repository.dart';
import 'package:synamyk/data/services/app_token_storage.dart';
import 'package:synamyk/domain/enums/push_data_type.dart';
import 'package:synamyk/routing/notification_routing.dart';

const _defaultChannel = AndroidNotificationChannel(
  'default_channel',
  'Уведомления',
  description: 'Основной канал уведомлений Synamyk',
  importance: Importance.high,
);

const _lastTokenPrefsKey = 'fcm_last_sent_token';
const _lastJwtPrefsKey = 'fcm_last_sent_jwt';

/// Wraps FCM registration/receiving so the rest of the app doesn't need to
/// know whether Firebase is actually configured. Every method swallows its
/// own errors (and logs them) so a missing/broken Firebase setup never
/// breaks login, logout or app startup.
class PushNotificationService {
  PushNotificationService({
    required NotificationsRepository notificationsRepository,
    required AppTokenStorage tokenStorage,
  }) : _notificationsRepository = notificationsRepository,
       _tokenStorage = tokenStorage;

  final NotificationsRepository _notificationsRepository;
  final AppTokenStorage _tokenStorage;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _available = false;
  RemoteMessage? _pendingInitialMessage;

  Future<void> init() async {
    try {
      await _localNotifications.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_defaultChannel);

      // Not gated on the result — a valid FCM token can still be registered
      // even if the user declines the permission to *display* notifications.
      await FirebaseMessaging.instance.requestPermission();

      FirebaseMessaging.onMessage.listen(_showForegroundNotification);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);
      // Cold start via notification tap: the router/widget tree isn't
      // mounted yet at this point (init() runs before runApp()), so this is
      // only fetched here and acted on later via consumePendingNavigation().
      _pendingInitialMessage = await FirebaseMessaging.instance
          .getInitialMessage();

      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        unawaited(_syncToken(token));
      });

      _available = true;

      // Already logged in from a previous session — sync now too.
      await registerCurrentToken();
    } catch (e) {
      debugPrint('PushNotificationService.init failed: $e');
      _available = false;
    }
  }

  /// Call once, right after `runApp()` (e.g. via a post-frame callback), so
  /// a cold start from a notification tap navigates once the router exists.
  void consumePendingNavigation() {
    final message = _pendingInitialMessage;
    _pendingInitialMessage = null;
    if (message != null) _handleTap(message);
  }

  void _handleTap(RemoteMessage message) {
    final data = message.data;
    if (data.isEmpty) return;
    final type = PushDataType.fromJson(data['type'] as String?);
    final entityId = int.tryParse(data['entityId']?.toString() ?? '');
    navigateForNotificationData(GetIt.I<GoRouter>(), type, entityId);
  }

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    unawaited(
      _localNotifications.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _defaultChannel.id,
            _defaultChannel.name,
            channelDescription: _defaultChannel.description,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      ),
    );
  }

  String get _platform {
    if (kIsWeb) return 'WEB';
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'ANDROID',
      TargetPlatform.iOS => 'IOS',
      _ => 'WEB',
    };
  }

  /// Sends `token` to the backend only if it (or the current JWT — i.e. the
  /// logged-in user) differs from what was last sent successfully.
  Future<void> _syncToken(String fcmToken) async {
    try {
      final authToken = await _tokenStorage.getToken();
      if (authToken == null) return;

      final prefs = await SharedPreferences.getInstance();
      final lastToken = prefs.getString(_lastTokenPrefsKey);
      final lastJwt = prefs.getString(_lastJwtPrefsKey);
      if (lastToken == fcmToken && lastJwt == authToken.accessToken) return;

      await _notificationsRepository.registerDeviceToken(fcmToken, _platform);
      await prefs.setString(_lastTokenPrefsKey, fcmToken);
      await prefs.setString(_lastJwtPrefsKey, authToken.accessToken);
    } catch (e) {
      debugPrint('PushNotificationService._syncToken failed: $e');
    }
  }

  /// Call at startup (if already logged in) and right after a successful
  /// login.
  Future<void> registerCurrentToken() async {
    if (!_available) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await _syncToken(token);
    } catch (e) {
      debugPrint('PushNotificationService.registerCurrentToken failed: $e');
    }
  }

  /// Call before clearing the JWT during logout.
  Future<void> unregisterToken() async {
    if (!_available) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _notificationsRepository.deleteDeviceToken(token);
      }
      await FirebaseMessaging.instance.deleteToken();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastTokenPrefsKey);
      await prefs.remove(_lastJwtPrefsKey);
    } catch (e) {
      debugPrint('PushNotificationService.unregisterToken failed: $e');
    }
  }
}
