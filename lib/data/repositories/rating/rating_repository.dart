import 'package:synamyk/domain/models/rating/rating_filter_model.dart';
import 'package:synamyk/domain/models/rating/rating_user_model.dart';

abstract class RatingRepository {
  Future<List<RatingFilterModel>> getRatingFilters();

  Future<List<RatingUserModel>> getUsersRating(int testId);
}
