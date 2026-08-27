import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:synamyk/data/repositories/video_lessons/video_lessons_repository.dart';
import 'package:synamyk/domain/models/video_lesson/video_lesson.dart';
import 'package:synamyk/error/app_exception.dart';

part 'video_lessons_event.dart';
part 'video_lessons_state.dart';

class VideoLessonsBloc extends Bloc<VideoLessonsEvent, VideoLessonsState> {
  final VideoLessonsRepository _repository;

  VideoLessonsBloc(this._repository) : super(VideoLessonsInitial()) {
    on<VideoLessonsRequest>(_onVideoLessonsRequest);
  }

  Future<void> _onVideoLessonsRequest(
    VideoLessonsRequest event,
    Emitter<VideoLessonsState> emit,
  ) async {
    emit(VideoLessonsLoading());
    try {
      final lessons = await _repository.getVideoLessons();
      debugPrint(lessons.toString());

      emit(VideoLessonsLoaded(videoLessons: lessons));
    } catch (e) {
      debugPrint(e.toString());
      emit(VideoLessonsFailure(exception: e));
    }
  }
}
