part of 'rating_bloc.dart';

abstract class RatingEvent {}

class LoadRatingsEvent extends RatingEvent {}

class SelectRatingFilterEvent extends RatingEvent {
  final int testId;

  SelectRatingFilterEvent(this.testId);
}
