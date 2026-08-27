// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      firstName: fields[0] as String,
      lastName: fields[1] as String,
      region: fields[2] as String,
      description: fields[3] as String,
      regionId: fields[5] as int?,
      avatarPath: fields[4] as String?,
      totalScore: fields[6] as int?,
      completedTests: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.region)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.avatarPath)
      ..writeByte(5)
      ..write(obj.regionId)
      ..writeByte(6)
      ..write(obj.totalScore)
      ..writeByte(7)
      ..write(obj.completedTests);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
