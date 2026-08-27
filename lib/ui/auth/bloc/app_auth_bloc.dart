import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:synamyk/data/repositories/auth/auth_repository.dart';
import 'package:synamyk/data/services/push_notification_service.dart';

// Events
abstract class AppAuthEvent {}

class AppAuthCheckRequested extends AppAuthEvent {}

class AppAuthLogoutRequested extends AppAuthEvent {}

class AppAuthLoggedIn
    extends AppAuthEvent {} // Triggered when sign in/up succeeds

// States
enum AppAuthStatus { unknown, authenticated, unauthenticated }

class AppAuthState {
  final AppAuthStatus status;

  const AppAuthState._({this.status = AppAuthStatus.unknown});

  const AppAuthState.unknown() : this._();
  const AppAuthState.authenticated()
    : this._(status: AppAuthStatus.authenticated);
  const AppAuthState.unauthenticated()
    : this._(status: AppAuthStatus.unauthenticated);
}

// Bloc
class AppAuthBloc extends Bloc<AppAuthEvent, AppAuthState> {
  final AuthRepository _authRepository;

  AppAuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AppAuthState.unknown()) {
    on<AppAuthCheckRequested>(_onAuthCheckRequested);
    on<AppAuthLogoutRequested>(_onLogoutRequested);
    on<AppAuthLoggedIn>(_onLoggedIn);
  }

  Future<void> _onAuthCheckRequested(
    AppAuthCheckRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    try {
      // Check if session exists and is valid (refresh it)
      final savedToken = await _authRepository.getSavedSession();
      if (savedToken != null) {
        await _authRepository.refreshSession();
        emit(const AppAuthState.authenticated());
      } else {
        emit(const AppAuthState.unauthenticated());
      }
    } catch (_) {
      emit(const AppAuthState.unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    AppAuthLogoutRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    // Unregister the FCM token while the JWT is still valid, before it's
    // cleared by _authRepository.logout().
    await GetIt.I<PushNotificationService>().unregisterToken();
    await _authRepository.logout();
    emit(const AppAuthState.unauthenticated());
  }

  Future<void> _onLoggedIn(
    AppAuthLoggedIn event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(const AppAuthState.authenticated());
    unawaited(GetIt.I<PushNotificationService>().registerCurrentToken());
  }
}
