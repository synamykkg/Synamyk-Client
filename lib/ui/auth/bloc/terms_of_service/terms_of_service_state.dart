// presentation/cubit/privacy_policy_state.dart
part of 'terms_of_service_cubit.dart';

enum TermsOfServiceStatus { initial, loading, success, failure }

class TermsOfServiceState extends Equatable {
  final TermsOfServiceStatus status;
  final String? errorMessage;

  const TermsOfServiceState({
    this.status = TermsOfServiceStatus.initial,
    this.errorMessage,
  });

  TermsOfServiceState copyWith({
    TermsOfServiceStatus? status,
    String? errorMessage,
  }) {
    return TermsOfServiceState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}