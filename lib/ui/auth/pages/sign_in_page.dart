import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/ui/auth/bloc/app_auth_bloc.dart';
import 'package:synamyk/ui/auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:synamyk/ui/auth/pages/sign_up_page.dart';
import 'package:synamyk/ui/auth/widgets/button_for_auth.dart';
import 'package:synamyk/ui/auth/widgets/header_auth.dart';
import 'package:synamyk/ui/auth/widgets/text_field_for_auth.dart';
import 'package:synamyk/utils/app_messenger.dart';
import 'package:synamyk/utils/auth/phone_input_formatter.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SignInBloc(
            authRepository: GetIt.I<AuthRepository>(),
            appAuthBloc: context.read<AppAuthBloc>(),
          ),
      child: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state.status == SignInStatus.failure) {
            final error = state.error;
            String? errorMessage;
            if (error is AppException) {
              final phoneError = error.fieldError('phone');
              final passwordError = error.fieldError('password');
              
              if (phoneError == null && passwordError == null) {
                errorMessage = error.message;
              }
            } else {
              errorMessage = error?.toString() ?? 'Ошибка входа';
            }

            if (errorMessage != null && errorMessage.isNotEmpty) {
              AppMessenger.showError(context, errorMessage);
            }
          }
          // Success is handled by AppAuthBloc listener in Router redirect usually,
          // or we can explicit navigate if needed, but AppAuthLoggedIn event was sent.
        },
        builder: (context, state) {
          final appError = state.error is AppException ? state.error as AppException : null;
          final phoneError = appError?.fieldError('phone');
          final passwordError = appError?.fieldError('password');
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomScrollView(
                slivers: [
                  ...HeaderAuth.slivers(
                    context,
                    Text(
                      'С возвращением в Synamyk',
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    '',
                    'assets/images/logo/synamyk_logo.png',
                  ),

                  SliverToBoxAdapter(
                    child: TextFieldForAuth(

                      text: 'Номер телефона',
                      isPhone: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PhoneInputFormatter(),
                      ],
                      onChanged:
                          (value) => context.read<SignInBloc>().add(
                            SignInPhoneChanged(value),
                          ),
                      errorText: phoneError,
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverToBoxAdapter(
                    child: TextFieldForAuth(

                      text: 'Пароль',
                      isPassword: true,
                      obscureText: state.isPasswordObscured,
                      onVisibilityToggle: () {
                        context.read<SignInBloc>().add(
                          SignInTogglePasswordVisibility(),
                        );
                      },
                      onChanged:
                          (value) => context.read<SignInBloc>().add(
                            SignInPasswordChanged(value),
                          ),
                      errorText: passwordError,
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverToBoxAdapter(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        // foregroundColor: Colors.blue,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () => context.push('/auth/reset_password'),
                      child: Text("Забыли пароль?"),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 16)),

                  SliverToBoxAdapter(
                    child:
                        state.status == SignInStatus.loading
                            ? const Center(child: CircularProgressIndicator())
                            : ButtonForAuth(
                              isValid: state.isValid,
                              text: 'Войти',
                              onTap: () {
                                context.read<SignInBloc>().add(
                                  SignInSubmitted(),
                                );
                              },
                              color: Color(0xFF6D35E0),
                              textColor: Colors.white,
                            ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverToBoxAdapter(
                    child: TextButton(
                      onPressed: () => context.push('/sign_up'),
                      child: Text("Нет аккаунта? Зарегистрироваться"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
