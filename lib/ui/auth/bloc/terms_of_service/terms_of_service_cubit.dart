// presentation/cubit/privacy_policy_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
// import '../../domain/usecases/open_privacy_policy.dart';

part 'terms_of_service_state.dart';

class TermsOfServiceCubit extends Cubit<TermsOfServiceState> {
  final AuthRepository authRepository;

  TermsOfServiceCubit(this.authRepository)
      : super(const TermsOfServiceState());

  Future<void> open() async {
    emit(state.copyWith(status: TermsOfServiceStatus.loading));

    try {
      await authRepository.openTermsOfService();
      emit(state.copyWith(status: TermsOfServiceStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: TermsOfServiceStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}