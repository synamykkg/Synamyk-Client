import 'package:go_router/go_router.dart';
import 'package:synamyk/domain/enums/push_data_type.dart';

/// Where a push notification / inbox entry's `(dataType, dataEntityId)`
/// should navigate to. Shared between [PushNotificationService]'s
/// tap-handler and the in-app notifications inbox.
void navigateForNotificationData(
  GoRouter router,
  PushDataType type,
  int? entityId,
) {
  switch (type) {
    case PushDataType.test:
      if (entityId != null) router.push('/home/tests/$entityId');
    case PushDataType.subTest:
      if (entityId != null) router.push('/sub_tests/$entityId/history');
    case PushDataType.game:
      if (entityId != null) router.push('/game/room', extra: entityId);
    case PushDataType.broadcast:
      router.push('/notifications');
    case PushDataType.none:
    case PushDataType.unknown:
      // No entity to open — leave the user on whatever screen is already
      // showing (the "default screen" the spec calls for).
      break;
  }
}
