import 'package:synamyk/domain/models/news/news_details.dart';
import 'package:synamyk/domain/models/news/news_title.dart';
import 'package:synamyk/domain/models/ort_test/ort_sub_test_question.dart';

abstract class NewsRepository {
  Future<List<NewsTitle>> getNewsList();

  Future<NewsDetails> getNews(String newsId);
}
