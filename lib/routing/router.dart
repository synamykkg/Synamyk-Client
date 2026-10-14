import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_finish_result.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_question_result.dart';
import 'package:synamyk/domain/models/ort_attempt/attempt_result.dart';
import 'package:synamyk/ui/analyst/pages/analyst_page.dart';
import 'package:synamyk/ui/catalog/pages/product_payment_page.dart';
import 'package:synamyk/ui/catalog/pages/text_detail_page.dart';
import 'package:synamyk/ui/game/pages/game_leaderboard_page.dart';
import 'package:synamyk/ui/ort_attempt/pages/attempt_history_page.dart';
import 'package:synamyk/ui/ort_attempt/pages/attempt_result_page.dart';
import 'package:synamyk/ui/ort_attempt/pages/attempt_run_page.dart';
import 'package:synamyk/ui/ort_attempt/pages/test_detail_page.dart';
import 'package:synamyk/ui/referral/pages/referral_page.dart';
import 'package:synamyk/ui/school/pages/my_school_page.dart';
import 'package:synamyk/ui/analyst/widgets/analyst_tabs_shell.dart';
import 'package:synamyk/ui/auth/bloc/app_auth_bloc.dart';
import 'package:synamyk/ui/auth/pages/new_password_page.dart';
import 'package:synamyk/ui/auth/pages/reset_password_page.dart';
import 'package:synamyk/ui/auth/pages/reset_password_phone_confirm.dart';
import 'package:synamyk/ui/auth/pages/sign_in_page.dart';
import 'package:synamyk/ui/auth/pages/sign_up_confirm_page.dart';
import 'package:synamyk/ui/auth/pages/sign_up_page.dart';
import 'package:synamyk/ui/auth/pages/sign_up_user_info_page.dart';
import 'package:synamyk/ui/core/features/otp/models/otp_config.dart';
import 'package:synamyk/ui/core/features/otp/pages/otp_page.dart';
import 'package:synamyk/ui/feed/widgets/feed_tabs_shell.dart';
import 'package:synamyk/ui/game/pages/game_history_page.dart';
import 'package:synamyk/ui/game/pages/game_list_page.dart';
import 'package:synamyk/ui/game/pages/game_room_page.dart';
import 'package:synamyk/ui/home/widgets/home_page.dart';
import 'package:synamyk/ui/home/widgets/home_tests_list_page.dart';
import 'package:synamyk/ui/news/news_list/pages/news_page.dart';
import 'package:synamyk/ui/notifications/pages/notifications_inbox_page.dart';
import 'package:synamyk/ui/profile/pages/notification_settings_page.dart';
import 'package:synamyk/ui/payment/pages/my_purchases_page.dart';
import 'package:synamyk/ui/payment/models/payment_confirm_args.dart';
import 'package:synamyk/ui/payment/pages/payment_confirm_page.dart';
import 'package:synamyk/ui/ort_tests/pages/ort_test_ai_analyst_page.dart';
import 'package:synamyk/ui/ort_tests/pages/ort_test_page.dart';
import 'package:synamyk/ui/ort_tests/pages/session_result_page.dart';
import 'package:synamyk/ui/ort_tests/pages/sub_test_history_page.dart';
import 'package:synamyk/ui/profile/widgets/data_settings_page.dart';
import 'package:synamyk/ui/profile/widgets/language_change_page.dart';
import 'package:synamyk/ui/profile/widgets/profile_page.dart';
import 'package:synamyk/ui/rating/widgets/rating_page.dart';
import 'package:synamyk/ui/root_main/widgets/root_main_page.dart';
import 'package:synamyk/ui/splash/pages/splash_page.dart';
import 'package:synamyk/ui/analyst/video_lessons/pages/video_lessons_page.dart';
import 'package:synamyk/ui/news/news_details/news_details_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AppAuthBloc authBloc) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: StreamListenable(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isAuthenticated = authState.status == AppAuthStatus.authenticated;
      final isUnauthenticated =
          authState.status == AppAuthStatus.unauthenticated;
      final isUnknown = authState.status == AppAuthStatus.unknown;

      // 1. If auth status is unknown, show splash
      if (isUnknown) {
        return '/splash';
      }

      final isLoggingIn =
          state.uri.path == '/sign_in' ||
          state.uri.path == '/sign_up' ||
          state.uri.path.startsWith('/auth');

      final isSplash = state.uri.path == '/splash';

      // 2. If authenticated
      if (isAuthenticated) {
        // If trying to access splash or login pages, go to home
        if (isSplash || isLoggingIn) {
          return '/home';
        }
      }

      // 3. If unauthenticated
      if (isUnauthenticated) {
        // If not on a login page, go to sign in
        if (!isLoggingIn) {
          return '/sign_up';
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/sign_in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/sign_up',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/auth/confirm_phone',
        builder: (context, state) {
          final phone = state.extra as String;
          return SignUpConfirmPage(phone: phone);
        },
      ),
      GoRoute(
        path: '/auth/user_info',
        builder: (context, state) => const SignUpUserInfoPage(),
      ),
      GoRoute(
        path: '/auth/reset_password',
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: '/auth/reset_password_phone_confirm',
        builder: (context, state) {
          final phone = state.extra as String;
          return ResetPasswordPhoneConfirmPage(phone: phone);
        },
      ),
      GoRoute(
        path: '/auth/new_password',
        builder: (context, state) {
          final resetToken = state.extra as String;
          return NewPasswordPage(resetToken: resetToken);
        },
      ),

      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final config = state.extra as OtpConfig;
          return OtpPage(config: config);
        },
      ),

      // BottomNavigationBar
      StatefulShellRoute.indexedStack(
        builder:
            (context, state, navigationShell) =>
                RootMainPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
                routes: [],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) {
                  return FeedTabsShell(child: child);
                },
                routes: [
                  GoRoute(
                    path: '/feed/rating',
                    builder: (context, state) => const RatingPage(),
                  ),
                  GoRoute(
                    path: '/feed/news',
                    builder: (context, state) => const NewsPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/game',
                builder: (context, state) => const GameListPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) {
                  return AnalystTabsShell(child: child);
                },
                routes: [
                  GoRoute(
                    path: '/results',
                    builder: (context, state) => const AttemptHistoryPage(),
                  ),
                  GoRoute(
                    path: '/analyst',
                    builder: (context, state) => const AnalystPage(),
                  ),
                  GoRoute(
                    path: '/analyst/video_lessons',
                    builder: (context, state) => const VideoLessonsPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'data_settings',
                    builder: (context, state) => const DataSettingsPage(),
                  ),
                  GoRoute(
                    path: 'language_change',
                    builder: (context, state) => const LanguageChangePage(),
                  ),
                  GoRoute(
                    path: 'notification_settings',
                    builder:
                        (context, state) => const NotificationSettingsPage(),
                  ),
                  GoRoute(
                    path: 'purchases',
                    builder: (context, state) => const MyPurchasesPage(),
                  ),
                  GoRoute(
                    path: 'school',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const MySchoolPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/tests/:testId',
        builder:
            (context, state) => TestDetailPage(
              testId: int.parse(state.pathParameters['testId']!),
            ),
      ),
      GoRoute(
        path: '/attempts/:attemptId',
        builder:
            (context, state) => AttemptRunPage(
              attemptId: int.parse(state.pathParameters['attemptId']!),
            ),
      ),
      GoRoute(
        path: '/attempts/:attemptId/result',
        builder:
            (context, state) => AttemptResultPage(
              attemptId: int.parse(state.pathParameters['attemptId']!),
              initial: state.extra as AttemptResult?,
            ),
      ),
      GoRoute(
        path: '/texts/:textId',
        builder:
            (context, state) => TextDetailPage(
              textId: int.parse(state.pathParameters['textId']!),
            ),
      ),
      GoRoute(
        path: '/product/:code',
        builder:
            (context, state) =>
                ProductPaymentPage(code: state.pathParameters['code']!),
      ),
      GoRoute(
        path: '/referrals',
        builder: (context, state) => const ReferralPage(),
      ),
      GoRoute(
        path: '/game/leaderboard',
        builder: (context, state) => const GameLeaderboardPage(),
      ),
      GoRoute(
        path: '/home/tests/:language',
        builder: (context, state) {
          final language = state.pathParameters['language']!;

          return HomeTestsListPage(language: language);
        },
      ),
      GoRoute(
        path: '/ort_test/:language/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final language = state.pathParameters['language']!;

          return OrtTestPage(language: language, id: id);
        },
        routes: [
          GoRoute(
            path: 'ai_analyst',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final extra = state.extra as Map<String, dynamic>;
              final sessionId = extra['sessionId'] as int;
              final results =
                  extra['results'] as List<OrtSubTestQuestionResult>;
              return OrtTestAiAnalystPage(
                sessionId: sessionId,
                results: results,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/sub_tests/:subTestId/history',
        builder: (context, state) {
          final subTestId = int.parse(state.pathParameters['subTestId']!);
          final testId = state.extra as String?;
          return SubTestHistoryPage(subTestId: subTestId, testId: testId);
        },
      ),
      GoRoute(
        path: '/sessions/:sessionId/result',
        builder: (context, state) {
          final sessionId = int.parse(state.pathParameters['sessionId']!);
          final extra = state.extra as Map<String, dynamic>;
          return SessionResultPage(
            sessionId: sessionId,
            testId: extra['testId'] as String,
            subTestId: extra['subTestId'] as int,
          );
        },
      ),
      GoRoute(
        path: '/game/room',
        builder: (context, state) {
          final gameTestId = state.extra as int;
          return GameRoomPage(gameTestId: gameTestId);
        },
      ),
      GoRoute(
        path: '/game/history',
        builder: (context, state) => const GameHistoryPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsInboxPage(),
      ),
      GoRoute(
        path: '/payment',
        builder: (context, state) {
          final args = state.extra as PaymentConfirmArgs;
          return PaymentConfirmPage(args: args);
        },
      ),
      GoRoute(
        path: '/news_details',
        builder: (context, state) {
          final newsId = state.extra as String;
          return NewsDetailsPage(newsId: newsId);
        },
      ),
    ],
  );
}

class StreamListenable extends ChangeNotifier {
  final Stream stream;
  StreamSubscription? _subscription;

  StreamListenable(this.stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
