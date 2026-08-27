import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/domain/enums/auth_step_status.dart';
import 'package:synamyk/ui/auth/bloc/app_auth_bloc.dart';
import 'package:synamyk/ui/auth/bloc/sign_up_confirm/sign_up_confirm_bloc.dart';
import 'package:synamyk/ui/auth/widgets/button_for_auth.dart';
import 'package:synamyk/ui/auth/widgets/header_auth.dart';
import 'package:synamyk/utils/app_messenger.dart';

class SignUpConfirmPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  SignUpConfirmPage({super.key, required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SignUpConfirmBloc(
            authRepository: GetIt.I<AuthRepository>(),
            appAuthBloc: GetIt.I<AppAuthBloc>(),
          ),
      child: BlocConsumer<SignUpConfirmBloc, SignUpConfirmState>(
        listener: (context, state) {
          if (state.status == AuthStepStatus.success) {
            // Navigation handled by AppAuthBloc listener in main/app setup likely,
            // or we might need to pop here if it's a pushed route.
            // But usually AppAuthBloc state change triggers router refresh.
            // For safety or specific flow, we can also check if we need to do anything.
            context.go('/auth/user_info');
          }
          else if (state.status == AuthStepStatus.failed) {
            AppMessenger.showError(
              context,
              state.errorMessage ?? 'Ошибка подтверждения',
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomScrollView(
                slivers: [
                  ...HeaderAuth.slivers(
                    context,
                    Text(
                      'Подтверждение номера',
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    'Введите 4-значный код, который мы отправили на номер $phone',
                    'assets/images/logo/synamyk_logo.png',
                  ),

                  SliverToBoxAdapter(
                    child: Center(
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
                              context.read<SignUpConfirmBloc>().add(
                                SignUpConfirmCodeChanged(value),
                              );
                            },

                            onCompleted: (value) {
                              context.read<SignUpConfirmBloc>().add(
                                SignUpConfirmSubmit(phone, ),
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
                      isValid: state.isValid,
                      text: 'Отправить код заново',
                      onTap: () {
                        // TODO: Pass actual phone number from arguments or previous state
                        context.read<SignUpConfirmBloc>().add(
                          SignUpConfirmResend("+996509179834"),
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
    );
  }
}
