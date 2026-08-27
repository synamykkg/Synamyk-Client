import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/ui/auth/bloc/app_auth_bloc.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepository;
  final AppAuthBloc _appAuthBloc;

  SignInBloc({
    required AuthRepository authRepository,
    required AppAuthBloc appAuthBloc,
  }) : _authRepository = authRepository,
       _appAuthBloc = appAuthBloc,
       super(const SignInState()) {
    on<SignInPhoneChanged>(_onPhoneChanged);
    on<SignInPasswordChanged>(_onPasswordChanged);
    on<SignInSubmitted>(_onSubmitted);
    on<SignInTogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  void _onTogglePasswordVisibility(
    SignInTogglePasswordVisibility event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  void _onPhoneChanged(SignInPhoneChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(phone: event.phone, status: SignInStatus.initial));
  }

  void _onPasswordChanged(
    SignInPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(
      state.copyWith(password: event.password, status: SignInStatus.initial),
    );
  }

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    if (state.phone.isEmpty || state.password.isEmpty) {
      emit(
        state.copyWith(
          status: SignInStatus.failure,
          error: Exception("Введите номер телефона и пароль"),
        ),
      );
      return;
    }

    emit(state.copyWith(status: SignInStatus.loading));
    try {
      await _authRepository.signIn(state.phone, state.password);
      // Notify AppAuthBloc that we are logged in so it updates the status
      _appAuthBloc.add(AppAuthLoggedIn());

      emit(state.copyWith(status: SignInStatus.success));
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          status: SignInStatus.failure,
          error: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }
}
