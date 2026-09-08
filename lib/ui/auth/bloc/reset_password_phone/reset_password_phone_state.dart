part of 'reset_password_phone_bloc.dart';

enum ResetPasswordPhoneStatus { initial, loading, success, failure }

class ResetPasswordPhoneState {
  final ResetPasswordPhoneStatus status;
  final String phone;
  final Exception? error;

  bool get isValid => isCompleteLocalPhone(phone);

  const ResetPasswordPhoneState({
    this.status = ResetPasswordPhoneStatus.initial,
    this.phone = '',
    this.error,
  });

  ResetPasswordPhoneState copyWith({
    ResetPasswordPhoneStatus? status,
    String? phone,
    Exception? error,
  }) {
    return ResetPasswordPhoneState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      error: error ?? this.error,
    );
  }
}
