// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shoemodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShoeModelAdapter extends TypeAdapter<ShoeModel> {
  @override
  final int typeId = 3;

  @override
  ShoeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoeModel(
      shoeId: fields[0] as int?,
      name: fields[1] as String,
      imagePath: (fields[2] as List).cast<String>(),
      price: fields[3] as double,
      brand: fields[4] as String,
      availableSizesandStock: (fields[5] as List)
          .map((dynamic e) => (e as Map).cast<String, int>())
          .toList(),
      isNew: fields[6] as bool,
      description: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ShoeModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.shoeId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.brand)
      ..writeByte(5)
      ..write(obj.availableSizesandStock)
      ..writeByte(6)
      ..write(obj.isNew)
      ..writeByte(7)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
