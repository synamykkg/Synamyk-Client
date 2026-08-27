import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/ui/core/features/otp/bloc/otp_state.dart';
import 'package:synamyk/ui/core/features/otp/models/otp_config.dart';


class OtpCubit extends Cubit<OtpState> {
  final OtpConfig config;

  OtpCubit({required this.config}) : super(const OtpState());

  void codeChanged(String code) {
    emit(state.copyWith(code: code, status: OtpStatus.initial));
  }

  Future<void> confirm() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: OtpStatus.loading));
    try {
      await config.onConfirm(state.code, config.phone);
      emit(state.copyWith(status: OtpStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: OtpStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> resend() async {
    try {
      await config.onResend(config.phone);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Не удалось отправить код'));
    }
  }
}
