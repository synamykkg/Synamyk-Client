import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/repositories/news/news_repository.dart';
import 'package:synamyk/domain/models/news/news_details.dart';
import 'package:synamyk/domain/models/news/news_title.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl({required this.synamykApi});

  final SynamykApiClient synamykApi;

  @override
  Future<List<NewsTitle>> getNewsList() async {
    final response = await synamykApi.public.apiFeedNewsGet();
    final body = response.body;

    if (response.statusCode != 200 || body == null) {
      throw Exception('Failed to load news list');
    }

    return body
        .map(
          (item) => NewsTitle(
            id: (item.id ?? 0).toString(),
            image: item.coverImageUrl ?? '',
            title: item.title ?? '',
            subTitle: item.preview?.toString() ?? '',
            date: item.publishedAt?.toString() ?? '',
            // Kept for compatibility with existing model.
            url: '',
          ),
        )
        .toList();
  }

  @override
  Future<NewsDetails> getNews(String newsId) async {
    final id = int.tryParse(newsId);
    if (id == null) {
      throw Exception('Invalid news id');
    }

    final response = await synamykApi.public.apiFeedNewsIdGet(id: id);
    final body = response.body;

    if (response.statusCode != 200 || body == null) {
      throw Exception('Failed to load news details');
    }

    return NewsDetails(
      id: (body.id ?? 0).toString(),
      image: body.coverImageUrl ?? '',
      html: body.content ?? '',
    );
  }
}
