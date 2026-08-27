import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/domain/models/region/region_model.dart';

abstract class RegionsRepository {
  Future<List<Region>> getRegions();
}
