part of 'change_region_bloc.dart';

abstract class ChangeRegionEvent {}

class ChangeRegionSelected extends ChangeRegionEvent {
  final Region region;
  // final int regionId;
  ChangeRegionSelected({required this.region});
}

class ChangeRegionSubmitted extends ChangeRegionEvent {}

class ChangeRegionList extends ChangeRegionEvent {}
