import 'package:sneaker_shop/model/status_adapter.dart';

class RevenueData {
  final String email;

  final String sneakerId;

  final int number;

  final double amount;

  final String transactionId;

  final DateTime dateTime;

  final int size;

  Status orderStatus;
  RevenueData(
      {required this.size,
      required this.amount,
      required this.dateTime,
      required this.email,
      required this.sneakerId,
      required this.number,
      required this.transactionId,
      this.orderStatus = Status.ordered});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'sneakerId': sneakerId,
      'number': number,
      'amount': amount,
      'transactionId': transactionId,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'size': size,
      'orderStatus': orderStatus.toMap(),
    };
  }

  factory RevenueData.fromMap(Map<String, dynamic> map) {
    return RevenueData(
      email: map['email'] ?? '',
      sneakerId: map['sneakerId'] ?? '',
      number: map['number']?.toInt() ?? 0,
      amount: map['amount']?.toDouble() ?? 0.0,
      transactionId: map['transactionId'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      size: map['size']?.toInt() ?? 0,
      orderStatus: StatusExtension.fromMap(map['orderStatus']),
    );
  }
}
