import '../../domain/entities/wallet.dart';

class WalletModel extends Wallet {
  final bool isSynced;
  final DateTime updatedAt;

  WalletModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.name,
    required super.balance,
    this.isSynced = false,
    required this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      name: json['name'],
      balance: (json['balance'] as num).toDouble(),
      isSynced: true,
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'name': name,
      'balance': balance,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory WalletModel.fromSqlite(Map<String, dynamic> map) {
    return WalletModel(
      id: map['id'],
      userId: map['user_id'],
      type: map['type'],
      name: map['name'],
      balance: (map['balance'] as num).toDouble(),
      isSynced: map['is_synced'] == 1,
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toSqlite() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'name': name,
      'balance': balance,
      'is_synced': isSynced ? 1 : 0,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
