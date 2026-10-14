import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synamyk/config/app_config.dart';
import 'package:synamyk/firebase_options.dart';
import 'package:synamyk/data/repositories/notifications/notifications_repository.dart';
import 'package:synamyk/data/repositories/notifications/notifications_repository_impl.dart';
import 'package:synamyk/data/services/push_notification_service.dart';
import 'package:synamyk/data/api/dio/upload_data_source.dart';
import 'package:synamyk/data/api/dio/synamyk_rest_client.dart';
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/repositories/catalog/catalog_repository.dart';
import 'package:synamyk/data/repositories/ort_attempt/ort_attempt_repository.dart';
import 'package:synamyk/data/repositories/ort_attempt/ort_attempt_repository_impl.dart';
import 'package:synamyk/data/repositories/referral/referral_repository.dart';
import 'package:synamyk/data/repositories/school/school_repository.dart';
import 'package:synamyk/data/helper/network/network_info.dart';
import 'package:synamyk/data/helper/network/network_info_impl.dart';
import 'package:synamyk/data/repositories/analyst/analyst_repository_impl.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/data/repositories/auth/auth_repository_impl.dart';
import 'package:synamyk/data/repositories/home/home_repository_impl.dart';
import 'package:synamyk/data/repositories/home/home_repository.dart';
import 'package:synamyk/data/repositories/language/language_repository.dart';
import 'package:synamyk/data/repositories/news/news_repository_impl.dart';
import 'package:synamyk/data/repositories/news/news_repository.dart';
import 'package:synamyk/data/repositories/game/game_repository.dart';
import 'package:synamyk/data/repositories/game/game_repository_impl.dart';
import 'package:synamyk/data/services/game_socket_service.dart';
import 'package:synamyk/data/repositories/payment/payment_repository.dart';
import 'package:synamyk/data/repositories/payment/payment_repository_impl.dart';
import 'package:synamyk/data/repositories/ort_tests/fake_data/fake_ort_tests_repository_impl.dart';
import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository_impl.dart';
import 'package:synamyk/data/repositories/profile/profile_repository.dart';
import 'package:synamyk/data/repositories/profile/profile_repository_impl.dart';
import 'package:synamyk/data/repositories/regions/regions_repository.dart';
import 'package:synamyk/data/repositories/regions/regions_repository_impl.dart';
import 'package:synamyk/data/repositories/user/image/image_repository.dart';
import 'package:synamyk/data/repositories/user/image/image_repository_impl.dart';
import 'package:synamyk/data/services/registration_token_storage.dart';
import 'package:synamyk/domain/models/user/user_model.dart';
import 'package:synamyk/data/repositories/user/user_repository.dart';
import 'package:synamyk/data/repositories/user/hive_user_repository_impl.dart';
import 'package:synamyk/data/repositories/rating/rating_repository.dart';
import 'package:synamyk/data/repositories/rating/rating_repository_impl.dart';
import 'package:synamyk/data/repositories/analyst/analyst_repository.dart';
import 'package:synamyk/data/repositories/video_lessons/video_lessons_repository.dart';
import 'package:synamyk/data/repositories/video_lessons/video_lessons_repository_impl.dart';
import 'package:synamyk/synamyk_app.dart';
import 'package:synamyk/data/services/app_token_storage.dart';
import 'package:synamyk/routing/router.dart';
import 'package:synamyk/ui/auth/bloc/app_auth_bloc.dart';
import 'package:synamyk/ui/core/features/language/bloc/language_bloc.dart';

