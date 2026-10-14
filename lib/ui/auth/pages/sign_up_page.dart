import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/domain/enums/auth_step_status.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/ui/auth/bloc/app_auth_bloc.dart';
import 'package:synamyk/ui/auth/bloc/privacy_policy/privacy_policy_cubit.dart';
import 'package:synamyk/ui/auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:synamyk/ui/auth/bloc/terms_of_service/terms_of_service_cubit.dart';
import 'package:synamyk/ui/auth/pages/sign_up_confirm_page.dart';
import 'package:synamyk/ui/auth/widgets/button_for_auth.dart';
import 'package:synamyk/ui/auth/widgets/header_auth.dart';
import 'package:synamyk/ui/auth/widgets/text_field_for_auth.dart';
import 'package:synamyk/utils/app_messenger.dart';
import 'package:synamyk/utils/auth/phone_input_formatter.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => SignUpBloc(
                authRepository: GetIt.I<AuthRepository>(),
                appAuthBloc: GetIt.I<AppAuthBloc>(),
              ),
        ),
        BlocProvider(create: (context) => PrivacyPolicyCubit(GetIt.I<AuthRepository>())),
        BlocProvider(create: (context) => TermsOfServiceCubit(GetIt.I<AuthRepository>())),
      ],
      child: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state.status == AuthStepStatus.success) {
            context.push('/auth/confirm_phone', extra: state.phone);
          }
          if (state.status == AuthStepStatus.failed) {
            final error = state.error;
            String? errorMessage;
            if (error is AppException) {
              final phoneError = error.fieldError('phone');
              final passwordError = error.fieldError('password');

              if (phoneError == null && passwordError == null) {
                errorMessage = error.message;
              }
            } else {
              errorMessage = error?.toString() ?? 'Ошибка регистрации';
            }

            if (errorMessage != null && errorMessage.isNotEmpty) {
              AppMessenger.showError(context, errorMessage);
            }
          }
        },
        builder: (context, state) {
          final appError =
              state.error is AppException ? state.error as AppException : null;
          final phoneError = appError?.fieldError('phone');
          final passwordError = appError?.fieldError('password');
          if (state.status == AuthStepStatus.loading) {
            return Scaffold(
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomScrollView(
                slivers: [
                  ...HeaderAuth.slivers(
                    context,
                    Text(
                      'Зарегистрироваться в Synamyk',
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
                      onChanged: (value) {
                        debugPrint(value);
                        context.read<SignUpBloc>().add(
                          ChangePhone(value.replaceAll(RegExp(r'\s+'), '')),
                        );
                      },
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
                        context.read<SignUpBloc>().add(
                          TogglePasswordVisibility(),
                        );
                      },
                      onChanged: (value) {
                        context.read<SignUpBloc>().add(ChangePassword(value));
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
                        context.read<SignUpBloc>().add(
                          ToggleConfirmPasswordVisibility(),
                        );
                      },
                      errorText: passwordError,
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      width: 200,
                      height: 45,
                      child: Row(
                        children: [
                          Checkbox(
                            value: state.deal,
                            onChanged: (value) {
                              context.read<SignUpBloc>().add(
                                ChangeDeal(value ?? false),
                              );
                            },
                            side: const BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              // side: BorderSide(color: Colors.grey, width: 7),
                            ),
                          ),
                          Expanded(
                            child: BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
                              builder: (context, privacyState) {
                                return BlocBuilder<TermsOfServiceCubit, TermsOfServiceState>(
                                  builder: (context, termsState) {
                                    final isPrivacyLoading =
                                        privacyState.status == PrivacyPolicyStatus.loading;
                                    final isTermsLoading =
                                        termsState.status == TermsOfServiceStatus.loading;

                                    return RichText(
                                      softWrap: true,
                                      text: TextSpan(
                                        text: 'Регистрируясь, вы принимаете условия ',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Пользовательского соглашения',
                                            style: const TextStyle(color: Colors.blue),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = isTermsLoading
                                                  ? null
                                                  : () => context.read<TermsOfServiceCubit>().open(),
                                          ),
                                          const TextSpan(
                                            text: ' и ',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: 'Конфиденциальности',
                                            style: const TextStyle(color: Colors.blue),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = isPrivacyLoading
                                                  ? null
                                                  : () => context.read<PrivacyPolicyCubit>().open(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 40)),
                  SliverToBoxAdapter(
                    child: ButtonForAuth(
                      isValid: state.isValid,
                      text: 'Зарегистрироваться',
                      onTap: () {
                        context.read<SignUpBloc>().add(SubmitSignUp());
                      },
                      color: Color(0xFF6D35E0),
                      textColor: Colors.white,
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 16)),

                  SliverToBoxAdapter(
                    child: TextButton(
                      onPressed: () => context.push('/sign_in'),
                      child: Text("Есть аккаунт? Войти"),
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
