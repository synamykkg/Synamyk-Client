part of 'change_phone_bloc.dart';

enum ChangePhoneStatus { initial, loading, success, failure }

class ChangePhoneState {
  final ChangePhoneStatus status;
  final String oldPhone;
  final String newPhone;
  final String? errorMessage;

  const ChangePhoneState({
    this.status = ChangePhoneStatus.initial,
    this.oldPhone = '',
    this.newPhone = '',
    this.errorMessage,
  });

  ChangePhoneState copyWith({
    ChangePhoneStatus? status,
    String? oldPhone,
    String? newPhone,
    String? errorMessage,
  }) {
    return ChangePhoneState(
      status: status ?? this.status,
      oldPhone: oldPhone ?? this.oldPhone,
      newPhone: newPhone ?? this.newPhone,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
