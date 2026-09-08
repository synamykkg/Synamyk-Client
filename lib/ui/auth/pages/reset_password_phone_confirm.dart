import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/ui/auth/bloc/reset_password_verify/reset_password_verify_bloc.dart';
import 'package:synamyk/ui/auth/bloc/sign_up_confirm/sign_up_confirm_bloc.dart';
import 'package:synamyk/ui/auth/widgets/button_for_auth.dart';
import 'package:synamyk/ui/auth/widgets/header_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:synamyk/utils/app_messenger.dart';

class ResetPasswordPhoneConfirmPage extends StatelessWidget {
  ResetPasswordPhoneConfirmPage({super.key, required this.phone});
  final TextEditingController _controller = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  final String phone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ResetPasswordVerifyBloc(
            authRepository: GetIt.I<AuthRepository>(),
          ),
      child: BlocListener<ResetPasswordVerifyBloc, ResetPasswordVerifyState>(
        listener: (context, state) {
          if (state.status == ResetPasswordVerifyStatus.success) {
            context.push('/auth/new_password', extra: state.resetToken);
          } else if (state.status == ResetPasswordVerifyStatus.failure) {
            AppMessenger.showError(
              context,
              state.errorMessage ?? "Ошибка",
            );
          }
        },
        child: BlocBuilder<ResetPasswordVerifyBloc, ResetPasswordVerifyState>(
          builder: (context, state) {
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
                      'Введите код из СМС, отправленный на номер +996 $phone',
                      'assets/images/logo/synamyk_logo.png',
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 20)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            _pinFocusNode.requestFocus();
                          },
                          child: Container(
                            width: 350,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xFFFFFFFF),
                              border: Border.all(
                                color: Color.fromARGB(255, 207, 207, 207),
                                width: 1,
                              ),
                            ),
                            child: PinCodeTextField(
                              cursorWidth: 350,
                              cursorHeight: 44,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,

                              appContext: context,
                              length: 4, // количество символов
                              controller: _controller,
                              focusNode: _pinFocusNode,
                              keyboardType: TextInputType.number,
                              animationType: AnimationType.fade,
                              autoFocus: true,
                              enableActiveFill: true,

                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),

                              hintCharacter: '-',
                              pinTheme: PinTheme(
                                // shape: PinCodeFieldShape.underline,
                                borderRadius: BorderRadius.circular(12),
                                // fieldHeight: 55,
                                // fieldWidth: 45,
                                activeFillColor: Colors.white,
                                selectedFillColor: Colors.white,
                                inactiveFillColor: Colors.white,

                                activeColor: Colors.transparent,
                                selectedColor: Colors.transparent,
                                inactiveColor: Colors.transparent,
                              ),

                              animationDuration: const Duration(
                                milliseconds: 250,
                              ),

                              onChanged: (value) {
                                context.read<ResetPasswordVerifyBloc>().add(
                                  ResetPasswordVerifyCodeChanged(value),
                                );
                              },

                              onCompleted: (value) {
                                context.read<ResetPasswordVerifyBloc>().add(
                                  ResetPasswordVerifyCompareCode(phone),
                                );
                                _pinFocusNode.unfocus();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 40)),
                    SliverToBoxAdapter(
                      child: Container(
                        width: 350,
                        height: 48,
                        child: Text(
                          'Возникли проблемы при получении кода? Вы можете отправить код через 01:00',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 27)),
                    SliverToBoxAdapter(
                      child: ButtonForAuth(
                        isValid: true,
                        text: 'Отправить код заново',
                        onTap: () {
                          context.read<ResetPasswordVerifyBloc>().add(
                            ResetPasswordVerifyResend(phone),
                          );
                        },
                        color: Color(0xFFFFFFFF),
                        textColor: Color(0xFF7B1FA2),
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
