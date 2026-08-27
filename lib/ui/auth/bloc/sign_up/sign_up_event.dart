part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class ChangeStatus extends SignUpEvent {
  const ChangeStatus();

  @override
  List<Object?> get props => [];
}

class ChangePhone extends SignUpEvent {
  const ChangePhone(this.phone);

  final String phone;

  @override
  List<Object?> get props => [phone];
}

class ChangePassword extends SignUpEvent {
  const ChangePassword(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class ChangeDeal extends SignUpEvent {
  const ChangeDeal(this.deal);

  final bool deal;

  @override
  List<Object?> get props => [deal];
}

class SubmitSignUp extends SignUpEvent {
  const SubmitSignUp();

  @override
  List<Object?> get props => [];
}

class TogglePasswordVisibility extends SignUpEvent {
  const TogglePasswordVisibility();

  @override
  List<Object?> get props => [];
}

class ToggleConfirmPasswordVisibility extends SignUpEvent {
  const ToggleConfirmPasswordVisibility();

  @override
  List<Object?> get props => [];
}
