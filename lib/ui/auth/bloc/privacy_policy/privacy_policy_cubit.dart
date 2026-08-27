// presentation/cubit/privacy_policy_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
// import '../../domain/usecases/open_privacy_policy.dart';

part 'privacy_policy_state.dart';

class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  final AuthRepository authRepository;

  PrivacyPolicyCubit(this.authRepository)
      : super(const PrivacyPolicyState());

  Future<void> open() async {
    emit(state.copyWith(status: PrivacyPolicyStatus.loading));

    try {
      await authRepository.openPrivacyPolicy();
      emit(state.copyWith(status: PrivacyPolicyStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: PrivacyPolicyStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}