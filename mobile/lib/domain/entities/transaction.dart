class Transaction {
  final String id;
  final String userId;
  final String walletId;
  final String? categoryId;
  final String type;
  final double amount;
  final DateTime date;
  final String? note;
  final bool isSynced;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.walletId,
    this.categoryId,
    required this.type,
    required this.amount,
    required this.date,
    this.note,
    this.isSynced = false,
    required this.updatedAt,
  });
}
