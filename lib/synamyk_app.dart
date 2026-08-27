import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synamyk/data/repositories/language/language_repository.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/features/language/bloc/language_bloc.dart';
import 'package:synamyk/ui/core/ui/themes/theme.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:synamyk/ui/auth/bloc/app_auth_bloc.dart';

class SynamykApp extends StatelessWidget {
  final SharedPreferences prefs;

  const SynamykApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  GetIt.I<LanguageBloc>()..add(LanguageStarted()),
        ),
        BlocProvider(
          // Must be eager: nothing below reads AppAuthBloc via BuildContext
          // anymore now that the router is a GetIt singleton (it reads the
          // bloc straight from GetIt), so a lazy provider would never run
          // this create() — and AppAuthCheckRequested would never fire.
          lazy: false,
          create: (_) => GetIt.I<AppAuthBloc>()..add(AppAuthCheckRequested()),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, langState) {
          return Builder(
            builder: (context) {
              return MaterialApp.router(
                locale: langState.locale,
                supportedLocales: const [
                  Locale('en'),
                  Locale('ky'),
                  Locale('ru'),
                ],
                localizationsDelegates: const [
                  S.delegate, //
                  GlobalMaterialLocalizations.delegate, // ← это и решает ошибку
                  GlobalCupertinoLocalizations.delegate, // ← и это
                  GlobalWidgetsLocalizations.delegate,
                ],
                title: 'Synamyk',
                theme: theme,
                routerConfig: GetIt.I<GoRouter>(),
              );
            },
          );
        },
      ),
    );
  }
}
