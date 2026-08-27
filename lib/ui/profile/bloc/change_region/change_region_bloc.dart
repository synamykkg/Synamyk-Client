import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/profile/profile_repository.dart';
import 'package:synamyk/data/repositories/regions/regions_repository.dart';
import 'package:synamyk/data/repositories/user/user_repository.dart';
import 'package:synamyk/domain/enums/region.dart';
import 'package:synamyk/domain/models/region/region_model.dart';
import 'package:synamyk/domain/models/user/user_model.dart';
import 'package:synamyk/error/app_exception.dart';

part 'change_region_event.dart';
part 'change_region_state.dart';

class ChangeRegionBloc extends Bloc<ChangeRegionEvent, ChangeRegionState> {
  final UserRepository _userRepository;
  final ProfileRepository _profileRepository;
  final RegionsRepository _regionsRepository;

  ChangeRegionBloc({
    required UserRepository userRepository,
    required ProfileRepository profileRepository,
    required RegionsRepository regionsRepository,
  }) : _regionsRepository = regionsRepository,
       _profileRepository = profileRepository,
       _userRepository = userRepository,
       super(ChangeRegionState()) {
    on<ChangeRegionSelected>(_onRegionSelected);
    on<ChangeRegionSubmitted>(_onSubmitted);
    on<ChangeRegionList>(_regionLoad);
  }

  Future<void> _regionLoad(
    ChangeRegionList event,
    Emitter<ChangeRegionState> emit,
  ) async {
    emit(state.copyWith(status: ChangeRegionStatus.loading));

    try {
      // Если регионы приходят из API или хранилища
      final regions = await _regionsRepository.getRegions();

      emit(
        state.copyWith(
          status: ChangeRegionStatus.initial,
          regions: regions, // ← список регионов в state
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: ChangeRegionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ChangeRegionStatus.failure,
          errorMessage: 'Произошла непредвиденная ошибка',
        ),
      );
    }
  }

  void _onRegionSelected(
    ChangeRegionSelected event,
    Emitter<ChangeRegionState> emit,
  ) {
    emit(
      state.copyWith(
        selectedRegion: event.region,
        status: ChangeRegionStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    ChangeRegionSubmitted event,
    Emitter<ChangeRegionState> emit,
  ) async {
    if (state.selectedRegion == null) {
      emit(
        state.copyWith(
          status: ChangeRegionStatus.failure,
          errorMessage: "Выберите регион",
        ),
      );
      return;
    }
    
    emit(state.copyWith(status: ChangeRegionStatus.loading));
    try {
      
      // Get current user
      final user = await _profileRepository.changeRegion(
        state.selectedRegion!.id, state.regions!
      );

      // Update user with new region by creating new instance
      // final updatedUser = UserModel(
      //   firstName: user.firstName,
      //   lastName: user.lastName,
      //   region: state.selectedRegion!.label,
      //   description: user.description,
      //   avatarPath: user.avatarPath,
      // );
      await _userRepository.saveUser(user);

      emit(state.copyWith(status: ChangeRegionStatus.success, errorMessage: ''));
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: ChangeRegionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ChangeRegionStatus.failure,
          errorMessage: 'Произошла непредвиденная ошибка',
        ),
      );
    }
  }
}
