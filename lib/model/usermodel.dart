import 'package:hive_flutter/hive_flutter.dart';

part 'usermodel.g.dart';

@HiveType(typeId: 5)
class UserData extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String phoneno;
  @HiveField(3)
  final String address;
  @HiveField(4)
  final String password;
  @HiveField(5)
  final String? imagePath;
  @HiveField(6)
  final List<Map<String, int>> cart;
  @HiveField(7)
  final List<Map<String, dynamic>> orderHistory;
  @HiveField(8)
  List<int> favList;
  UserData(
      {required this.name,
      required this.email,
      required this.phoneno,
      required this.address,
      required this.password,
      this.imagePath,
      this.cart = const [],
      this.orderHistory = const [],
      this.favList = const []});
}
