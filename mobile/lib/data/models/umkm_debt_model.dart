import '../../domain/entities/umkm_debt.dart';

class UmkmDebtModel extends UmkmDebt {
  UmkmDebtModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.type,
    required super.amount,
    required super.dueDate,
    super.isPaid,
    super.isSynced,
    required super.updatedAt,
  });

  factory UmkmDebtModel.fromJson(Map<String, dynamic> json) {
    return UmkmDebtModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      type: json['type'],
      amount: double.parse(json['amount'].toString()),
      dueDate: DateTime.parse(json['due_date']),
      isPaid: json['is_paid'] == 1 || json['is_paid'] == true,
      isSynced: true,
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'type': type,
      'amount': amount,
      'due_date': dueDate.toIso8601String(),
      'is_paid': isPaid,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UmkmDebtModel.fromSqlite(Map<String, dynamic> map) {
    return UmkmDebtModel(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      type: map['type'],
      amount: double.parse(map['amount'].toString()),
      dueDate: DateTime.parse(map['due_date']),
      isPaid: map['is_paid'] == 1,
      isSynced: map['is_synced'] == 1,
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toSqlite() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'type': type,
      'amount': amount,
      'due_date': dueDate.toIso8601String(),
      'is_paid': isPaid ? 1 : 0,
      'is_synced': isSynced ? 1 : 0,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
