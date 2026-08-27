import 'package:synamyk/domain/models/video_lesson/video_lesson.dart';

abstract class VideoLessonsRepository {
  Future<List<VideoLesson>> getVideoLessons({int? testId});
}
