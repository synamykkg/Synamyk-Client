import 'package:synamyk/domain/enums/region.dart';

class RegistrationInfo {
  final String firstName;
  final String lastName;
  final int region;

  RegistrationInfo({
    required this.firstName,
    required this.lastName,
    required this.region,
  });
}
