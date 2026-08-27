import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:synamyk/data/repositories/profile/profile_repository.dart';
import 'package:synamyk/data/repositories/user/image/image_repository.dart';
import 'package:synamyk/data/repositories/user/user_repository.dart';
import 'package:synamyk/domain/models/user/user_model.dart';
import 'package:synamyk/error/app_exception.dart';
import 'package:synamyk/ui/profile/bloc/profile_event.dart';
import 'package:synamyk/ui/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final ImageRepository _imageRepository;
  final ProfileRepository _profileRepository;

  ProfileBloc(
    this._userRepository,
    this._imageRepository,
    this._profileRepository,
  ) : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<LogOut>(_onLogOut);
    on<SaveAvatar>(_onSaveAvatar);
    // on<ChangeFirstName>(_onChangeFirstName);
    // on<ChangeLastName>(_onChangeLastName);
    // on<ChangeDescription>(_onChangeDescription);
    on<SaveProfile>(_onSaveProfile);
    on<UploadAvatarRequested>(_onUploadAvatarRequested);
    on<DeleteAvatarRequested>(_onDeleteAvatarRequested);
  }

  Future<void> _onUploadAvatarRequested(
    UploadAvatarRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state;
    final currentUser =
        current is ProfileLoaded ? current.user : await _userRepository.getUser();
    emit(ProfileLoaded(currentUser, isAvatarUpdating: true));

    try {
      final compressed = await FlutterImageCompress.compressWithFile(
        event.filePath,
        minWidth: 1024,
        minHeight: 1024,
        quality: 80,
        format: CompressFormat.jpeg,
      );
      if (compressed == null) {
        throw AppException.unknown('Не удалось обработать изображение');
      }

      final updatedUser = await _profileRepository.uploadAvatar(compressed);
      emit(ProfileLoaded(updatedUser));
    } on AppException catch (e) {
      emit(
        ProfileLoaded(
          currentUser,
          avatarError: e.message ?? 'Не удалось обновить фото',
        ),
      );
    } catch (_) {
      emit(
        ProfileLoaded(currentUser, avatarError: 'Не удалось обновить фото'),
      );
    }
  }

  Future<void> _onDeleteAvatarRequested(
    DeleteAvatarRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state;
    final currentUser =
        current is ProfileLoaded ? current.user : await _userRepository.getUser();
    emit(ProfileLoaded(currentUser, isAvatarUpdating: true));

    try {
      final updatedUser = await _profileRepository.deleteAvatar();
      emit(ProfileLoaded(updatedUser));
    } on AppException catch (e) {
      emit(
        ProfileLoaded(
          currentUser,
          avatarError: e.message ?? 'Не удалось удалить фото',
        ),
      );
    } catch (_) {
      emit(
        ProfileLoaded(currentUser, avatarError: 'Не удалось удалить фото'),
      );
    }
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final userInfo = await _profileRepository.getUserInfo();
      final user = await _userRepository.getUser();
      emit(ProfileLoaded(user));
    } on AppException catch (e) {
      if (e.message == null) {
        emit(ProfileError(e.message!));
      } else {
        emit(ProfileError(e.toString()));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLogOut(LogOut event, Emitter<ProfileState> emit) async {
    try {
      await _userRepository.deleteUser();
      emit(ProfileLoggedOut());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onSaveProfile(
    SaveProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await _userRepository.getUser();

      if (user == null) {
        emit(ProfileError('User not found'));
        return;
      }

      final updatedUser = user.copyWith(
        firstName: event.firstName,
        lastName: event.lastName,
        description: event.description,
        avatarPath: event.avatarPath,
      );

      await _profileRepository.changeUserProfile(
        firstName: updatedUser.firstName,
        lastName: updatedUser.lastName,
        bio: updatedUser.description,
        avatarUrl: updatedUser.avatarPath == '' ? null : updatedUser.avatarPath,
      );

      emit(ProfileLoaded(updatedUser)); // ✅ НОВЫЕ ДАННЫЕ
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // Future<void> _onChangeFirstName(
  //   ChangeFirstName event,
  //   Emitter<ProfileState> emit,
  // ) async {
  //   emit(ProfileLoading());
  //   try {
  //     UserModel? user = await _userRepository.getUser();
  //     if (user != null) {
  //       await _userRepository.saveUser(
  //         user.copyWith(firstName: event.firstName),
  //       );
  //     }
  //     emit(ProfileLoaded(user));
  //   } catch (e) {
  //     emit(ProfileError(e.toString()));
  //   }
  // }

  // Future<void> _onChangeLastName(
  //   ChangeLastName event,
  //   Emitter<ProfileState> emit,
  // ) async {
  //   emit(ProfileLoading());
  //   try {
  //     UserModel? user = await _userRepository.getUser();
  //     if (user != null) {
  //       await _userRepository.saveUser(
  //         user.copyWith(lastName: event.lastName),
  //       );
  //     }
  //     emit(ProfileLoaded(user));
  //   } catch (e) {
  //     emit(ProfileError(e.toString()));
  //   }
  // }

  // Future<void> _onChangeDescription(
  //   ChangeDescription event,
  //   Emitter<ProfileState> emit,
  // ) async {
  //   emit(ProfileLoading());
  //   try {
  //     UserModel? user = await _userRepository.getUser();
  //     if (user != null) {
  //       await _userRepository.saveUser(
  //         user.copyWith(description: event.description),
  //       );
  //     }
  //     emit(ProfileLoaded(user));
  //   } catch (e) {
  //     emit(ProfileError(e.toString()));
  //   }
  // }

  Future<void> _onSaveAvatar(
    SaveAvatar event,
    Emitter<ProfileState> emit,
  ) async {
    // emit(ProfileLoading());
    try {
      final savedAvatar = await _imageRepository.saveAvatar(event.file);
      imageCache.clear();
      imageCache.clearLiveImages();

      final user = await _userRepository.getUser();
      if (user == null) {
        emit(ProfileError('User not found'));
        return;
      }

      final updatedUser = user.copyWith(avatarPath: savedAvatar.path);

      await _userRepository.saveUser(updatedUser);

      emit(ProfileLoaded(updatedUser)); // 🔥 ТОЛЬКО НОВЫЙ ОБЪЕКТ
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
