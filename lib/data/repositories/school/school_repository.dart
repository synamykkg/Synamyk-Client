import 'package:synamyk/data/api/dio/synamyk_rest_client.dart';
import 'package:synamyk/domain/models/common/json_read.dart';
import 'package:synamyk/domain/models/common/paged_result.dart';
import 'package:synamyk/domain/models/school/school_models.dart';

/// Districts/schools directory, the user's school, and the school, district
/// and student ratings.
abstract class SchoolRepository {
  /// Public (no token) — used during sign-up.
  Future<List<District>> getDistricts(int regionId);

  /// Public (no token) — used during sign-up.
  Future<PagedResult<School>> getSchools(
    int districtId, {
    String? search,
    int page = 0,
    int size = 50,
  });

  /// `null` when no school is selected (204).
  Future<MySchool?> getMySchool();

  Future<MySchool> setMySchool(int schoolId);

  /// Without [districtId] — the district of the user's school; 400 when the
  /// user hasn't picked a school yet.
  Future<SchoolRating> getSchoolRating({
    required SchoolRatingSort sort,
    int? districtId,
  });

  Future<DistrictRating> getDistrictRating({int? regionId});

  Future<StudentRating> getStudentRating(StudentRatingScope scope);
}

class SchoolRepositoryImpl implements SchoolRepository {
  SchoolRepositoryImpl({
    required SynamykRestClient client,
    required String Function() languageCode,
  }) : _client = client,
       _languageCode = languageCode;

  final SynamykRestClient _client;

  /// `RU` / `KY` — the public endpoints can't read the user's language.
  final String Function() _languageCode;

  @override
  Future<List<District>> getDistricts(int regionId) async {
    final response = await _client.get(
      '/api/regions/$regionId/districts',
      query: {'lang': _languageCode()},
      auth: false,
    );
    return readMapList(response.list).map(District.fromJson).toList();
  }

  @override
  Future<PagedResult<School>> getSchools(
    int districtId, {
    String? search,
    int page = 0,
    int size = 50,
  }) async {
    final response = await _client.get(
      '/api/districts/$districtId/schools',
      query: {
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        'page': page,
        'size': size,
        'lang': _languageCode(),
      },
      auth: false,
    );
    return readPage(response.map, School.fromJson, page);
  }

  @override
  Future<MySchool?> getMySchool() async {
    final response = await _client.get('/api/profile/school');
    if (response.isNoContent) return null;
    return MySchool.fromJson(response.map);
  }

  @override
  Future<MySchool> setMySchool(int schoolId) async {
    final response = await _client.put(
      '/api/profile/school',
      body: {'schoolId': schoolId},
    );
    return MySchool.fromJson(response.map);
  }

  @override
  Future<SchoolRating> getSchoolRating({
    required SchoolRatingSort sort,
    int? districtId,
  }) async {
    final response = await _client.get(
      '/api/rating/schools',
      query: {'sort': sort.apiValue, 'districtId': districtId},
    );
    return SchoolRating.fromJson(response.map);
  }

  @override
  Future<DistrictRating> getDistrictRating({int? regionId}) async {
    final response = await _client.get(
      '/api/rating/districts',
      query: {'regionId': regionId},
    );
    return DistrictRating.fromJson(response.map);
  }

  @override
  Future<StudentRating> getStudentRating(StudentRatingScope scope) async {
    final response = await _client.get(
      '/api/rating/students',
      query: {'scope': scope.apiValue},
    );
    return StudentRating.fromJson(response.map);
  }
}
