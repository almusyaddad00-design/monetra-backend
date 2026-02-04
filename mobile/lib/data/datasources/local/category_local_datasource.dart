import 'package:sqflite/sqflite.dart';
import '../../../../core/database/sqlite_service.dart';
import '../../models/category_model.dart';

abstract class CategoryLocalDatasource {
  Future<void> insertCategory(CategoryModel category);
  Future<List<CategoryModel>> getUnsynced();
  Future<void> markAsSynced(List<String> ids);
  Future<List<CategoryModel>> getAllCategories();
  Future<void> updateCategory(CategoryModel category);
}

class CategoryLocalDatasourceImpl implements CategoryLocalDatasource {
  final SQLiteService _dbService;

  CategoryLocalDatasourceImpl(this._dbService);

  @override
  Future<void> insertCategory(CategoryModel category) async {
    final db = await _dbService.database;
    await db.insert(
      'categories',
      category.toSqlite(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<CategoryModel>> getUnsynced() async {
    final db = await _dbService.database;
    final result = await db.query(
      'categories',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    return result.map((e) => CategoryModel.fromSqlite(e)).toList();
  }

  @override
  Future<void> markAsSynced(List<String> ids) async {
    final db = await _dbService.database;
    final batch = db.batch();
    for (final id in ids) {
      batch.update(
        'categories',
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final db = await _dbService.database;
    final result = await db.query('categories');
    return result.map((e) => CategoryModel.fromSqlite(e)).toList();
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    final db = await _dbService.database;
    final map = category.toSqlite();
    map['is_synced'] = 0; // Mark as unsynced on update

    await db.update(
      'categories',
      map,
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }
}
