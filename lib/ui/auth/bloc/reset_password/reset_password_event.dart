part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent {}

class ResetPasswordPhoneChanged extends ResetPasswordEvent {
  final String phone;
  ResetPasswordPhoneChanged(this.phone);
}

class ResetPasswordCodeChanged extends ResetPasswordEvent {
  final String code;
  ResetPasswordCodeChanged(this.code);
}

class ResetPasswordNewPasswordChanged extends ResetPasswordEvent {
  final String password;
  ResetPasswordNewPasswordChanged(this.password);
}

class ResetPasswordConfirmPasswordChanged extends ResetPasswordEvent {
  final String password;
  ResetPasswordConfirmPasswordChanged(this.password);
}

class ResetPasswordRequestSms extends ResetPasswordEvent {}

class ResetPasswordVerifyCode extends ResetPasswordEvent {}

class ResetPasswordSetNew extends ResetPasswordEvent {}
