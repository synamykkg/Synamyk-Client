import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/ui/auth/widgets/button_for_auth.dart';
import 'package:synamyk/ui/auth/widgets/header_auth.dart';
import 'package:synamyk/ui/auth/widgets/text_field_for_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/ui/auth/bloc/reset_password_new/reset_password_new_bloc.dart';
import 'package:synamyk/utils/app_messenger.dart';

class NewPasswordPage extends StatelessWidget {
  const NewPasswordPage({super.key, required this.resetToken});

  final String resetToken;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ResetPasswordNewBloc(authRepository: GetIt.I<AuthRepository>()),
      child: BlocListener<ResetPasswordNewBloc, ResetPasswordNewState>(
        listener: (context, state) {
          if (state.status == ResetPasswordNewStatus.success) {
            // Navigate to login or success page
            context.go('/sign-in'); // Or specific success route
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text("Пароль успешно сменен")),
            // );

            AppMessenger.showSuccess(context, "Пароль успешно сменен");
          } else if (state.status == ResetPasswordNewStatus.failure) {
            final error = state.error;
            String? errorMessage;
            if (error is AppException) {
              final passwordError = error.fieldError('newPassword') ?? error.fieldError('password');
              final confirmPasswordError = error.fieldError('confirmPassword');
              
              if (passwordError == null && confirmPasswordError == null) {
                errorMessage = error.message;
              }
            } else {
              errorMessage = error?.toString().replaceAll('Exception: ', '') ?? "Ошибка";
            }

            if (errorMessage != null && errorMessage.isNotEmpty) {
              AppMessenger.showError(context, errorMessage);
            }
          }
        },
        child: BlocBuilder<ResetPasswordNewBloc, ResetPasswordNewState>(
          builder: (context, state) {
            final appError = state.error is AppException ? state.error as AppException : null;
            final passwordError = appError?.fieldError('newPassword') ?? appError?.fieldError('password');
            final confirmPasswordError = appError?.fieldError('confirmPassword');
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomScrollView(
                  slivers: [
                    ...HeaderAuth.slivers(
                      context,
                      Text(
                        'Придумайте новый пароль',
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
                        text: 'Новый пароль',
                        isPassword: true,
                        obscureText: state.isPasswordObscured,
                        onVisibilityToggle: () {
                          context.read<ResetPasswordNewBloc>().add(
                            ResetPasswordNewTogglePasswordVisibility(),
                          );
                        },
                        onChanged: (value) {
                          context.read<ResetPasswordNewBloc>().add(
                            ResetPasswordNewPasswordChanged(value),
                          );
                        },
                        errorText: passwordError,
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 16)),
                    SliverToBoxAdapter(
                      child: TextFieldForAuth(
                        text: 'Подтвердите пароль',
                        isPassword: true,
                        obscureText: state.isConfirmPasswordObscured,
                        onVisibilityToggle: () {
                          context.read<ResetPasswordNewBloc>().add(
                            ResetPasswordNewToggleConfirmPasswordVisibility(),
                          );
                        },
                        onChanged: (value) {
                          context.read<ResetPasswordNewBloc>().add(
                            ResetPasswordConfirmPasswordChanged(value),
                          );
                        },
                        errorText: confirmPasswordError,
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 40)),
                    SliverToBoxAdapter(
                      child: ButtonForAuth(
                        isValid: state.isValid,
                        text: 'Сменить пароль',
                        onTap: () {
                          context.read<ResetPasswordNewBloc>().add(
                            ResetPasswordSubmit(resetToken),
                          );
                        },
                        color: const Color(0xFF7B1FA2),
                        textColor: Colors.white,
                        isLoading:
                            state.status == ResetPasswordNewStatus.loading,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
