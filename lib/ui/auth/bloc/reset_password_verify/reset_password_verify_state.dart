part of 'reset_password_verify_bloc.dart';

enum ResetPasswordVerifyStatus { initial, loading, success, failure }

class ResetPasswordVerifyState {
  final ResetPasswordVerifyStatus status;
  final String code;
  final String resetToken;
  final String? errorMessage;

  const ResetPasswordVerifyState({
    this.status = ResetPasswordVerifyStatus.initial,
    this.code = '',
    this.resetToken = '',
    this.errorMessage,
  });

  ResetPasswordVerifyState copyWith({
    ResetPasswordVerifyStatus? status,
    String? code,
    String? resetToken,
    String? errorMessage,
  }) {
    return ResetPasswordVerifyState(
      status: status ?? this.status,
      code: code ?? this.code,
      resetToken: resetToken ?? this.resetToken,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
