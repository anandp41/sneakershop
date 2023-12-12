// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usermodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 5;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      name: fields[0] as String,
      email: fields[1] as String,
      phoneno: fields[2] as String,
      address: fields[3] as String,
      password: fields[4] as String,
      imagePath: fields[5] as String?,
      cart: (fields[6] as List)
          .map((dynamic e) => (e as Map).cast<String, int>())
          .toList(),
      orderHistory: (fields[7] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      favList: (fields[8] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.phoneno)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.cart)
      ..writeByte(7)
      ..write(obj.orderHistory)
      ..writeByte(8)
      ..write(obj.favList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
