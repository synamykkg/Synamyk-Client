import 'package:synamyk/domain/models/common/paged_result.dart';

/// Lenient readers for hand-parsed API JSON: numbers may arrive as int or
/// double, and any field may be missing on older backend versions.
int? readInt(Object? v) => v is num ? v.toInt() : int.tryParse('${v ?? ''}');

int readIntOr(Object? v, [int fallback = 0]) => readInt(v) ?? fallback;

double? readDouble(Object? v) =>
    v is num ? v.toDouble() : double.tryParse('${v ?? ''}');

double readDoubleOr(Object? v, [double fallback = 0]) =>
    readDouble(v) ?? fallback;

String? readString(Object? v) => v is String ? v : v?.toString();

String readStringOr(Object? v, [String fallback = '']) =>
    readString(v) ?? fallback;

bool readBool(Object? v, [bool fallback = false]) => v is bool ? v : fallback;

bool? readBoolOrNull(Object? v) => v is bool ? v : null;

/// Backend dates are zone-less local time (Asia/Bishkek).
DateTime? readDate(Object? v) => v is String ? DateTime.tryParse(v) : null;

List<Map<String, dynamic>> readMapList(Object? v) =>
    v is List ? v.whereType<Map<String, dynamic>>().toList() : const [];

List<int> readIntList(Object? v) =>
    v is List ? v.map(readInt).whereType<int>().toList() : const [];

List<String> readStringList(Object? v) =>
    v is List ? v.map((e) => '$e').toList() : const [];

/// Spring `Page<T>` → [PagedResult].
PagedResult<T> readPage<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic>) parse,
  int requestedPage,
) {
  final content = readMapList(json['content']).map(parse).toList();
  return PagedResult(
    content: content,
    totalElements: readIntOr(json['totalElements'], content.length),
    number: readIntOr(json['number'], requestedPage),
    last: readBool(json['last'], true),
  );
}
