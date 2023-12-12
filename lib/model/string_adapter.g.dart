// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StringAdapterAdapter extends TypeAdapter<StringAdapter> {
  @override
  final int typeId = 6;

  @override
  StringAdapter read(BinaryReader reader) {
    return StringAdapter();
  }

  @override
  void write(BinaryWriter writer, StringAdapter obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StringAdapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
