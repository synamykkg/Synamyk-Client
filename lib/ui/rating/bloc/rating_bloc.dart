import 'package:bloc/bloc.dart';
import 'package:synamyk/data/repositories/rating/rating_repository.dart';
import 'package:synamyk/domain/models/rating/rating_filter_model.dart';
import 'package:synamyk/domain/models/rating/rating_user_model.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository _ratingRepository;

  RatingBloc(this._ratingRepository) : super(RatingInitial()) {
    on<LoadRatingsEvent>(_onLoadRatings);
    on<SelectRatingFilterEvent>(_onSelectFilter);
  }

  Future<void> _onLoadRatings(
    LoadRatingsEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingLoading());
    try {
      final filters = await _ratingRepository.getRatingFilters();
      if (filters.isEmpty) {
        throw Exception('No rating filters found');
      }

      final selected = filters.first;
      final users = await _ratingRepository.getUsersRating(selected.id);
      emit(
        RatingLoaded(
          filters: filters,
          selectedTestId: selected.id,
          selectedTestTitle: selected.title,
          users: users,
        ),
      );
    } catch (e) {
      emit(RatingError(e.toString()));
    }
  }

  Future<void> _onSelectFilter(
    SelectRatingFilterEvent event,
    Emitter<RatingState> emit,
  ) async {
    final currentState = state;
    if (currentState is! RatingLoaded) {
      return;
    }

    emit(RatingLoading());
    try {
      final users = await _ratingRepository.getUsersRating(event.testId);
      final selected = currentState.filters.firstWhere(
        (f) => f.id == event.testId,
        orElse:
            () => RatingFilterModel(
              id: event.testId,
              title: currentState.selectedTestTitle,
            ),
      );

      emit(
        RatingLoaded(
          filters: currentState.filters,
          selectedTestId: selected.id,
          selectedTestTitle: selected.title,
          users: users,
        ),
      );
    } catch (e) {
      emit(RatingError(e.toString()));
    }
  }
}
