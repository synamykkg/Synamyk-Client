import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:synamyk/data/repositories/video_lessons/fake_data/fake_video_lessons.dart';
import 'package:synamyk/data/repositories/video_lessons/video_lessons_repository.dart';
import 'package:synamyk/domain/models/video_lesson/video_lesson.dart';

class FakeVideoLessonsRepositoryImpl implements VideoLessonsRepository {
  FakeVideoLessonsRepositoryImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<VideoLesson>> getVideoLessons({int? testId}) async {
    // await Future.delayed(const Duration(milliseconds: 800));

    final ids = fakeVideoLessonsId.map((e) => e['videoUrl']).toList();
    debugPrint(ids.toString());

    final response = await dio.get(
      'https://www.googleapis.com/youtube/v3/videos',
      queryParameters: {
        'part': 'snippet,statistics,contentDetails',
        'id': ids.join(','),
      },
    );

    debugPrint(response.toString());

    final items = response.data['items'] as List;

    return items.map((e) => VideoLesson.fromJson(e)).toList();
  }
}
