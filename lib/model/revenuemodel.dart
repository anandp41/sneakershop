import 'package:hive_flutter/hive_flutter.dart';
import 'package:sneaker_shop/model/status_adapter.dart';

part 'revenuemodel.g.dart';

@HiveType(typeId: 7)
class RevenueData extends HiveObject {
  @HiveField(0)
  final String email;
  @HiveField(1)
  final int sneakerId;
  @HiveField(2)
  final int number;
  @HiveField(3)
  final double amount;
  @HiveField(4)
  int? transactionId;
  @HiveField(5)
  final DateTime dateTime;
  @HiveField(6)
  final int size;
  @HiveField(7)
  Status orderStatus;
  RevenueData(
      {required this.size,
      required this.amount,
      required this.dateTime,
      required this.email,
      required this.sneakerId,
      required this.number,
      this.transactionId,
      this.orderStatus = Status.ordered});
}
