import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/ui/profile/bloc/change_user_info/change_user_info_event.dart';
import 'package:synamyk/ui/profile/bloc/change_user_info/change_user_info_state.dart';

class ChangeUserInfoBloc extends Bloc<ChangeUserInfoEvent, ChangeUserInfoState> {
  ChangeUserInfoBloc() : super(ChangeUserInfoState()) {
    

    on<ChangeFirstName>(
      (event, emit) {
        emit(state.copyWith(firstName: event.firstName));
      },
    );

    on<ChangeLastName>(
      (event, emit) {
        emit(state.copyWith(lastName: event.lastName));
      },
    );

    on<ChangeDescription>(
      (event, emit) {
        emit(state.copyWith(description: event.description));
      },
    );

    on<ChangeAvatar>(
      (event, emit) {
        emit(state.copyWith(avatarPath: event.path));
      },
    );

    
  }
}