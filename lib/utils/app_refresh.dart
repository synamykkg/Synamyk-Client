import 'package:flutter/foundation.dart';

/// App-wide "access changed" signal.
///
/// Home, texts and rating screens live in [StatefulShellRoute] branches that
/// stay mounted, so after a purchase, a redeemed referral reward or a
/// finished test they'd keep showing stale locks and scores. They listen to
/// [accessVersion] and reload when it ticks.
abstract final class AppRefresh {
  static final ValueNotifier<int> accessVersion = ValueNotifier(0);

  /// A payment completed or a test was unlocked for free.
  static void notifyPurchased() => accessVersion.value++;

  /// An attempt finished — best scores and «Продолжить» buttons changed.
  static void notifyAttemptChanged() => accessVersion.value++;
}
