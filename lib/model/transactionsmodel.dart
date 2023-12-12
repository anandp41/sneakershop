import 'package:hive_flutter/hive_flutter.dart';
part 'transactionsmodel.g.dart';

@HiveType(typeId: 4)
class TransactionData {
  @HiveField(0)
  final String transactionId;
  @HiveField(1)
  final String username;

  @HiveField(2)
  final double amount;
  @HiveField(3)
  final String shoeId;
  @HiveField(4)
  final Map<double, int> sizeAndCount;
  TransactionData(
      {required this.transactionId,
      required this.username,
      required this.amount,
      required this.shoeId,
      required this.sizeAndCount});
}
