import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/repositories/rating/rating_repository.dart';
import 'package:synamyk/domain/models/rating/rating_filter_model.dart';
import 'package:synamyk/domain/models/rating/rating_user_model.dart';

class RatingRepositoryImpl implements RatingRepository {
  RatingRepositoryImpl({required this.synamykApi});

  final SynamykApiClient synamykApi;

  @override
  Future<List<RatingFilterModel>> getRatingFilters() async {
    final response = await synamykApi.public.apiFeedRatingFiltersGet();
    final body = response.body;

    if (response.statusCode != 200 || body == null) {
      throw Exception('Failed to load rating filters');
    }

    return body
        .map(
          (e) => RatingFilterModel(
            id: (e.id ?? 0).toInt(),
            title: e.title ?? '',
          ),
        )
        .toList();
  }

  @override
  Future<List<RatingUserModel>> getUsersRating(int testId) async {
    final response = await synamykApi.public.apiFeedRatingTestIdGet(
      testId: testId,
    );
    final body = response.body;

    if (response.statusCode != 200 || body == null) {
      throw Exception('Failed to load rating');
    }

    final entries = body.entries ?? [];
    return entries
        .map(
          (e) => RatingUserModel(
            id: (e.userId ?? 0).toInt(),
            name: e.fullName ?? 'Unknown',
            points: (e.score ?? 0).toInt(),
            rank: (e.rank ?? 0).toInt(),
          ),
        )
        .toList();
  }
}
