// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenuemodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RevenueDataAdapter extends TypeAdapter<RevenueData> {
  @override
  final int typeId = 7;

  @override
  RevenueData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RevenueData(
      size: fields[6] as int,
      amount: fields[3] as double,
      dateTime: fields[5] as DateTime,
      email: fields[0] as String,
      sneakerId: fields[1] as int,
      number: fields[2] as int,
      transactionId: fields[4] as int?,
      orderStatus: fields[7] as Status,
    );
  }

  @override
  void write(BinaryWriter writer, RevenueData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.sneakerId)
      ..writeByte(2)
      ..write(obj.number)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.transactionId)
      ..writeByte(5)
      ..write(obj.dateTime)
      ..writeByte(6)
      ..write(obj.size)
      ..writeByte(7)
      ..write(obj.orderStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RevenueDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
