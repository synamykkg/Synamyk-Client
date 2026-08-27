import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/domain/models/region/region_model.dart';

extension RegionDtoMapper on RegionDto {
  Region toDomain() {
    return Region(
      id: id ?? (throw Exception('Region.id is null')),
      name: name ?? (throw Exception('Region.name is null')),
      nameKy: nameKy ?? '',  // или тоже throw если обязательно
    );
  }
}