// presentation/cubit/privacy_policy_state.dart
part of 'privacy_policy_cubit.dart';

enum PrivacyPolicyStatus { initial, loading, success, failure }

class PrivacyPolicyState extends Equatable {
  final PrivacyPolicyStatus status;
  final String? errorMessage;

  const PrivacyPolicyState({
    this.status = PrivacyPolicyStatus.initial,
    this.errorMessage,
  });

  PrivacyPolicyState copyWith({
    PrivacyPolicyStatus? status,
    String? errorMessage,
  }) {
    return PrivacyPolicyState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}