part of 'reset_password_bloc.dart';

enum ResetPasswordStep { phoneInput, codeInput, newPasswordInput, success }

enum ResetPasswordStatus { initial, loading, success, failure }

class ResetPasswordState {
  final ResetPasswordStep step;
  final ResetPasswordStatus status;
  final String phone;
  final String code;
  final String newPassword;
  final String confirmPassword;
  final String resetToken;
  final String? errorMessage;

  bool get isValid => phone.isNotEmpty;

  const ResetPasswordState({
    this.step = ResetPasswordStep.phoneInput,
    this.status = ResetPasswordStatus.initial,
    this.phone = '',
    this.code = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.resetToken = '',
    this.errorMessage,
  });

  ResetPasswordState copyWith({
    ResetPasswordStep? step,
    ResetPasswordStatus? status,
    String? phone,
    String? code,
    String? newPassword,
    String? confirmPassword,
    String? resetToken,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      step: step ?? this.step,
      status: status ?? this.status,
      phone: phone ?? this.phone,
      code: code ?? this.code,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      resetToken: resetToken ?? this.resetToken,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
