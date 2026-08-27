part of 'sign_in_bloc.dart';

enum SignInStatus { initial, loading, success, failure }

class SignInState {
  final SignInStatus status;
  final String phone;
  final String password;
  final Exception? error;
  final bool isPasswordObscured;
  // final bool isValid;

  bool get isValid => phone.isNotEmpty && password.isNotEmpty;

  const SignInState({
    this.status = SignInStatus.initial,
    this.phone = '',
    this.password = '',
    this.error,
    this.isPasswordObscured = true,
    // this.isValid = false,
  });

  SignInState copyWith({
    SignInStatus? status,
    String? phone,
    String? password,
    Exception? error,
    bool? isPasswordObscured,
    // bool? isValid,
  }) {
    return SignInState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      error: error ?? this.error,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      // isValid: isValid ?? this.isValid,
    );
  }
}
