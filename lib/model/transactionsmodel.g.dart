// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactionsmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionDataAdapter extends TypeAdapter<TransactionData> {
  @override
  final int typeId = 4;

  @override
  TransactionData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionData(
      transactionId: fields[0] as String,
      username: fields[1] as String,
      amount: fields[2] as double,
      shoeId: fields[3] as String,
      sizeAndCount: (fields[4] as Map).cast<double, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.transactionId)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.shoeId)
      ..writeByte(4)
      ..write(obj.sizeAndCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
