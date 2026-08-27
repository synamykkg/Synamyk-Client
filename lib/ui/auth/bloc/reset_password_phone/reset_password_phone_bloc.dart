import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/domain/enums/app_language.dart';
import 'package:synamyk/domain/enums/otp_type.dart';

part 'reset_password_phone_event.dart';
part 'reset_password_phone_state.dart';

class ResetPasswordPhoneBloc
    extends Bloc<ResetPasswordPhoneEvent, ResetPasswordPhoneState> {
  final AuthRepository _authRepository;

  ResetPasswordPhoneBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ResetPasswordPhoneState()) {
    on<ResetPasswordPhoneChanged>(_onPhoneChanged);
    on<ResetPasswordRequestSms>(_onRequestSms);
  }

  void _onPhoneChanged(
    ResetPasswordPhoneChanged event,
    Emitter<ResetPasswordPhoneState> emit,
  ) {
    emit(
      state.copyWith(
        phone: event.phone,
        status: ResetPasswordPhoneStatus.initial,
      ),
    );
  }

  Future<void> _onRequestSms(
    ResetPasswordRequestSms event,
    Emitter<ResetPasswordPhoneState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordPhoneStatus.loading));
    try {
      // final isValid = await _authRepository.checkResetPasswordPhone(
      //   state.phone,
      // );
      if (state.isValid) {
        final result = await _authRepository.sendOtpSms(
          state.phone,
          OtpType.passwordReset,
          AppLanguage.russian,
        );
        if (result) {
          emit(state.copyWith(status: ResetPasswordPhoneStatus.success));
        } else {
          emit(
            state.copyWith(
              status: ResetPasswordPhoneStatus.failure,
              error: Exception("Номер телефона не найден"),
            ),
          );
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordPhoneStatus.failure,
          error: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }
}
