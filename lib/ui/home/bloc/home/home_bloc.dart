import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/home/home_repository.dart';
import 'package:synamyk/domain/models/home/subject_list.dart';

part 'home_state.dart';
part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;
  HomeBloc(this.repository) : super(HomeInitial()) {
    on<GetSubjectsList>((event, emit) async {
      emit(HomeLoading());

      try {
        final subjects = await repository.getHomeSubjectsList();
        emit(HomeLoaded(subjects: subjects));
        debugPrint(subjects.toString());
      } catch (e) {
        emit(HomeError(error: e));
      }
    });

    // on<GetSubjectTests>((event, emit) async {
    //   emit(HomeLoading());

    //   try {
    //     final tests = await repository.getSubjectTests(event.id);
    //     emit(HomeLoaded(subjects: tests));
    //     debugPrint(tests.toString());
    //   } catch (e) {
    //     emit(HomeError(error: e));
    //   }
    // });
  }
}
