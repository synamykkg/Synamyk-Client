part of 'subject_tests_bloc.dart';

abstract class SubjectTestsState extends Equatable {}

class SubjectTestsInitial extends SubjectTestsState {
  @override
  List<Object?> get props => [];
}

class SubjectTestsLoading extends SubjectTestsState {
  @override
  List<Object?> get props => [];
}

class SubjectTestsLoaded extends SubjectTestsState {
  SubjectTestsLoaded({
    required this.freeTests,
    required this.paidTests,
    required this.hasPaidAccess,
    required this.testTitle,
    required this.price,
  });

  final List<SubjectTests> freeTests;
  final List<SubjectTests> paidTests;
  final bool hasPaidAccess;
  final String testTitle;
  final double price;

  // SubjectTestsLoaded copyWith({
  //   SubjectTests? freeTests,
  //   SubjectTests? paidTests,
  // }) {
  //   return SubjectTestsLoaded(
  //     freeTests: freeTests ?? this.freeTests,
  //     paidTests: paidTests ?? this.paidTests,
  //   );
  // }

  @override
  List<Object?> get props => [freeTests, paidTests, hasPaidAccess, testTitle, price];
}

class SubjectTestsError extends SubjectTestsState {
  SubjectTestsError({required this.error});

  final Object error;

  @override
  List<Object?> get props => [error];
}
