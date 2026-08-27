import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/home/home_repository.dart';
import 'package:synamyk/domain/models/home/subject_model.dart';
import 'package:synamyk/domain/models/home/subject_tests.dart';

part 'subject_tests_event.dart';
part 'subject_tests_state.dart';

class SubjectTestsBloc extends Bloc<SubjectTestsEvent, SubjectTestsState> {
  final HomeRepository repository;
  SubjectTestsBloc({required this.repository}) : super(SubjectTestsInitial()) {
    on<GetSubjectTestsList>((event, emit) async {
      emit(SubjectTestsLoading());

      try {
        final tests = await repository.getSubjectTests(event.id);
        final freeTestsList = <SubjectTests>[];
        final paidTestsList = <SubjectTests>[];
        for (var element in tests.testsList) {
          if (element.isFree) {
            freeTestsList.add(element);
          } else {
            paidTestsList.add(element);
          }
        }
        emit(SubjectTestsLoaded(
          freeTests: freeTestsList,
          paidTests: paidTestsList,
          hasPaidAccess: tests.hasPaidAccess,
          testTitle: tests.title,
          price: double.tryParse(tests.tarif) ?? 0,
        ));
        debugPrint(tests.toString());
      } catch (e) {
        emit(SubjectTestsError(error: e));
      }
    });
  }
}
