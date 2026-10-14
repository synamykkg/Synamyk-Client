import 'package:synamyk/domain/models/common/json_read.dart';

class District {
  const District({required this.id, required this.name, required this.nameKy});

  final int id;
  final String name;
  final String? nameKy;

  String localizedName(bool ky) =>
      ky && (nameKy?.isNotEmpty ?? false) ? nameKy! : name;

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: readIntOr(json['id']),
      name: readStringOr(json['name']),
      nameKy: readString(json['nameKy']),
    );
  }
}

class School {
  const School({required this.id, required this.name, required this.nameKy});

  final int id;
  final String name;
  final String? nameKy;

  String localizedName(bool ky) =>
      ky && (nameKy?.isNotEmpty ?? false) ? nameKy! : name;

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: readIntOr(json['id']),
      name: readStringOr(json['name']),
      nameKy: readString(json['nameKy']),
    );
  }
}

/// `MySchoolResponse` — also the «Рейтингге кирүүгө: 1/3 окуучу» card.
class MySchool {
  const MySchool({
    required this.schoolId,
    required this.schoolName,
    required this.districtId,
    required this.districtName,
    required this.regionId,
    required this.regionName,
    required this.studentCount,
    required this.minStudents,
    required this.inRating,
    required this.studentsNeeded,
  });

  final int schoolId;
  final String schoolName;
  final int? districtId;
  final String? districtName;
  final int? regionId;
  final String? regionName;
  final int studentCount;
  final int minStudents;
  final bool inRating;
  final int studentsNeeded;

  factory MySchool.fromJson(Map<String, dynamic> json) {
    return MySchool(
      schoolId: readIntOr(json['schoolId']),
      schoolName: readStringOr(json['schoolName']),
      districtId: readInt(json['districtId']),
      districtName: readString(json['districtName']),
      regionId: readInt(json['regionId']),
      regionName: readString(json['regionName']),
      studentCount: readIntOr(json['studentCount']),
      minStudents: readIntOr(json['minStudents'], 3),
      inRating: readBool(json['inRating']),
      studentsNeeded: readIntOr(json['studentsNeeded']),
    );
  }
}

/// `SCORE` (Упай) | `ACTIVITY` (Активдүүлүк) | `GROWTH` (Өсүш).
enum SchoolRatingSort {
  score('SCORE'),
  activity('ACTIVITY'),
  growth('GROWTH');

  const SchoolRatingSort(this.apiValue);

  final String apiValue;
}

class SchoolRatingEntry {
  const SchoolRatingEntry({
    required this.rank,
    required this.schoolId,
    required this.name,
    required this.studentCount,
    required this.inRating,
    required this.value,
    required this.isMine,
  });

  final int? rank;
  final int schoolId;
  final String name;
  final int studentCount;
  final bool inRating;
  final double? value;
  final bool isMine;

  factory SchoolRatingEntry.fromJson(Map<String, dynamic> json) {
    return SchoolRatingEntry(
      rank: readInt(json['rank']),
      schoolId: readIntOr(json['schoolId']),
      name: readStringOr(json['name']),
      studentCount: readIntOr(json['studentCount']),
      inRating: readBool(json['inRating']),
      value: readDouble(json['value']),
      isMine: readBool(json['isMine']),
    );
  }
}

class SchoolRating {
  const SchoolRating({
    required this.districtName,
    required this.minStudents,
    required this.mySchool,
    required this.entries,
  });

  final String districtName;
  final int minStudents;
  final MySchool? mySchool;
  final List<SchoolRatingEntry> entries;

  factory SchoolRating.fromJson(Map<String, dynamic> json) {
    final my = json['mySchool'];
    return SchoolRating(
      districtName: readStringOr(json['districtName']),
      minStudents: readIntOr(json['minStudents'], 3),
      mySchool: my is Map<String, dynamic> ? MySchool.fromJson(my) : null,
      entries: readMapList(
        json['entries'],
      ).map(SchoolRatingEntry.fromJson).toList(),
    );
  }
}

class DistrictRatingEntry {
  const DistrictRatingEntry({
    required this.rank,
    required this.name,
    required this.studentsWithResults,
    required this.averageScore,
    required this.isMine,
  });

  final int? rank;
  final String name;
  final int studentsWithResults;
  final double? averageScore;
  final bool isMine;

  factory DistrictRatingEntry.fromJson(Map<String, dynamic> json) {
    return DistrictRatingEntry(
      rank: readInt(json['rank']),
      name: readStringOr(json['name']),
      studentsWithResults: readIntOr(json['studentsWithResults']),
      averageScore: readDouble(json['averageScore']),
      isMine: readBool(json['isMine']),
    );
  }
}

class DistrictRating {
  const DistrictRating({required this.regionName, required this.entries});

  final String? regionName;
  final List<DistrictRatingEntry> entries;

  factory DistrictRating.fromJson(Map<String, dynamic> json) {
    return DistrictRating(
      regionName: readString(json['regionName']),
      entries: readMapList(
        json['entries'],
      ).map(DistrictRatingEntry.fromJson).toList(),
    );
  }
}

/// `SCHOOL | DISTRICT | REGION | ALL`.
enum StudentRatingScope {
  school('SCHOOL'),
  district('DISTRICT'),
  region('REGION'),
  all('ALL');

  const StudentRatingScope(this.apiValue);

  final String apiValue;
}

class StudentRatingEntry {
  const StudentRatingEntry({
    required this.rank,
    required this.userId,
    required this.fullName,
    required this.avatarUrl,
    required this.schoolName,
    required this.score,
    required this.isMe,
  });

  final int? rank;
  final int userId;
  final String fullName;
  final String? avatarUrl;
  final String? schoolName;
  final int? score;
  final bool isMe;

  factory StudentRatingEntry.fromJson(Map<String, dynamic> json) {
    return StudentRatingEntry(
      rank: readInt(json['rank']),
      userId: readIntOr(json['userId']),
      fullName: readStringOr(json['fullName']),
      avatarUrl: readString(json['avatarUrl']),
      schoolName: readString(json['schoolName']),
      score: readInt(json['score']),
      isMe: readBool(json['isMe']),
    );
  }
}

class StudentRating {
  const StudentRating({required this.entries, required this.me});

  final List<StudentRatingEntry> entries;
  final StudentRatingEntry? me;

  factory StudentRating.fromJson(Map<String, dynamic> json) {
    final me = json['me'];
    return StudentRating(
      entries: readMapList(
        json['entries'],
      ).map(StudentRatingEntry.fromJson).toList(),
      me: me is Map<String, dynamic> ? StudentRatingEntry.fromJson(me) : null,
    );
  }
}
