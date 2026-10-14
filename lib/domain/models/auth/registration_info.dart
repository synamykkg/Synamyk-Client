class RegistrationInfo {
  final String firstName;
  final String lastName;
  final int region;

  /// Optional school picked via region → district → school.
  final int? schoolId;

  /// Optional friend's invite code («Пригласи друга»).
  final String? referralCode;

  RegistrationInfo({
    required this.firstName,
    required this.lastName,
    required this.region,
    this.schoolId,
    this.referralCode,
  });
}
