import 'package:synamyk/domain/models/common/json_read.dart';

/// `GET /api/app/config`.
class AppConfigModel {
  const AppConfigModel({
    required this.ortExamDate,
    required this.secondsUntilExam,
    required this.ortMaxScore,
    required this.ortThresholdScore,
    required this.schoolRatingMinStudents,
  });

  final DateTime? ortExamDate;
  final int? secondsUntilExam;
  final int ortMaxScore;
  final int ortThresholdScore;
  final int schoolRatingMinStudents;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      ortExamDate: readDate(json['ortExamDate']),
      secondsUntilExam: readInt(json['secondsUntilExam']),
      ortMaxScore: readIntOr(json['ortMaxScore'], 245),
      ortThresholdScore: readIntOr(json['ortThresholdScore'], 110),
      schoolRatingMinStudents: readIntOr(json['schoolRatingMinStudents'], 3),
    );
  }
}

/// Catalog products sold via `POST /api/payments/init?product=CODE`.
abstract final class ProductCodes {
  static const allTests = 'ALL_TESTS';
  static const allTexts = 'ALL_TEXTS';
}

class ProductModel {
  const ProductModel({
    required this.code,
    required this.title,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.available,
    required this.owned,
    required this.features,
  });

  final String code;
  final String title;
  final String description;
  final double price;
  final double? oldPrice;
  final bool available;
  final bool owned;
  final List<String> features;

  /// Show the «buy» banner/entry point.
  bool get canBuy => available && !owned;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      code: readStringOr(json['code']),
      title: readStringOr(json['title']),
      description: readStringOr(json['description']),
      price: readDoubleOr(json['price']),
      oldPrice: readDouble(json['oldPrice']),
      available: readBool(json['available']),
      owned: readBool(json['owned']),
      features: readStringList(json['features']),
    );
  }
}

class ReadingTextItem {
  const ReadingTextItem({
    required this.id,
    required this.title,
    required this.free,
    required this.hasAccess,
    required this.hasPdf,
  });

  final int id;
  final String title;
  final bool free;
  final bool hasAccess;
  final bool hasPdf;

  factory ReadingTextItem.fromJson(Map<String, dynamic> json) {
    return ReadingTextItem(
      id: readIntOr(json['id']),
      title: readStringOr(json['title']),
      free: readBool(json['free']),
      hasAccess: readBool(json['hasAccess']),
      hasPdf: readBool(json['hasPdf']),
    );
  }
}

class ReadingTextDetail {
  const ReadingTextDetail({
    required this.id,
    required this.title,
    required this.content,
    required this.pdfUrl,
  });

  final int id;
  final String title;
  final String? content;

  /// Presigned, valid for one hour — open right away, never cache.
  final String? pdfUrl;

  factory ReadingTextDetail.fromJson(Map<String, dynamic> json) {
    return ReadingTextDetail(
      id: readIntOr(json['id']),
      title: readStringOr(json['title']),
      content: readString(json['content']),
      pdfUrl: readString(json['pdfUrl']),
    );
  }
}
