part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.status = AuthStepStatus.initial,
    this.phone = '',
    this.password = '',
    this.deal = false,
    this.isPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
    this.error,
  });

  final AuthStepStatus status;
  final String phone;
  final String password;
  final bool deal;
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;
  final Exception? error;

  bool get isValid {
    return phone.isNotEmpty && password.isNotEmpty && deal;
  }

  SignUpState copyWith({
    AuthStepStatus? status,
    String? phone,
    String? password,
    bool? deal,
    bool? isPasswordObscured,
    bool? isConfirmPasswordObscured,
    Exception? error,
  }) {
    return SignUpState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      deal: deal ?? this.deal,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isConfirmPasswordObscured:
          isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    phone,
    password,
    deal,
    isValid,
    isPasswordObscured,
    isConfirmPasswordObscured,
  ];
}
