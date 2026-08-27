part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {}

class GetSubjectsList extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class GetSubjectTests extends HomeEvent {
  GetSubjectTests({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
