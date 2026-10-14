import 'package:synamyk/data/api/dio/synamyk_rest_client.dart';
import 'package:synamyk/domain/models/catalog/catalog_models.dart';
import 'package:synamyk/domain/models/common/json_read.dart';

/// App config (ОРТ date), catalog products and the reading-texts library.
abstract class CatalogRepository {
  Future<AppConfigModel> getAppConfig();

  Future<List<ProductModel>> getProducts();

  Future<ProductModel> getProduct(String code);

  Future<List<ReadingTextItem>> getTexts();

  /// 400 (with a localized message) when the user has no access.
  Future<ReadingTextDetail> getText(int id);
}

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl({required SynamykRestClient client}) : _client = client;

  final SynamykRestClient _client;

  @override
  Future<AppConfigModel> getAppConfig() async {
    final response = await _client.get('/api/app/config', auth: false);
    return AppConfigModel.fromJson(response.map);
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await _client.get('/api/products');
    return readMapList(response.list).map(ProductModel.fromJson).toList();
  }

  @override
  Future<ProductModel> getProduct(String code) async {
    final response = await _client.get('/api/products/$code');
    return ProductModel.fromJson(response.map);
  }

  @override
  Future<List<ReadingTextItem>> getTexts() async {
    final response = await _client.get('/api/texts');
    return readMapList(response.list).map(ReadingTextItem.fromJson).toList();
  }

  @override
  Future<ReadingTextDetail> getText(int id) async {
    final response = await _client.get('/api/texts/$id');
    return ReadingTextDetail.fromJson(response.map);
  }
}
