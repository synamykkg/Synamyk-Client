// Event
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synamyk/data/repositories/language/language_repository.dart';
import 'package:synamyk/data/repositories/profile/profile_repository.dart';
import 'package:synamyk/domain/enums/app_language.dart';

abstract class LanguageEvent {}

class LanguageStarted extends LanguageEvent {}

class LanguageChanged extends LanguageEvent {
  final AppLanguage language;
  LanguageChanged(this.language);
}

// State
class LanguageState {
  final AppLanguage language;
  const LanguageState(this.language);

  Locale get locale => Locale(language.materialApp); // 'ru', 'ky', 'en'
}

// BLoC
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final LanguageRepository _repository;
  final ProfileRepository _profileRepository;

  LanguageBloc(this._repository, this._profileRepository)
    : super(LanguageState(_repository.current)) {
    on<LanguageStarted>(_onStarted);
    on<LanguageChanged>(_onChanged);
  }

  void _onStarted(LanguageStarted event, Emitter<LanguageState> emit) {
    // Загружаем сохранённый язык
    emit(LanguageState(_repository.current));
  }

  Future<void> _onChanged(
    LanguageChanged event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      final data = _profileRepository.changeLanguage(
        event.language.apiCode.toLowerCase(),
      );
      await _repository.save(event.language); // сохраняем в SharedPreferences
      emit(LanguageState(event.language));
    } catch (e) {
      rethrow;
    }
  }
}
