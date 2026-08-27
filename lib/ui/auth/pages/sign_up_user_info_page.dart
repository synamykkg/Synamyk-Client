import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/data/repositories/regions/regions_repository.dart';
import 'package:synamyk/domain/enums/auth_step_status.dart';
import 'package:synamyk/domain/enums/region.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/ui/auth/bloc/app_auth_bloc.dart';
import 'package:synamyk/ui/auth/bloc/sign_up_user_info/sign_up_user_info_bloc.dart';
import 'package:synamyk/ui/auth/widgets/button_for_auth.dart';
import 'package:synamyk/ui/auth/widgets/header_auth.dart';
import 'package:synamyk/ui/auth/widgets/select_option_for_auth.dart';
import 'package:synamyk/ui/auth/widgets/text_field_for_auth.dart';
import 'package:synamyk/utils/app_messenger.dart';

class SignUpUserInfoPage extends StatelessWidget {
  const SignUpUserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SignUpUserInfoBloc(
            authRepository: GetIt.I<AuthRepository>(),
            appAuthBloc: GetIt.I<AppAuthBloc>(),
            regionRepository: GetIt.I<RegionsRepository>(),
          )..add(SignUpUserInfoRegionGet()),
      child: BlocConsumer<SignUpUserInfoBloc, SignUpUserInfoState>(
        listener: (context, state) {
          // if (state.status == AuthStepStatus.success) {
          //   // Navigate to home or root, AppAuthBloc should handle logged in state
          //   // Typically just pop until root or ensure Router redirects
          //   context.go('/');
          // }
          if (state.status == AuthStepStatus.failed) {
            final error = state.error;
            String? errorMessage;
            
            if (error is AppException) {
              errorMessage = error.message;
            } else {
              errorMessage = error?.toString().replaceAll('Exception: ', '') ?? 'Ошибка сохранения';
            }

            if (errorMessage != null && errorMessage.isNotEmpty) {
              AppMessenger.showError(context, errorMessage);
            }
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
                      'Немного информации о вас',
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
                      text: 'Имя',
                      onChanged: (value) {
                        context.read<SignUpUserInfoBloc>().add(
                          SignUpUserInfoNameChanged(value),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverToBoxAdapter(
                    child: TextFieldForAuth(
                      text: 'Фамилия',
                      onChanged: (value) {
                        context.read<SignUpUserInfoBloc>().add(
                          SignUpUserInfoSurnameChanged(value),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverToBoxAdapter(
                    child: SelectOptionForAuth(
                      label: 'Регион',
                      // items: RegionEnum.values.map((e) => e.label).toList(),
                      items: state.regionsList,
                      value: state.region?.name,
                      region: state.region,
                      onChanged: (int? index) {
                        if (index == null) return;
                        context.read<SignUpUserInfoBloc>().add(
                          SignUpUserInfoRegionChanged(state.regionsList[index]),
                        );
                        Navigator.pop(context); // Close bottom sheet
                      },
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 40)),
                  SliverToBoxAdapter(
                    child: ButtonForAuth(
                      isValid: state.isValid,
                      text: 'Завершить регистрацию',
                      onTap: () {
                        context.read<SignUpUserInfoBloc>().add(
                          SignUpUserInfoSubmit(),
                        );
                      },
                      color: Color(0xFF7B1FA2),
                      textColor: Colors.white,
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
