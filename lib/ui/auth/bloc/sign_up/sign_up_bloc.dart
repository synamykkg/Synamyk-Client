import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/domain/enums/app_language.dart';
import 'package:synamyk/domain/enums/auth_step_status.dart';
import 'package:synamyk/error/exceptions.dart';
import 'package:synamyk/ui/auth/bloc/app_auth_bloc.dart';
import 'package:synamyk/utils/auth/is_valid_sign_in.dart';
import 'package:synamyk/utils/auth/phone_input_formatter.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository _authRepository;
  final AppAuthBloc _appAuthBloc;

  SignUpBloc({
    required AuthRepository authRepository,
    required AppAuthBloc appAuthBloc,
  }) : _authRepository = authRepository,
       _appAuthBloc = appAuthBloc,
       super(SignUpState()) {
    on<ChangePhone>((event, emit) {
      emit(
        state.copyWith(
          phone: event.phone,
          status: AuthStepStatus.initial,
        ),
      );
    });
    on<ChangePassword>((event, emit) {
      emit(
        state.copyWith(
          password: event.password,
          status: AuthStepStatus.initial,
        ),
      );
    });
    on<ChangeDeal>((event, emit) {
      emit(
        state.copyWith(
          deal: event.deal,
          status: AuthStepStatus.initial,
        ),
      );
    });
    on<ChangeStatus>((event, emit) {
      emit(
        state.copyWith(
          status: AuthStepStatus.initial,
        ),
      );
    });
    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
    });
    on<ToggleConfirmPasswordVisibility>((event, emit) {
      emit(
        state.copyWith(
          isConfirmPasswordObscured: !state.isConfirmPasswordObscured,
        ),
      );
    });
    on<SubmitSignUp>(_onSubmit);
  }

  Future<void> _onSubmit(SubmitSignUp event, Emitter<SignUpState> emit) async {
    if (!state.isValid) {
      return;
    }
    emit(state.copyWith(status: AuthStepStatus.loading));
    try {
      final authResult = await _authRepository.signUp(
        state.phone,
        state.password,
      );

      // final authSmsSend = await _authRepository.sendSignUpPhoneConfirmationSms(
      //   state.phone,
      //   AppLanguage.russian,
      // );
      // _appAuthBloc.add(AppAuthLoggedIn());

      emit(state.copyWith(status: AuthStepStatus.success));
      // } on AlreadyRegisteredException {
      // final authSmsSend = await _authRepository.sendSignUpPhoneConfirmationSms(
      //   state.phone,
      //   'RU',
      // );
      // if (authSmsSend != true) {
      // emit(state.copyWith(status: AuthStepStatus.failed));
      // } else {
      // emit(state.copyWith(status: AuthStepStatus.success));
      // }
    } on Exception catch (e) {
      debugPrint("4: ${e.toString()}");
      emit(state.copyWith(status: AuthStepStatus.failed, error: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStepStatus.failed,
          error: Exception('Unknow error'),
        ),
      );
    }
  }
}
