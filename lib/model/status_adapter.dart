import 'package:hive_flutter/hive_flutter.dart';
part 'status_adapter.g.dart';

@HiveType(typeId: 8)
enum Status {
  @HiveField(0)
  ordered,
  @HiveField(1)
  pickedup,
  @HiveField(2)
  transit,
  @HiveField(3)
  outfordelivery,

  @HiveField(4)
  delivered,
  @HiveField(5)
  cancelled
}
