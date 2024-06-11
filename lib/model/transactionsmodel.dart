class TransactionData {
  final String transactionId;

  final String username;

  final double amount;

  final String shoeId;

  final Map<double, int> sizeAndCount;
  TransactionData(
      {required this.transactionId,
      required this.username,
      required this.amount,
      required this.shoeId,
      required this.sizeAndCount});
}
