part of 'sign_up_user_info_bloc.dart';

class SignUpUserInfoState {
  final String firstName;
  final String lastName;
  final Region? region;
  final AuthStepStatus status;
  final Exception? error;
  final List<Region> regionsList;

  bool get isValid =>
      firstName.isNotEmpty && lastName.isNotEmpty && region != null;

  SignUpUserInfoState({
    this.firstName = '',
    this.lastName = '',
    this.region,
    this.status = AuthStepStatus.initial,
    this.error,
    this.regionsList = const [],
  });

  SignUpUserInfoState copyWith({
    String? firstName,
    String? lastName,
    Region? region,
    AuthStepStatus? status,
    Exception? error,
    List<Region>? regionsList,
  }) {
    return SignUpUserInfoState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      region: region ?? this.region,
      status: status ?? this.status,
      error: error ?? this.error,
      regionsList: regionsList ?? this.regionsList,
    );
  }
}
