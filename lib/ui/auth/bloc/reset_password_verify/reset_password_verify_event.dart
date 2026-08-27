part of 'reset_password_verify_bloc.dart';

abstract class ResetPasswordVerifyEvent {}

class ResetPasswordVerifyCodeChanged extends ResetPasswordVerifyEvent {
  final String code;
  ResetPasswordVerifyCodeChanged(this.code);
}

class ResetPasswordVerifyCompareCode extends ResetPasswordVerifyEvent {
  final String phone;
  ResetPasswordVerifyCompareCode(this.phone);
}

class ResetPasswordVerifyResend extends ResetPasswordVerifyEvent {
  final String phone;
  ResetPasswordVerifyResend(this.phone);
}