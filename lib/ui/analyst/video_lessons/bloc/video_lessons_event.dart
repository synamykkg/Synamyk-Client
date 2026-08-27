part of 'video_lessons_bloc.dart';

abstract class VideoLessonsEvent extends Equatable {
  const VideoLessonsEvent();

  @override
  List<Object> get props => [];
}

class VideoLessonsRequest extends VideoLessonsEvent {}
