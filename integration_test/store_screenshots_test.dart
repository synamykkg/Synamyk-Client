// Drives the app through the screens used for App Store screenshots.
// Run: flutter test integration_test/store_screenshots_test.dart \
//   -d <simulator> --dart-define=SCREENSHOT_MODE=true \
//   --dart-define=SHOT_PHONE=... --dart-define=SHOT_PASSWORD=...
// Each "SHOT:<name>" line is a cue for scripts/store_screenshots.sh to
// capture the simulator screen while the test holds still.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:synamyk/main.dart' as app;
import 'package:synamyk/routing/router.dart';

const _phone = String.fromEnvironment('SHOT_PHONE');
const _password = String.fromEnvironment('SHOT_PASSWORD');
const _routes = String.fromEnvironment('SHOT_ROUTES', defaultValue: '/home');
// Browse as a guest ("Продолжить без входа") instead of signing in.
const _guest = bool.fromEnvironment('SHOT_GUEST');

Future<void> _settle(WidgetTester t, [int seconds = 4]) async {
  for (var i = 0; i < seconds * 10; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _shot(WidgetTester t, String name) async {
  await _settle(t, 3);
  // ignore: avoid_print
  print('SHOT:$name');
  await _settle(t, 4);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('store screenshots', (t) async {
    app.main();
    await _settle(t, 8);

    if (_guest) {
      await _shot(t, 'guest_sign_up');
      final guestButton = find.text('Продолжить без входа');
      await t.scrollUntilVisible(
        guestButton,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await t.tap(guestButton);
      await _settle(t, 4);
      await _shot(t, 'guest_home');
      // An account-only tab must lead to sign-in, not to a broken screen.
      await t.tap(find.text('Профиль').last);
      await _settle(t, 3);
      expect(find.text('Забыли пароль?'), findsOneWidget);
      await _shot(t, 'guest_profile_tap');
      return;
    }

    final toSignIn = find.text('Есть аккаунт? Войти');
    if (toSignIn.evaluate().isNotEmpty) {
      await t.tap(toSignIn);
      await _settle(t, 2);
      final fields = find.byType(TextField);
      await t.enterText(fields.at(0), _phone);
      await t.enterText(fields.at(1), _password);
      FocusManager.instance.primaryFocus?.unfocus();
      await _settle(t, 1);
      await t.tap(find.text('Войти').last);
      await _settle(t, 8);
    }

    for (final route in _routes.split(',')) {
      GoRouter.of(rootNavigatorKey.currentContext!).go(route);
      await _shot(t, route.replaceAll('/', '_'));
    }
  }, timeout: const Timeout(Duration(minutes: 10)));
}
