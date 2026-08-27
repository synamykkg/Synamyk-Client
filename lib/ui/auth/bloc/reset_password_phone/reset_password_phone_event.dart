part of 'reset_password_phone_bloc.dart';

abstract class ResetPasswordPhoneEvent {}

class ResetPasswordPhoneChanged extends ResetPasswordPhoneEvent {
  final String phone;
  ResetPasswordPhoneChanged(this.phone);
}

class ResetPasswordRequestSms extends ResetPasswordPhoneEvent {}
