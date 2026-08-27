part of 'video_lessons_bloc.dart';

abstract class VideoLessonsState extends Equatable {
  const VideoLessonsState();

  @override
  List<Object> get props => [];
}

class VideoLessonsInitial extends VideoLessonsState {}

class VideoLessonsLoading extends VideoLessonsState {}

class VideoLessonsLoaded extends VideoLessonsState {
  final List<VideoLesson> videoLessons;

  const VideoLessonsLoaded({required this.videoLessons});

  @override
  List<Object> get props => [videoLessons];
}

class VideoLessonsFailure extends VideoLessonsState {
  final Object? exception;

  const VideoLessonsFailure({required this.exception});

  @override
  List<Object> get props => [exception ?? 'Unknown error'];
}
