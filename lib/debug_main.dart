// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:synamyk/data/repositories/auth/auth_repository.dart';
// import 'package:synamyk/data/repositories/auth/fake_data/fake_auth_repository_impl.dart' show FakeAuthRepositoryImpl;
// import 'package:synamyk/data/repositories/ort_tests/fake_data/fake_ort_tests_repository_impl.dart';
// import 'package:synamyk/data/repositories/ort_tests/ort_tests_repository.dart';
// import 'package:synamyk/ui/analyst/pages/analyst_page.dart';
// import 'package:synamyk/ui/auth/pages/sign_in_page.dart';
// import 'package:synamyk/ui/auth/pages/sign_up_confirm_page.dart';
// import 'package:synamyk/ui/auth/pages/sign_up_page.dart';
// import 'package:synamyk/ui/auth/pages/sign_up_user_info_page.dart';
// import 'package:synamyk/ui/core/ui/themes/theme.dart';

// void main() {
//   GetIt.I.registerLazySingleton<OrtTestsRepository>(
//     () => FakeOrtTestsRepositoryImpl(),
//   );
//   // GetIt.I.registerLazySingleton<AuthRepository>(
//   //   () => FakeAuthRepositoryImpl(),
//   // );
//   runApp(DebugApp());
// }

// class DebugApp extends StatelessWidget {
//   const DebugApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(theme: theme, home: AnalystPage());
//   }
// }
