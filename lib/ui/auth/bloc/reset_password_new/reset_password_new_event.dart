part of 'reset_password_new_bloc.dart';

abstract class ResetPasswordNewEvent {}

class ResetPasswordNewPasswordChanged extends ResetPasswordNewEvent {
  final String password;
  ResetPasswordNewPasswordChanged(this.password);
}

class ResetPasswordConfirmPasswordChanged extends ResetPasswordNewEvent {
  final String password;
  ResetPasswordConfirmPasswordChanged(this.password);
}

class ResetPasswordSubmit extends ResetPasswordNewEvent {
  final String resetToken;
  ResetPasswordSubmit(this.resetToken);
}

class ResetPasswordNewTogglePasswordVisibility extends ResetPasswordNewEvent {}

class ResetPasswordNewToggleConfirmPasswordVisibility
    extends ResetPasswordNewEvent {}
