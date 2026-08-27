part of 'reset_password_new_bloc.dart';

enum ResetPasswordNewStatus { initial, loading, success, failure }

class ResetPasswordNewState {
  final ResetPasswordNewStatus status;
  final String newPassword;
  final String confirmPassword;
  final Exception? error;
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;

  bool get isValid => newPassword.isNotEmpty && confirmPassword.isNotEmpty;

  const ResetPasswordNewState({
    this.status = ResetPasswordNewStatus.initial,
    this.newPassword = '',
    this.confirmPassword = '',
    this.error,
    this.isPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
  });

  ResetPasswordNewState copyWith({
    ResetPasswordNewStatus? status,
    String? newPassword,
    String? confirmPassword,
    Exception? error,
    bool? isPasswordObscured,
    bool? isConfirmPasswordObscured,
  }) {
    return ResetPasswordNewState(
      status: status ?? this.status,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      error: error ?? this.error,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isConfirmPasswordObscured:
          isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
    );
  }
}
