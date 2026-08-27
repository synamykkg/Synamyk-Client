import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/domain/enums/app_language.dart';
import 'package:synamyk/domain/enums/auth_step_status.dart';
import 'package:synamyk/ui/auth/bloc/app_auth_bloc.dart';

part 'sign_up_confirm_event.dart';
part 'sign_up_confirm_state.dart';

class SignUpConfirmBloc extends Bloc<SignUpConfirmEvent, SignUpConfirmState> {
  final AuthRepository _authRepository;
  final AppAuthBloc _appAuthBloc;

  SignUpConfirmBloc({
    required AuthRepository authRepository,
    required AppAuthBloc appAuthBloc,
  }) : _authRepository = authRepository,
       _appAuthBloc = appAuthBloc,
       super(SignUpConfirmState()) {
    on<SignUpConfirmCodeChanged>((event, emit) {
      emit(state.copyWith(code: event.code, status: AuthStepStatus.initial));
    });

    on<SignUpConfirmSubmit>(_onSubmit);
    on<SignUpConfirmResend>(_onResend);
  }

  Future<void> _onSubmit(
    SignUpConfirmSubmit event,
    Emitter<SignUpConfirmState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: AuthStepStatus.loading));
    try {
      await _authRepository.confirmSignUp(state.code, event.phone);
      // _appAuthBloc.add(AppAuthLoggedIn());
      emit(state.copyWith(status: AuthStepStatus.success));
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          status: AuthStepStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onResend(
    SignUpConfirmResend event,
    Emitter<SignUpConfirmState> emit,
  ) async {
    try {
      await _authRepository.sendSignUpPhoneConfirmationSms(
        event.phone,
        AppLanguage.russian,
      );
      // Optional: Emit a status or show a toast via listener in UI
    } catch (e) {
      // Optional: Handle error

      emit(state.copyWith(errorMessage: "Failed to resend code"));
    }
  }
}
