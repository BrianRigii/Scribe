// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      $id: fields[0] as String,
      $createdAt: fields[1] as String,
      $updatedAt: fields[2] as String,
      name: fields[3] as String,
      password: fields[4] as String?,
      hash: fields[5] as String?,
      hashOptions: (fields[6] as Map?)?.cast<dynamic, dynamic>(),
      registration: fields[7] as String,
      status: fields[8] as bool,
      labels: (fields[9] as List).cast<String>(),
      passwordUpdate: fields[10] as String,
      email: fields[11] as String,
      phone: fields[12] as String,
      emailVerification: fields[13] as bool,
      phoneVerification: fields[14] as bool,
      mfa: fields[15] as bool,
      prefs: fields[16] as Preferences,
      targets: (fields[17] as List).cast<Target>(),
      accessedAt: fields[18] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.$id)
      ..writeByte(1)
      ..write(obj.$createdAt)
      ..writeByte(2)
      ..write(obj.$updatedAt)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.hash)
      ..writeByte(6)
      ..write(obj.hashOptions)
      ..writeByte(7)
      ..write(obj.registration)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.labels)
      ..writeByte(10)
      ..write(obj.passwordUpdate)
      ..writeByte(11)
      ..write(obj.email)
      ..writeByte(12)
      ..write(obj.phone)
      ..writeByte(13)
      ..write(obj.emailVerification)
      ..writeByte(14)
      ..write(obj.phoneVerification)
      ..writeByte(15)
      ..write(obj.mfa)
      ..writeByte(16)
      ..write(obj.prefs)
      ..writeByte(17)
      ..write(obj.targets)
      ..writeByte(18)
      ..write(obj.accessedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
