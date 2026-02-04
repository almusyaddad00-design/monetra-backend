import 'package:monetra/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required super.id,
    required super.userId,
    required super.walletId,
    super.categoryId,
    required super.type,
    required super.amount,
    required super.date,
    super.note,
    super.isSynced,
    required super.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      walletId: json['wallet_id'],
      categoryId: json['category_id'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      note: json['note'],
      // API might not send is_synced, default to true if coming from API, but context matters.
      // Usually used for pulling.
      isSynced: true,
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'wallet_id': walletId,
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromSqlite(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      userId: map['user_id'],
      walletId: map['wallet_id'],
      categoryId: map['category_id'],
      type: map['type'],
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      note: map['note'],
      isSynced: map['is_synced'] == 1,
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toSqlite() {
    return {
      'id': id,
      'user_id': userId,
      'wallet_id': walletId,
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
      'is_synced': isSynced ? 1 : 0,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
