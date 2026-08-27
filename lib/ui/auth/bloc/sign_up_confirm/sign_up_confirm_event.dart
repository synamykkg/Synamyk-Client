part of 'sign_up_confirm_bloc.dart';

abstract class SignUpConfirmEvent {}

class SignUpConfirmCodeChanged extends SignUpConfirmEvent {
  final String code;
  SignUpConfirmCodeChanged(this.code);
}

class SignUpConfirmSubmit extends SignUpConfirmEvent {
  final String phone;

  SignUpConfirmSubmit(this.phone,);
}

class SignUpConfirmResend extends SignUpConfirmEvent {
  final String phone;
  SignUpConfirmResend(this.phone);
}
