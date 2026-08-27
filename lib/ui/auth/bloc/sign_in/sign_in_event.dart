part of 'sign_in_bloc.dart';

abstract class SignInEvent {}

class SignInPhoneChanged extends SignInEvent {
  final String phone;
  SignInPhoneChanged(this.phone);
}

class SignInPasswordChanged extends SignInEvent {
  final String password;
  SignInPasswordChanged(this.password);
}

class SignInSubmitted extends SignInEvent {}

class SignInTogglePasswordVisibility extends SignInEvent {}
