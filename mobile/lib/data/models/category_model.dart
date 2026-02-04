import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  final bool isSynced;
  final DateTime updatedAt;

  CategoryModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.type,
    this.isSynced = false,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      type: json['type'],
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
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory CategoryModel.fromSqlite(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      type: map['type'],
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
      'is_synced': isSynced ? 1 : 0,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