/// Runs in a separate background isolate when a push arrives while the app
/// isn't in the foreground, so it must re-initialize Firebase itself.
/// Annotated so the Dart compiler doesn't tree-shake it away.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase background init failed: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint('Firebase init failed, push notifications disabled: $e');
  }

  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());

  await dotenv.load();

  final prefs = await SharedPreferences.getInstance();

  GetIt.I.registerSingleton<LanguageRepository>(LanguageRepository(prefs));

  GetIt.I.registerLazySingleton<LanguageBloc>(
    () => LanguageBloc(GetIt.I<LanguageRepository>(), GetIt.I<ProfileRepository>()),
  );

  GetIt.I.registerLazySingleton<Dio>(() => Dio());

  GetIt.I.registerLazySingleton<InternetConnection>(() => InternetConnection());

  GetIt.I.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(GetIt.I<InternetConnection>()),
  );

  GetIt.I.registerLazySingleton<SynamykApiClient>(
    () => SynamykApiClient(
      baseUrl: Uri.parse(AppConfig.baseUrl),
      appTokenStorage: GetIt.I<AppTokenStorage>(),
      registrationTokenStorage: GetIt.I<RegistrationTokenStorage>(),
    ),
  );

  GetIt.I.registerLazySingleton<AppTokenStorage>(() => AppTokenStorage());

  GetIt.I.registerLazySingleton<SynamykRestClient>(
    () => SynamykRestClient(
      dio: GetIt.I<Dio>(),
      tokenStorage: GetIt.I<AppTokenStorage>(),
      synamykApi: GetIt.I<SynamykApiClient>(),
      languageCode: () => GetIt.I<LanguageRepository>().current.materialApp,
    ),
  );

  GetIt.I.registerLazySingleton<OrtAttemptRepository>(
    () => OrtAttemptRepositoryImpl(client: GetIt.I<SynamykRestClient>()),
  );

  GetIt.I.registerLazySingleton<CatalogRepository>(
    () => CatalogRepositoryImpl(client: GetIt.I<SynamykRestClient>()),
  );

  GetIt.I.registerLazySingleton<SchoolRepository>(
    () => SchoolRepositoryImpl(
      client: GetIt.I<SynamykRestClient>(),
      languageCode: () => GetIt.I<LanguageRepository>().current.apiCode,
    ),
  );

  GetIt.I.registerLazySingleton<ReferralRepository>(
    () => ReferralRepositoryImpl(client: GetIt.I<SynamykRestClient>()),
  );

  GetIt.I.registerLazySingleton<RegistrationTokenStorage>(
    () => RegistrationTokenStorage(),
  );

  GetIt.I.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      tokenStorage: GetIt.I<AppTokenStorage>(),

      synamykApi: GetIt.I<SynamykApiClient>(),

      restClient: GetIt.I<SynamykRestClient>(),

      registrationTokenStorage: GetIt.I<RegistrationTokenStorage>(),

      policyUrl: AppConfig.policyUrl,

      termsOfService: AppConfig.tosUrl
    ),
  );

  GetIt.I.registerLazySingleton<UploadDataSource>(
    () => UploadDataSource(
      dio: GetIt.I<Dio>(),
      tokenStorage: GetIt.I<AppTokenStorage>(),
      synamykApi: GetIt.I<SynamykApiClient>(),
    ),
  );

  GetIt.I.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      synamykApi: GetIt.I<SynamykApiClient>(),
      userRepository: GetIt.I<UserRepository>(),
      regionsRepository: GetIt.I<RegionsRepository>(),
      networkInfo: GetIt.I<NetworkInfo>(),
      uploadDataSource: GetIt.I<UploadDataSource>(),
      registrationTokenStorage: GetIt.I<RegistrationTokenStorage>(),
    ),
  );

  GetIt.I.registerLazySingleton<AppAuthBloc>(
    () => AppAuthBloc(authRepository: GetIt.I<AuthRepository>()),
  );

  // A single stable router instance — created once, reused across app
  // rebuilds (e.g. locale changes) — so PushNotificationService can
  // navigate on a notification tap without needing a BuildContext.
  GetIt.I.registerLazySingleton<GoRouter>(
    () => createRouter(GetIt.I<AppAuthBloc>()),
  );

  GetIt.I.registerLazySingleton<OrtTestsRepository>(
    () => OrtTestsRepositoryImpl(synamykApi: GetIt.I<SynamykApiClient>()),
  );

  GetIt.I.registerLazySingleton<RegionsRepository>(
    () => RegionsRepositoryImpl(synamykApi: GetIt.I<SynamykApiClient>()),
  );

  GetIt.I.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(synamykApi: GetIt.I<SynamykApiClient>()),
  );

  GetIt.I.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(synamykApi: GetIt.I<SynamykApiClient>()),
  );

  GetIt.I.registerLazySingleton<UserRepository>(() => HiveUserRepositoryImpl());

  GetIt.I.registerLazySingleton<RatingRepository>(
    () => RatingRepositoryImpl(synamykApi: GetIt.I<SynamykApiClient>()),
  );

  GetIt.I.registerLazySingleton<AnalystRepository>(
    () => AnalystRepositoryImpl(synamykApi: GetIt.I<SynamykApiClient>()),
  );

  GetIt.I.registerLazySingleton<VideoLessonsRepository>(
    () => VideoLessonsRepositoryImpl(synamykApi: GetIt.I<SynamykApiClient>()),
  );

  GetIt.I.registerLazySingleton<ImageRepository>(() => ImageRepositoryImpl());

  GetIt.I.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      synamykApi: GetIt.I<SynamykApiClient>(),
      restClient: GetIt.I<SynamykRestClient>(),
    ),
  );

  GetIt.I.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(
      dio: GetIt.I<Dio>(),
      tokenStorage: GetIt.I<AppTokenStorage>(),
      synamykApi: GetIt.I<SynamykApiClient>(),
    ),
  );

  GetIt.I.registerFactory<GameSocketService>(
    () => GameSocketService(tokenStorage: GetIt.I<AppTokenStorage>()),
  );

  GetIt.I.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(synamykApi: GetIt.I<SynamykApiClient>()),
  );

  GetIt.I.registerLazySingleton<PushNotificationService>(
    () => PushNotificationService(
      notificationsRepository: GetIt.I<NotificationsRepository>(),
      tokenStorage: GetIt.I<AppTokenStorage>(),
    ),
  );

  await GetIt.I<PushNotificationService>().init();

  runApp(SynamykApp(prefs: prefs));

  // Deferred until after the first frame so the router (used to navigate
  // on a cold-start notification tap) is actually mounted.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    GetIt.I<PushNotificationService>().consumePendingNavigation();
  });
}
