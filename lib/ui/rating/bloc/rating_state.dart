part of 'rating_bloc.dart';

abstract class RatingState {}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingLoaded extends RatingState {
  final List<RatingFilterModel> filters;
  final int selectedTestId;
  final String selectedTestTitle;
  final List<RatingUserModel> users;

  RatingLoaded({
    required this.filters,
    required this.selectedTestId,
    required this.selectedTestTitle,
    required this.users,
  });
}

class RatingError extends RatingState {
  final String message;

  RatingError(this.message);
}
