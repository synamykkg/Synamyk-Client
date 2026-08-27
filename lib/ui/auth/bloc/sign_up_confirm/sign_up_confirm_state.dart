part of 'sign_up_confirm_bloc.dart';

class SignUpConfirmState {
  final String code;
  final AuthStepStatus status;
  final String? errorMessage;

  bool get isValid => code.length == 4; // Assuming 4 digit code

  SignUpConfirmState({
    this.code = '',
    this.status = AuthStepStatus.initial,
    this.errorMessage,
  });

  SignUpConfirmState copyWith({
    String? code,
    AuthStepStatus? status,
    String? errorMessage,
  }) {
    return SignUpConfirmState(
      code: code ?? this.code,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
