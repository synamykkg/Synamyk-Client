import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';

part 'reset_password_new_event.dart';
part 'reset_password_new_state.dart';

class ResetPasswordNewBloc
    extends Bloc<ResetPasswordNewEvent, ResetPasswordNewState> {
  final AuthRepository _authRepository;

  ResetPasswordNewBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ResetPasswordNewState()) {
    on<ResetPasswordNewPasswordChanged>(_onPasswordChanged);
    on<ResetPasswordConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ResetPasswordSubmit>(_onSubmit);
    on<ResetPasswordNewTogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<ResetPasswordNewToggleConfirmPasswordVisibility>(
      _onToggleConfirmPasswordVisibility,
    );
  }

  void _onTogglePasswordVisibility(
    ResetPasswordNewTogglePasswordVisibility event,
    Emitter<ResetPasswordNewState> emit,
  ) {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  void _onToggleConfirmPasswordVisibility(
    ResetPasswordNewToggleConfirmPasswordVisibility event,
    Emitter<ResetPasswordNewState> emit,
  ) {
    emit(
      state.copyWith(
        isConfirmPasswordObscured: !state.isConfirmPasswordObscured,
      ),
    );
  }

  void _onPasswordChanged(
    ResetPasswordNewPasswordChanged event,
    Emitter<ResetPasswordNewState> emit,
  ) {
    emit(
      state.copyWith(
        newPassword: event.password,
        status: ResetPasswordNewStatus.initial,
      ),
    );
  }

  void _onConfirmPasswordChanged(
    ResetPasswordConfirmPasswordChanged event,
    Emitter<ResetPasswordNewState> emit,
  ) {
    emit(
      state.copyWith(
        confirmPassword: event.password,
        status: ResetPasswordNewStatus.initial,
      ),
    );
  }

  Future<void> _onSubmit(
    ResetPasswordSubmit event,
    Emitter<ResetPasswordNewState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: ResetPasswordNewStatus.loading));
    try {
      await _authRepository.setNewPassword(
        event.resetToken,
        state.newPassword,
        state.confirmPassword,
      );
      emit(state.copyWith(status: ResetPasswordNewStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordNewStatus.failure,
          error: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }
}
