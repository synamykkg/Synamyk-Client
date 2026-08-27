import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/domain/enums/app_language.dart';
import 'package:synamyk/domain/enums/otp_type.dart';
import 'package:synamyk/error/app_exception.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthRepository _authRepository;

  ResetPasswordBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ResetPasswordState()) {
    on<ResetPasswordPhoneChanged>((event, emit) {
      emit(
        state.copyWith(phone: event.phone, status: ResetPasswordStatus.initial),
      );
    });
    on<ResetPasswordCodeChanged>((event, emit) {
      emit(
        state.copyWith(code: event.code, status: ResetPasswordStatus.initial),
      );
    });
    on<ResetPasswordNewPasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          newPassword: event.password,
          status: ResetPasswordStatus.initial,
        ),
      );
    });
    on<ResetPasswordConfirmPasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          confirmPassword: event.password,
          status: ResetPasswordStatus.initial,
        ),
      );
    });

    on<ResetPasswordRequestSms>(_onRequestSms);
    on<ResetPasswordVerifyCode>(_onVerifyCode);
    on<ResetPasswordSetNew>(_onSetNewPassword);
  }

  Future<void> _onRequestSms(
    ResetPasswordRequestSms event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));
    try {
      // final isValid = await _authRepository.checkResetPasswordPhone(
      //   state.phone,
      // );
      if (state.isValid) {
        await _authRepository.sendOtpSms(
          state.phone,
          OtpType.passwordReset,
          AppLanguage.russian,
        );
        emit(
          state.copyWith(
            status: ResetPasswordStatus.success,
            step: ResetPasswordStep.codeInput,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ResetPasswordStatus.failure,
            errorMessage: "Phone not found",
          ),
        );
      }
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onVerifyCode(
    ResetPasswordVerifyCode event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));
    try {
      final token = await _authRepository.verifyResetPasswordCode(
        state.phone,
        state.code,
      );
      emit(
        state.copyWith(
          status: ResetPasswordStatus.success,
          // resetToken: token,
          step: ResetPasswordStep.newPasswordInput,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSetNewPassword(
    ResetPasswordSetNew event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));
    try {
      await _authRepository.setNewPassword(
        state.resetToken,
        state.newPassword,
        state.confirmPassword,
      );
      emit(
        state.copyWith(
          status: ResetPasswordStatus.success,
          step: ResetPasswordStep.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
