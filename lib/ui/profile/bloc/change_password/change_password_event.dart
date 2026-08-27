import 'package:equatable/equatable.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordOldPasswordChanged extends ChangePasswordEvent {
  final String oldPassword;
  const ChangePasswordOldPasswordChanged(this.oldPassword);

  @override
  List<Object> get props => [];
}

class ChangePasswordNewPasswordChanged extends ChangePasswordEvent {
  final String newPassword;
  const ChangePasswordNewPasswordChanged(this.newPassword);

  @override
  List<Object> get props => [newPassword];
}

class ChangePasswordConfirmPasswordChanged extends ChangePasswordEvent {
  final String confirmPassword;
  const ChangePasswordConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class ChangeToggleOldPasswordVisibility extends ChangePasswordEvent {}
class ChangeToggleNewPasswordVisibility extends ChangePasswordEvent {}
class ChangeToggleConfirmPasswordVisibility extends ChangePasswordEvent {}

class ChangePasswordSubmitted extends ChangePasswordEvent {}
