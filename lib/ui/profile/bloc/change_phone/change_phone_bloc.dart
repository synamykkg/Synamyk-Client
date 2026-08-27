import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/data/repositories/profile/profile_repository.dart';

part 'change_phone_event.dart';
part 'change_phone_state.dart';

class ChangePhoneBloc extends Bloc<ChangePhoneEvent, ChangePhoneState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  ChangePhoneBloc({required AuthRepository authRepository, required ProfileRepository profileRepository})
    : _profileRepository = profileRepository, _authRepository = authRepository,
      super(const ChangePhoneState()) {
    on<ChangePhoneOldPhoneChanged>(_onOldPhoneChanged);
    on<ChangePhoneNewPhoneChanged>(_onNewPhoneChanged);
    on<ChangePhoneSubmitted>(_onSubmitted);
  }

  void _onOldPhoneChanged(
    ChangePhoneOldPhoneChanged event,
    Emitter<ChangePhoneState> emit,
  ) {
    emit(
      state.copyWith(
        oldPhone: event.oldPhone,
        status: ChangePhoneStatus.initial,
      ),
    );
  }

  void _onNewPhoneChanged(
    ChangePhoneNewPhoneChanged event,
    Emitter<ChangePhoneState> emit,
  ) {
    emit(
      state.copyWith(
        newPhone: event.newPhone,
        status: ChangePhoneStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    ChangePhoneSubmitted event,
    Emitter<ChangePhoneState> emit,
  ) async {
    if (state.oldPhone.isEmpty || state.newPhone.isEmpty) {
      emit(
        state.copyWith(
          status: ChangePhoneStatus.failure,
          errorMessage: "Заполните оба поля",
        ),
      );
      return;
    }

    emit(state.copyWith(status: ChangePhoneStatus.loading));
    try {
      await _profileRepository.changePhone(state.oldPhone, state.newPhone);
      emit(state.copyWith(status: ChangePhoneStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: ChangePhoneStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
