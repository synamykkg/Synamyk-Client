import 'package:synamyk/data/repositories/rating/rating_repository.dart';
import 'package:synamyk/domain/models/rating/rating_filter_model.dart';
import 'package:synamyk/domain/models/rating/rating_user_model.dart';

class FakeRatingRepositoryImpl implements RatingRepository {
  @override
  Future<List<RatingFilterModel>> getRatingFilters() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      RatingFilterModel(id: 1, title: 'Основной тест'),
      RatingFilterModel(id: 2, title: 'Математика'),
      RatingFilterModel(id: 3, title: 'История'),
    ];
  }

  @override
  Future<List<RatingUserModel>> getUsersRating(int testId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      RatingUserModel(id: 1, name: 'Alice', points: 120, rank: 1),
      RatingUserModel(id: 2, name: 'Bob', points: 100, rank: 2),
      RatingUserModel(id: 3, name: 'Charlie', points: 80, rank: 3),
      RatingUserModel(id: 4, name: 'David', points: 60, rank: 4),
      RatingUserModel(id: 5, name: 'Eve', points: 40, rank: 5),
    ];
  }
}
