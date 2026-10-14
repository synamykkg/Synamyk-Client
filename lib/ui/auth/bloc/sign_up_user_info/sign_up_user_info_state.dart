part of 'sign_up_user_info_bloc.dart';

class SignUpUserInfoState {
  final String firstName;
  final String lastName;
  final Region? region;

  /// Optional: region → district → school.
  final District? district;
  final School? school;

  /// Optional friend's invite code.
  final String referralCode;
  final AuthStepStatus status;
  final Exception? error;
  final List<Region> regionsList;

  bool get isValid =>
      firstName.isNotEmpty && lastName.isNotEmpty && region != null;

  SignUpUserInfoState({
    this.firstName = '',
    this.lastName = '',
    this.region,
    this.district,
    this.school,
    this.referralCode = '',
    this.status = AuthStepStatus.initial,
    this.error,
    this.regionsList = const [],
  });

  SignUpUserInfoState copyWith({
    String? firstName,
    String? lastName,
    Region? region,
    District? district,
    School? school,
    bool clearDistrict = false,
    bool clearSchool = false,
    String? referralCode,
    AuthStepStatus? status,
    Exception? error,
    List<Region>? regionsList,
  }) {
    return SignUpUserInfoState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      region: region ?? this.region,
      district: clearDistrict ? null : (district ?? this.district),
      school: clearSchool ? null : (school ?? this.school),
      referralCode: referralCode ?? this.referralCode,
      status: status ?? this.status,
      error: error ?? this.error,
      regionsList: regionsList ?? this.regionsList,
    );
  }
}
