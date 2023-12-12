// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatusAdapter extends TypeAdapter<Status> {
  @override
  final int typeId = 8;

  @override
  Status read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Status.ordered;
      case 1:
        return Status.pickedup;
      case 2:
        return Status.transit;
      case 3:
        return Status.outfordelivery;
      case 4:
        return Status.delivered;
      case 5:
        return Status.cancelled;
      default:
        return Status.ordered;
    }
  }

  @override
  void write(BinaryWriter writer, Status obj) {
    switch (obj) {
      case Status.ordered:
        writer.writeByte(0);
        break;
      case Status.pickedup:
        writer.writeByte(1);
        break;
      case Status.transit:
        writer.writeByte(2);
        break;
      case Status.outfordelivery:
        writer.writeByte(3);
        break;
      case Status.delivered:
        writer.writeByte(4);
        break;
      case Status.cancelled:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
