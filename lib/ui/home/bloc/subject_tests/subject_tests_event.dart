part of 'subject_tests_bloc.dart';

abstract class SubjectTestsEvent extends Equatable {}

class GetSubjectTestsList extends SubjectTestsEvent {
  GetSubjectTestsList({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
