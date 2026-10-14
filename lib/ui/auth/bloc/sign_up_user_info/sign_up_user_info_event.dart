part of 'sign_up_user_info_bloc.dart';

abstract class SignUpUserInfoEvent {}

class SignUpUserInfoNameChanged extends SignUpUserInfoEvent {
  final String firstName;
  SignUpUserInfoNameChanged(this.firstName);
}

class SignUpUserInfoSurnameChanged extends SignUpUserInfoEvent {
  final String lastName;
  SignUpUserInfoSurnameChanged(this.lastName);
}

class SignUpUserInfoRegionChanged extends SignUpUserInfoEvent {
  final Region region;
  SignUpUserInfoRegionChanged(this.region);
}

class SignUpUserInfoSubmit extends SignUpUserInfoEvent {}

class SignUpUserInfoRegionGet extends SignUpUserInfoEvent {}

class SignUpUserInfoDistrictChanged extends SignUpUserInfoEvent {
  final District district;
  SignUpUserInfoDistrictChanged(this.district);
}

class SignUpUserInfoSchoolChanged extends SignUpUserInfoEvent {
  final School school;
  SignUpUserInfoSchoolChanged(this.school);
}

class SignUpUserInfoReferralCodeChanged extends SignUpUserInfoEvent {
  final String code;
  SignUpUserInfoReferralCodeChanged(this.code);
}
