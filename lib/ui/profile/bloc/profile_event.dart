import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class LogOut extends ProfileEvent {}

class SaveProfile extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String description;
  final String region;

  final String? avatarPath;

  const SaveProfile({
    required this.firstName,
    required this.lastName,
    required this.description,
    this.region = '',
    this.avatarPath,
  });

  @override
  List<Object> get props => [firstName, lastName, description, region];
}

class SaveAvatar extends ProfileEvent {
  final File file;

  const SaveAvatar(this.file);

  @override
  List<Object> get props => [file];
}

/// Uploads (or replaces) the avatar via the dedicated `/api/profile/avatar`
/// endpoint. `filePath` is the raw picked image; compression happens in
/// the bloc before upload. `bytes` is the same image already read into
/// memory — `flutter_image_compress` can't read a picked file by path on
/// web (blob: URLs), so the bloc falls back to compressing `bytes` there.
class UploadAvatarRequested extends ProfileEvent {
  final String filePath;
  final Uint8List bytes;

  const UploadAvatarRequested(this.filePath, this.bytes);

  @override
  List<Object> get props => [filePath];
}

class DeleteAvatarRequested extends ProfileEvent {}

// class ChangeFirstName extends ProfileEvent {
//   final String firstName;

//   const ChangeFirstName({required this.firstName});

//   @override
//   List<Object> get props => [firstName];
// }

// class ChangeLastName extends ProfileEvent {
//   final String lastName;

//   const ChangeLastName({required this.lastName});

//   @override
//   List<Object> get props => [lastName];
// }

// class ChangeDescription extends ProfileEvent {
//   final String description;

//   const ChangeDescription({required this.description});

//   @override
//   List<Object> get props => [description];
// }
