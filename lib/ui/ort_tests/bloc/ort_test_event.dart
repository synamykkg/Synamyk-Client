part of 'ort_test_bloc.dart';

abstract class OrtTestEvent extends Equatable {}

class LoadOrtTest extends OrtTestEvent {
  LoadOrtTest({required this.language, required this.id});

  final String language;
  final int id;

  @override
  List<Object?> get props => [language, id];
}

class GetOrtTest extends OrtTestEvent {
  GetOrtTest();

  @override
  List<Object?> get props => [];
}

class SubmitOrtTest extends OrtTestEvent {
  SubmitOrtTest();

  @override
  List<Object?> get props => [];
}

class SkipOrtTest extends OrtTestEvent {
  @override
  List<Object?> get props => [];
}

class SendDataOrtTest extends OrtTestEvent {
  SendDataOrtTest({required this.duration});

  final int duration;

  @override
  List<Object?> get props => [duration];
}

class SelectVariantTest extends OrtTestEvent {
  SelectVariantTest({required this.variant});

  final OrtSubTestOption variant;

  @override
  List<Object?> get props => [variant];
}

class InitialVariantTest extends OrtTestEvent {
  @override
  List<Object?> get props => [];
}

class StartTimerOrtTest extends OrtTestEvent {
  StartTimerOrtTest({required this.duration});

  final int duration;

  @override
  List<Object?> get props => [duration];
}

class StopTimerOrtTest extends OrtTestEvent {
  @override
  List<Object?> get props => [];
}

class TimerTicked extends OrtTestEvent {
  TimerTicked({required this.duration});
  final int duration;

  @override
  List<Object?> get props => [duration];
}

class OpenExitModal extends OrtTestEvent {
  @override
  List<Object?> get props => [];
}

class CloseExitModal extends OrtTestEvent {
  @override
  List<Object?> get props => [];
}

class SubmitExitModal extends OrtTestEvent {
  @override
  List<Object?> get props => [];
}
