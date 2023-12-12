import 'package:hive_flutter/hive_flutter.dart';
part 'shoemodel.g.dart';

@HiveType(typeId: 3)
class ShoeModel extends HiveObject {
  @HiveField(0)
  int? shoeId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  List<String> imagePath;
  @HiveField(3)
  final double price;

  @HiveField(4)
  final String brand;
  @HiveField(5)
  final List<Map<String, int>> availableSizesandStock;
  @HiveField(6)
  final bool isNew;
  @HiveField(7)
  String? description;
  ShoeModel(
      {this.shoeId,
      required this.name,
      this.imagePath = const [],
      required this.price,
      required this.brand,
      required this.availableSizesandStock,
      required this.isNew,
      this.description});
}
