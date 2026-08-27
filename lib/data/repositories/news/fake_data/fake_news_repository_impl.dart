import 'package:synamyk/data/repositories/news/fake_data/fake_news.dart';
import 'package:synamyk/data/repositories/news/news_repository.dart';
import 'package:synamyk/domain/models/news/news_details.dart';
import 'package:synamyk/domain/models/news/news_title.dart';

class FakeNewsRepositoryImpl implements NewsRepository {
  @override
  Future<List<NewsTitle>> getNewsList() async {
    final data = fakeNewsTitle;

    return data
        .map(
          (e) => NewsTitle(
            date: e["date"],
            id: e["id"],
            image: e["image"],
            title: e["title"],
            subTitle: e["subTitle"],
            url: e["url"],
          ),
        )
        .toList();
  }

  @override
  Future<NewsDetails> getNews(String newsId) async {
    return NewsDetails(id: 'id', image: "", html: "");
  }
}
