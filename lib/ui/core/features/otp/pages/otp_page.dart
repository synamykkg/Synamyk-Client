// ui/core/ui/otp/pages/otp_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/ui/auth/widgets/button_for_auth.dart';
import 'package:synamyk/ui/auth/widgets/header_auth.dart';
import 'package:synamyk/ui/core/features/otp/bloc/otp_cubit.dart';
import 'package:synamyk/ui/core/features/otp/bloc/otp_state.dart';
import 'package:synamyk/ui/core/features/otp/models/otp_config.dart';
import 'package:synamyk/utils/app_messenger.dart';

class OtpPage extends StatelessWidget {
  final OtpConfig config;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  OtpPage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(config: config),
      child: BlocConsumer<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state.status == OtpStatus.success) {
            AppMessenger.showSuccess(context, 'Код успешно подтвержден');
            context.go(config.successRoute, extra: config.successExtra);
          } else if (state.status == OtpStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Ошибка подтверждения'),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<OtpCubit>();
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
                    'Введите 4-значный код, который мы отправили на номер ${config.phone}',
                    'assets/images/logo/synamyk_logo.png',
                  ),
                  SliverToBoxAdapter(
                    child: Center(
                      child: GestureDetector(
                        onTap: () => _focusNode.requestFocus(),
                        child: Container(
                          width: 350,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFCFCFCF)),
                          ),
                          child: PinCodeTextField(
                            appContext: context,
                            length: 4,
                            controller: _controller,
                            focusNode: _focusNode,
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
                              borderRadius: BorderRadius.circular(12),
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
                            onChanged: cubit.codeChanged,
                            onCompleted: (_) {
                              cubit.confirm();
                              _focusNode.unfocus();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  SliverToBoxAdapter(
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
                  const SliverToBoxAdapter(child: SizedBox(height: 27)),
                  SliverToBoxAdapter(
                    child:
                        state.status == OtpStatus.loading
                            ? const Center(child: CircularProgressIndicator())
                            : ButtonForAuth(
                              isValid: state.isValid,
                              text: 'Отправить код заново',
                              onTap: cubit.resend,
                              color: Colors.white,
                              textColor: const Color(0xFF6D35E0),
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
