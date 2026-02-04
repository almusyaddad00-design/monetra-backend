import '../../domain/entities/umkm_sale.dart';

class UmkmSaleModel extends UmkmSale {
  UmkmSaleModel({
    required super.id,
    required super.userId,
    required super.customerName,
    required super.amount,
    required super.date,
    super.isSynced,
    required super.updatedAt,
  });

  factory UmkmSaleModel.fromJson(Map<String, dynamic> json) {
    return UmkmSaleModel(
      id: json['id'],
      userId: json['user_id'],
      customerName: json['customer_name'],
      amount: double.parse(json['amount'].toString()),
      date: DateTime.parse(json['date']),
      isSynced: true,
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'customer_name': customerName,
      'amount': amount,
      'date': date.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UmkmSaleModel.fromSqlite(Map<String, dynamic> map) {
    return UmkmSaleModel(
      id: map['id'],
      userId: map['user_id'],
      customerName: map['customer_name'],
      amount: double.parse(map['amount'].toString()),
      date: DateTime.parse(map['date']),
      isSynced: map['is_synced'] == 1,
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toSqlite() {
    return {
      'id': id,
      'user_id': userId,
      'customer_name': customerName,
      'amount': amount,
      'date': date.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
