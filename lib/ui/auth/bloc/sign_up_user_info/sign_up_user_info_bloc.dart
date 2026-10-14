import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/data/repositories/regions/regions_repository.dart';
import 'package:synamyk/domain/enums/auth_step_status.dart';
import 'package:synamyk/domain/enums/region.dart';
// import 'package:synamyk/domain/enums/region.dart';

import 'package:synamyk/domain/models/auth/registration_info.dart';
import 'package:synamyk/domain/models/region/region_model.dart';
import 'package:synamyk/domain/models/school/school_models.dart';
import 'package:synamyk/ui/auth/bloc/app_auth_bloc.dart';

part 'sign_up_user_info_event.dart';
part 'sign_up_user_info_state.dart';

class SignUpUserInfoBloc
    extends Bloc<SignUpUserInfoEvent, SignUpUserInfoState> {
  final AuthRepository _authRepository;
  final RegionsRepository _regionRepository;
  final AppAuthBloc _appAuthBloc;

  SignUpUserInfoBloc({
    required AuthRepository authRepository,
    required AppAuthBloc appAuthBloc,
    required RegionsRepository regionRepository
  }) : _authRepository = authRepository,
       _appAuthBloc = appAuthBloc,
       _regionRepository = regionRepository,
       super(SignUpUserInfoState()) {
    on<SignUpUserInfoNameChanged>((event, emit) {
      emit(
        state.copyWith(
          firstName: event.firstName,
          status: AuthStepStatus.initial,
          
        ),
      );
    });
    on<SignUpUserInfoSurnameChanged>((event, emit) {
      emit(
        state.copyWith(
          lastName: event.lastName,
          status: AuthStepStatus.initial,
        ),
      );
    });
    on<SignUpUserInfoRegionChanged>((event, emit) {
      final changed = state.region?.id != event.region.id;
      emit(
        state.copyWith(
          region: event.region,
          clearDistrict: changed,
          clearSchool: changed,
          status: AuthStepStatus.initial,
        ),
      );
    });
    on<SignUpUserInfoDistrictChanged>((event, emit) {
      final changed = state.district?.id != event.district.id;
      emit(
        state.copyWith(
          district: event.district,
          clearSchool: changed,
          status: AuthStepStatus.initial,
        ),
      );
    });
    on<SignUpUserInfoSchoolChanged>((event, emit) {
      emit(state.copyWith(school: event.school, status: AuthStepStatus.initial));
    });
    on<SignUpUserInfoReferralCodeChanged>((event, emit) {
      emit(
        state.copyWith(referralCode: event.code, status: AuthStepStatus.initial),
      );
    });
    on<SignUpUserInfoSubmit>(_onSubmit);
    on<SignUpUserInfoRegionGet>(_getRegions);
  }

  Future<void> _getRegions(
    SignUpUserInfoRegionGet event,
    Emitter<SignUpUserInfoState> emit,
  ) async {
    emit(state.copyWith(status: AuthStepStatus.loading));

    try {
      final allRegions = await _regionRepository.getRegions();
      emit(state.copyWith(regionsList: allRegions, status: AuthStepStatus.initial));

    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStepStatus.failed,
          error: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  Future<void> _onSubmit(
    SignUpUserInfoSubmit event,
    Emitter<SignUpUserInfoState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: AuthStepStatus.loading));
    try {
      final info = RegistrationInfo(
        firstName: state.firstName,
        lastName: state.lastName,
        region: state.region!.id,
        schoolId: state.school?.id,
        referralCode: state.referralCode,
      );
      await _authRepository.saveUserInfo(info);
      _appAuthBloc.add(AppAuthLoggedIn());
      emit(state.copyWith(status: AuthStepStatus.success));
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          status: AuthStepStatus.failed,
          error: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }
}
