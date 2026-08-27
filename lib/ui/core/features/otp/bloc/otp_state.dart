enum OtpStatus { initial, loading, success, failure }

class OtpState {
  final String code;
  final OtpStatus status;
  final String? errorMessage;

  bool get isValid => code.length == 4;

  const OtpState({
    this.code = '',
    this.status = OtpStatus.initial,
    this.errorMessage,
  });

  OtpState copyWith({String? code, OtpStatus? status, String? errorMessage}) {
    return OtpState(
      code: code ?? this.code,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
