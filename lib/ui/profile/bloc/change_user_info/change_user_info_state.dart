import 'dart:io';

import 'package:equatable/equatable.dart';

class ChangeUserInfoState extends Equatable {
  const ChangeUserInfoState({
    this.firstName = '',
    this.lastName = '',
    this.description = '',
    this.avatarPath,
  });

  final String firstName;
  final String lastName;
  final String description;
  final String? avatarPath;

  ChangeUserInfoState copyWith({
    String? firstName,
    String? lastName, 
    String? description,
    String? avatarPath,
  }) {
    return ChangeUserInfoState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      description: description ?? this.description,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  @override
  List<Object?> get props => [firstName, lastName, description, avatarPath];
}
