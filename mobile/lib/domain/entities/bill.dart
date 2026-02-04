class Bill {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final DateTime dueDate;
  final String? repeatCycle;
  final String status;

  Bill({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.dueDate,
    this.repeatCycle,
    required this.status,
  });
}
