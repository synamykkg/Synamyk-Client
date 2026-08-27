import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/domain/enums/app_language.dart';
import 'package:synamyk/domain/enums/otp_type.dart';
import 'package:synamyk/error/app_exception.dart';

part 'reset_password_verify_event.dart';
part 'reset_password_verify_state.dart';

class ResetPasswordVerifyBloc
    extends Bloc<ResetPasswordVerifyEvent, ResetPasswordVerifyState> {
  final AuthRepository _authRepository;

  ResetPasswordVerifyBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ResetPasswordVerifyState()) {
    on<ResetPasswordVerifyCodeChanged>(_onCodeChanged);
    on<ResetPasswordVerifyCompareCode>(_onVerifyCode);
    on<ResetPasswordVerifyResend>(_onResendCode);
  }

  void _onCodeChanged(
    ResetPasswordVerifyCodeChanged event,
    Emitter<ResetPasswordVerifyState> emit,
  ) {
    emit(
      state.copyWith(
        code: event.code,
        status: ResetPasswordVerifyStatus.initial,
      ),
    );
  }

  Future<void> _onVerifyCode(
    ResetPasswordVerifyCompareCode event,
    Emitter<ResetPasswordVerifyState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordVerifyStatus.loading));
    try {
      final token = await _authRepository.verifyResetPasswordCode(
        event.phone,
        state.code,
      );
      emit(
        state.copyWith(
          status: ResetPasswordVerifyStatus.success,
          // resetToken: token,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordVerifyStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordVerifyStatus.failure,
          errorMessage: "Ошибка: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> _onResendCode(
    ResetPasswordVerifyResend event,
    Emitter<ResetPasswordVerifyState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordVerifyStatus.loading));
    try {
      await _authRepository.resendOtpSms(
        event.phone,
        OtpType.passwordReset,
        AppLanguage.russian,
      );
      emit(state.copyWith(status: ResetPasswordVerifyStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordVerifyStatus.failure,
          errorMessage: "Ошибка: ${e.toString()}",
        ),
      );
    }
  }
}
