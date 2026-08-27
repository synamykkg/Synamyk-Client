import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/news/news_repository.dart';
import 'package:synamyk/domain/models/news/news_details.dart';

part 'news_details_state.dart';

class NewsDetailsCubit extends Cubit<NewsDetailsState> {
  NewsDetailsCubit({required NewsRepository newsRepository})
    : _newsRepository = newsRepository,
      super(const NewsDetailsInitial());

  final NewsRepository _newsRepository;

  Future<void> loadNews(String newsId) async {
    emit(const NewsDetailsLoading());
    try {
      final news = await _newsRepository.getNews(newsId);
      emit(NewsDetailsLoaded(html: _buildHtml(news)));
    } catch (e) {
      emit(NewsDetailsFailure(exception: e));
    }
  }

  String _buildHtml(NewsDetails news) {
    final imageBlock = news.image.isEmpty
        ? ''
        : '<img src="${news.image}" style="width:100%;height:auto;border-radius:12px;" />';

    return '''
<!doctype html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; padding: 16px; line-height: 1.5; color: #111; }
      img { margin-bottom: 16px; }
    </style>
  </head>
  <body>
    $imageBlock
    ${news.html}
  </body>
</html>
''';
  }
}
