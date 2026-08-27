import 'package:flutter/material.dart';
import 'package:synamyk/data/api/swagger/generated/synamyk_api.swagger.dart';
import 'package:synamyk/data/api/synamyk_api_client.dart';
import 'package:synamyk/data/repositories/video_lessons/video_lessons_repository.dart';
import 'package:synamyk/domain/models/video_lesson/video_lesson.dart';
import 'package:synamyk/error/app_exception.dart';

class VideoLessonsRepositoryImpl implements VideoLessonsRepository {
  VideoLessonsRepositoryImpl({required this.synamykApi});

  final SynamykApiClient synamykApi;

  @override
  Future<List<VideoLesson>> getVideoLessons({int? testId}) async {
    final response = await synamykApi.auth.apiAnalyticsVideosGet(testId: testId);
    final body = response.body;

    if (response.statusCode != 200 || body == null) {
      debugPrint(response.toString());
      throw AppException.unknown('Failed to get video lessons');
    }

    return body.map(_mapVideoLesson).toList();
  }

  VideoLesson _mapVideoLesson(VideoLessonResponse item) {
    final videoUrl = item.videoUrl ?? '';

    return VideoLesson(
      id: (item.id ?? 0).toString(),
      title: item.title ?? '',
      description: item.description ?? '',
      previewUrl: item.thumbnailUrl ?? '',
      videoUrl: videoUrl,
      date: '',
      duration: '',
    );
  }
}
