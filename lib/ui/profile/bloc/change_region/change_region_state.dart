part of 'change_region_bloc.dart';

enum ChangeRegionStatus { initial, loading, success, failure }

class ChangeRegionState {
  final ChangeRegionStatus status;
  final Region? selectedRegion;
  final String? errorMessage;
  final List<Region>? regions;

  const ChangeRegionState({
    this.status = ChangeRegionStatus.initial,
    this.selectedRegion,
    this.errorMessage,
    this.regions,
  });

  ChangeRegionState copyWith({
    ChangeRegionStatus? status,
    Region? selectedRegion,
    String? errorMessage,
    List<Region>? regions,
  }) {
    return ChangeRegionState(
      status: status ?? this.status,
      selectedRegion: selectedRegion ?? this.selectedRegion,
      errorMessage: errorMessage ?? this.errorMessage,
      regions: regions ?? this.regions,
    );
  }
}
