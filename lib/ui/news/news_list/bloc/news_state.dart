part of 'news_bloc.dart';

final class NewsListState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class NewsListInitial extends NewsListState {
  @override
  List<Object?> get props => [];
}

final class NewsListLoading extends NewsListState {
  @override
  List<Object?> get props => [];
}

final class NewsListLoaded extends NewsListState {
  NewsListLoaded({required this.newsLists});

  final List<NewsTitle> newsLists;

  @override
  List<Object?> get props => [newsLists];
}

final class NewsListFailure extends NewsListState {
  NewsListFailure({required this.exception});

  final Object exception;

  @override
  List<Object?> get props => [];
}
