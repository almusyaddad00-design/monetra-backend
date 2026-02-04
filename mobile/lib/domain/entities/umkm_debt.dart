class UmkmDebt {
  final String id;
  final String userId;
  final String name;
  final String type; // hutang, piutang
  final double amount;
  final DateTime dueDate;
  final bool isPaid;
  final bool isSynced;
  final DateTime updatedAt;

  UmkmDebt({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
    this.isSynced = false,
    required this.updatedAt,
  });
}
