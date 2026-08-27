part of 'news_bloc.dart';

sealed class NewsListEvent extends Equatable {
  const NewsListEvent();

  @override
  List<Object> get props => [];
}

class NewsListRequest extends NewsListEvent {
  const NewsListRequest();
}
