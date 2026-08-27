import 'package:equatable/equatable.dart';
import 'package:synamyk/domain/models/user/user_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];

  get user => null;
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  @override
  final UserModel? user;

  /// True while an avatar upload/delete request is in flight — the UI
  /// shows a loader over the avatar without hiding the rest of the profile.
  final bool isAvatarUpdating;

  /// One-shot error from the last avatar upload/delete attempt (e.g. "file
  /// too large"), surfaced once via a BlocListener and not re-shown after.
  final String? avatarError;

  const ProfileLoaded(
    this.user, {
    this.isAvatarUpdating = false,
    this.avatarError,
  });

  @override
  List<Object?> get props => [user, isAvatarUpdating, avatarError];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileLoggedOut extends ProfileState {}
