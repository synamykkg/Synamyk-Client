import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/ui/auth/bloc/reset_password_phone/reset_password_phone_bloc.dart';
import 'package:synamyk/ui/auth/widgets/button_for_auth.dart';
import 'package:synamyk/ui/auth/widgets/header_auth.dart';
import 'package:synamyk/ui/auth/widgets/text_field_for_auth.dart';
import 'package:synamyk/utils/app_messenger.dart';
import 'package:synamyk/utils/auth/phone_input_formatter.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ResetPasswordPhoneBloc(authRepository: GetIt.I<AuthRepository>()),
      child: BlocListener<ResetPasswordPhoneBloc, ResetPasswordPhoneState>(
        listener: (context, state) {
          if (state.status == ResetPasswordPhoneStatus.success) {
            context.go(
              '/auth/reset_password_phone_confirm',
              extra: state.phone,
            );
          } else if (state.status == ResetPasswordPhoneStatus.failure) {
            final error = state.error;
            String? errorMessage;
            
            if (error is AppException) {
              final phoneError = error.fieldError('phone');
              
              if (phoneError == null) {
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
        child: BlocBuilder<ResetPasswordPhoneBloc, ResetPasswordPhoneState>(
          builder: (context, state) {
            final appError = state.error is AppException ? state.error as AppException : null;
            final phoneError = appError?.fieldError('phone') ?? 
                (state.error.toString().contains('Номер телефона не найден') ? 'Номер телефона не найден' : null);
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomScrollView(
                  slivers: [
                    ...HeaderAuth.slivers(
                      context,
                      Text(
                        'Сброс пароля',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      'Пожалуйста, введите свой номер телефона, связанный с вашим аккаунтом, и мы вышлем вам 4-значный код для сброса пароля.',
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
                        onChanged: (value) {
                          context.read<ResetPasswordPhoneBloc>().add(
                            ResetPasswordPhoneChanged(value),
                          );
                        },
                        errorText: phoneError,
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 40)),
                    SliverToBoxAdapter(
                      child: ButtonForAuth(
                        isValid: state.isValid,
                        text: 'Отправить код',
                        onTap: () {
                          context.read<ResetPasswordPhoneBloc>().add(
                            ResetPasswordRequestSms(),
                          );
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        isLoading:
                            state.status == ResetPasswordPhoneStatus.loading,
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
