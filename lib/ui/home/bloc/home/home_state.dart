part of 'home_bloc.dart';

abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeState {
  HomeLoaded({required this.subjects});

  final List<SubjectList> subjects;

  @override
  List<Object?> get props => [subjects];
}

class HomeError extends HomeState {
  HomeError({required this.error});

  final Object error;

  @override
  List<Object?> get props => [error];
}

