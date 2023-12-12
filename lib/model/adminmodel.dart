import 'package:hive_flutter/hive_flutter.dart';
part 'adminmodel.g.dart';

@HiveType(typeId: 1)
class AdminData {
  @HiveField(0)
  final String adminName;
  @HiveField(1)
  final String password;

  AdminData({required this.adminName, required this.password});
}
