import 'package:hive_flutter/hive_flutter.dart';
part 'string_adapter.g.dart';

@HiveType(typeId: 6)
class StringAdapter extends TypeAdapter<String> {
  @override
  final int typeId = 6;
  @override
  String read(BinaryReader reader) {
    return reader.readString();
  }

  @override
  void write(BinaryWriter writer, String obj) {
    writer.writeString(obj);
  }
}
