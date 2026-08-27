import 'dart:io';

import 'package:equatable/equatable.dart';

class ChangeUserInfoEvent extends Equatable {
  const ChangeUserInfoEvent();

  @override
  List<Object?> get props => [];
}

  class ChangeFirstName extends ChangeUserInfoEvent {
    final String firstName;

    const ChangeFirstName({required this.firstName});

    @override
    List<Object?> get props => [firstName];
  }

  class ChangeLastName extends ChangeUserInfoEvent {
    final String lastName;

    const ChangeLastName({required this.lastName});

    @override
    List<Object?> get props => [lastName];
  }

  class ChangeDescription extends ChangeUserInfoEvent {
    final String description;

    const ChangeDescription({required this.description});

    @override
    List<Object?> get props => [description];
  }
  class ChangeAvatar extends ChangeUserInfoEvent {
    final String path;
    const ChangeAvatar({required this.path});

    @override
    List<Object?> get props => [path];
  }
    