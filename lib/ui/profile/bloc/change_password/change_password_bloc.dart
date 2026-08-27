import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:synamyk/data/repositories/profile/profile_repository.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/ui/profile/bloc/change_password/change_password_event.dart';
import 'package:synamyk/ui/profile/bloc/change_password/change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ProfileRepository _profileRepository;

  ChangePasswordBloc({ProfileRepository? profileRepository})
    : _profileRepository = profileRepository ?? GetIt.I<ProfileRepository>(),
      super(const ChangePasswordState()) {
    on<ChangePasswordOldPasswordChanged>(_onOldPasswordChanged);
    on<ChangePasswordNewPasswordChanged>(_onNewPasswordChanged);
    on<ChangePasswordConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ChangePasswordSubmitted>(_onSubmitted);
    on<ChangeToggleOldPasswordVisibility>(_onToggleOldPasswordVisibility);
    on<ChangeToggleNewPasswordVisibility>(_onToggleNewPasswordVisibility);
    on<ChangeToggleConfirmPasswordVisibility>(_onToggleConfirmPasswordVisibility);
  }

  void _onOldPasswordChanged(
    ChangePasswordOldPasswordChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(oldPassword: event.oldPassword, errorMessage: ''));
  }

  void _onNewPasswordChanged(
    ChangePasswordNewPasswordChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(newPassword: event.newPassword, errorMessage: ''));
  }

  void _onConfirmPasswordChanged(
    ChangePasswordConfirmPasswordChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(
      state.copyWith(confirmPassword: event.confirmPassword, errorMessage: ''),
    );
  }

  void _onToggleOldPasswordVisibility(
    ChangeToggleOldPasswordVisibility event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(isOldPasswordObscured: !state.isOldPasswordObscured));
  }

  void _onToggleNewPasswordVisibility(
    ChangeToggleNewPasswordVisibility event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(isNewPasswordObscured: !state.isNewPasswordObscured));
  }

  void _onToggleConfirmPasswordVisibility(
    ChangeToggleConfirmPasswordVisibility event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(isConfirmPasswordObscured: !state.isConfirmPasswordObscured));
  }

  Future<void> _onSubmitted(
    ChangePasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    if (state.newPassword != state.confirmPassword) {
      emit(
        state.copyWith(
          status: ChangePasswordStatus.failure,
          errorMessage: 'Пароли не совпадают',
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: ChangePasswordStatus.loading, errorMessage: ''),
    );

    try {
      await _profileRepository.changePassword(
        state.oldPassword,
        state.newPassword,
        state.confirmPassword,
      );
      emit(
        state.copyWith(status: ChangePasswordStatus.success, errorMessage: ''),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: ChangePasswordStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ChangePasswordStatus.failure,
          errorMessage: 'Произошла непредвиденная ошибка',
        ),
      );
    }
  }
}
