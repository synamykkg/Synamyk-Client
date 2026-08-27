import 'package:equatable/equatable.dart';

enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordState extends Equatable {
  final ChangePasswordStatus status;
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;
  final String? errorMessage;
  final bool isOldPasswordObscured;
  final bool isNewPasswordObscured;
  final bool isConfirmPasswordObscured;

  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.oldPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.errorMessage,
    this.isOldPasswordObscured = true,
    this.isNewPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
  });

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
    String? errorMessage,
    bool? isOldPasswordObscured,
    bool? isNewPasswordObscured,
    bool? isConfirmPasswordObscured,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      errorMessage: errorMessage ?? this.errorMessage,
      isOldPasswordObscured:
          isOldPasswordObscured ?? this.isOldPasswordObscured,
      isNewPasswordObscured:
          isNewPasswordObscured ?? this.isNewPasswordObscured,
      isConfirmPasswordObscured:
          isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
    );
  }

  @override
  List<Object?> get props => [
    status,
    oldPassword,
    newPassword,
    confirmPassword,
    errorMessage,
    isOldPasswordObscured,
    isNewPasswordObscured,
    isConfirmPasswordObscured,
  ];
}
