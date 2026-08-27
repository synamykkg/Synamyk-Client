import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String firstName;

  @HiveField(1)
  final String lastName;

  @HiveField(2)
  final String region;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String? avatarPath;

  @HiveField(5)
  final int? regionId;

  @HiveField(6)
  final int? totalScore;

  @HiveField(7)
  final int? completedTests;

  int get totalScoreValue => totalScore ?? 0;
  int get completedTestsValue => completedTests ?? 0;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.region,
    required this.description,
    required this.regionId,
    this.avatarPath,
    required this.totalScore,
    required this.completedTests,
  });

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? region,
    String? description,
    int? regionId,
    int? totalScore,
    int? completedTests,

    String? avatarPath,
  }) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      region: region ?? this.region,
      description: description ?? this.description,
      regionId: regionId ?? this.regionId,
      totalScore: totalScore ?? this.totalScore,
      completedTests: completedTests ?? this.completedTests,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
