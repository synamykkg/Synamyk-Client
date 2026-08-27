part of 'change_phone_bloc.dart';

abstract class ChangePhoneEvent {}

class ChangePhoneOldPhoneChanged extends ChangePhoneEvent {
  final String oldPhone;
  ChangePhoneOldPhoneChanged(this.oldPhone);
}

class ChangePhoneNewPhoneChanged extends ChangePhoneEvent {
  final String newPhone;
  ChangePhoneNewPhoneChanged(this.newPhone);
}

class ChangePhoneSubmitted extends ChangePhoneEvent {}
