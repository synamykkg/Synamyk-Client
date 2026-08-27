import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/mappers/region_mapper.dart';
import 'package:synamyk/data/repositories/regions/regions_repository.dart';
import 'package:synamyk/domain/models/region/region_model.dart';
import 'package:synamyk/error/api_error_parser.dart';
import 'package:synamyk/error/app_exception.dart';

class RegionsRepositoryImpl implements RegionsRepository {
  final SynamykApiClient synamykApi;

  RegionsRepositoryImpl({required this.synamykApi});

  @override
  Future<List<Region>> getRegions() async {
    try {
      final result = await synamykApi.public.apiRegionsGet();

      if (!result.isSuccessful) {
        throw ExceptionParser.parseResponse(result.statusCode, result.error);
      }

      final body = result.body;
      if (body == null) throw AppException.unknown('Пустой ответ');

      return body.map((dto) => dto.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
