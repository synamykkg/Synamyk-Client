import 'package:synamyk/domain/models/common/json_read.dart';

/// One card on the «Тесттер» home list (`GET /api/tests`).
class FullTestListItem {
  const FullTestListItem({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.price,
    required this.totalDurationMinutes,
    required this.totalQuestions,
    required this.maxScore,
    required this.isFree,
    required this.hasAccess,
    required this.bestOrtScore,
    required this.completedAttempts,
    required this.resumableAttemptId,
  });

  final int id;
  final String title;
  final String description;
  final String? iconUrl;
  final double price;
  final int totalDurationMinutes;
  final int totalQuestions;
  final int maxScore;
  final bool isFree;
  final bool hasAccess;
  final int? bestOrtScore;
  final int completedAttempts;
  final int? resumableAttemptId;

  factory FullTestListItem.fromJson(Map<String, dynamic> json) {
    return FullTestListItem(
      id: readIntOr(json['id']),
      title: readStringOr(json['title']),
      description: readStringOr(json['description']),
      iconUrl: readString(json['iconUrl']),
      price: readDoubleOr(json['price']),
      totalDurationMinutes: readIntOr(json['totalDurationMinutes']),
      totalQuestions: readIntOr(json['totalQuestions']),
      maxScore: readIntOr(json['maxScore'], 245),
      isFree: readBool(json['isFree']),
      hasAccess: readBool(json['hasAccess']),
      bestOrtScore: readInt(json['bestOrtScore']),
      completedAttempts: readIntOr(json['completedAttempts']),
      resumableAttemptId: readInt(json['resumableAttemptId']),
    );
  }
}

/// A section card on the test detail screen.
class FullTestSection {
  const FullTestSection({
    required this.id,
    required this.title,
    required this.iconUrl,
    required this.durationMinutes,
    required this.questionCount,
    required this.maxScore,
  });

  final int id;
  final String title;
  final String? iconUrl;
  final int durationMinutes;
  final int questionCount;
  final int? maxScore;

  factory FullTestSection.fromJson(Map<String, dynamic> json) {
    return FullTestSection(
      id: readIntOr(json['id']),
      title: readStringOr(json['title']),
      iconUrl: readString(json['iconUrl']),
      durationMinutes: readIntOr(json['durationMinutes']),
      questionCount: readIntOr(json['questionCount']),
      maxScore: readInt(json['maxScore']),
    );
  }
}

/// `GET /api/tests/{testId}`.
class FullTestDetail {
  const FullTestDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.price,
    required this.isFree,
    required this.hasAccess,
    required this.totalDurationMinutes,
    required this.totalQuestions,
    required this.maxScore,
    required this.bestOrtScore,
    required this.resumableAttemptId,
    required this.resumableSectionIndex,
    required this.sections,
  });

  final int id;
  final String title;
  final String description;
  final String? iconUrl;
  final double price;
  final bool isFree;
  final bool hasAccess;
  final int totalDurationMinutes;
  final int totalQuestions;
  final int maxScore;
  final int? bestOrtScore;
  final int? resumableAttemptId;
  final int? resumableSectionIndex;
  final List<FullTestSection> sections;

  factory FullTestDetail.fromJson(Map<String, dynamic> json) {
    return FullTestDetail(
      id: readIntOr(json['id']),
      title: readStringOr(json['title']),
      description: readStringOr(json['description']),
      iconUrl: readString(json['iconUrl']),
      price: readDoubleOr(json['price']),
      isFree: readBool(json['isFree']),
      hasAccess: readBool(json['hasAccess']),
      totalDurationMinutes: readIntOr(json['totalDurationMinutes']),
      totalQuestions: readIntOr(json['totalQuestions']),
      maxScore: readIntOr(json['maxScore'], 245),
      bestOrtScore: readInt(json['bestOrtScore']),
      resumableAttemptId: readInt(json['resumableAttemptId']),
      resumableSectionIndex: readInt(json['resumableSectionIndex']),
      sections: readMapList(
        json['subTests'],
      ).map(FullTestSection.fromJson).toList(),
    );
  }
}
