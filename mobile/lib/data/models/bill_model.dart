import '../../domain/entities/bill.dart';

class BillModel extends Bill {
  final bool isSynced;
  final DateTime updatedAt;

  BillModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.amount,
    required super.dueDate,
    super.repeatCycle,
    required super.status,
    this.isSynced = false,
    required this.updatedAt,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['due_date']),
      repeatCycle: json['repeat_cycle'],
      status: json['status'],
      isSynced: true,
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'amount': amount,
      'due_date': dueDate.toIso8601String(),
      'repeat_cycle': repeatCycle,
      'status': status,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BillModel.fromSqlite(Map<String, dynamic> map) {
    return BillModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      dueDate: DateTime.parse(map['due_date']),
      repeatCycle: map['repeat_cycle'],
      status: map['status'],
      isSynced: map['is_synced'] == 1,
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toSqlite() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'amount': amount,
      'due_date': dueDate.toIso8601String(),
      'repeat_cycle': repeatCycle,
      'status': status,
      'is_synced': isSynced ? 1 : 0,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
