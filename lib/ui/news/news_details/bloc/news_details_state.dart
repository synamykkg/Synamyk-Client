part of 'news_details_cubit.dart';

sealed class NewsDetailsState extends Equatable {
  const NewsDetailsState();

  @override
  List<Object?> get props => [];
}

class NewsDetailsInitial extends NewsDetailsState {
  const NewsDetailsInitial();
}

class NewsDetailsLoading extends NewsDetailsState {
  const NewsDetailsLoading();
}

class NewsDetailsLoaded extends NewsDetailsState {
  const NewsDetailsLoaded({required this.html});

  final String html;

  @override
  List<Object?> get props => [html];
}

class NewsDetailsFailure extends NewsDetailsState {
  const NewsDetailsFailure({required this.exception});

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
