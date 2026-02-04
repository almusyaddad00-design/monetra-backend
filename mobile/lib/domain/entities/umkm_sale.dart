class UmkmSale {
  final String id;
  final String userId;
  final String customerName;
  final double amount;
  final DateTime date;
  final bool isSynced;
  final DateTime updatedAt;

  UmkmSale({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.amount,
    required this.date,
    this.isSynced = false,
    required this.updatedAt,
  });
}
