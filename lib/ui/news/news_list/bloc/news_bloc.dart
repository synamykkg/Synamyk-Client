import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:synamyk/data/repositories/news/news_repository.dart';
import 'package:synamyk/domain/models/news/news_title.dart';

part 'news_state.dart';
part 'news_event.dart';

class NewsListBloc extends Bloc<NewsListEvent, NewsListState> {
  NewsListBloc(this.newsRepository) : super(NewsListInitial()) {
    on<NewsListRequest>((event, emit) async {
      emit(NewsListLoading());
      try {
        final newsListData = await newsRepository.getNewsList();
        emit(NewsListLoaded(newsLists: newsListData));
      } catch (e) {
        emit(NewsListFailure(exception: e));
      }
    });
  }
  final NewsRepository newsRepository;
}
