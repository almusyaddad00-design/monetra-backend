import 'package:sqflite/sqflite.dart';
import '../../../../core/database/sqlite_service.dart';
import '../../models/bill_model.dart';

abstract class BillLocalDatasource {
  Future<void> insertBill(BillModel bill);
  Future<List<BillModel>> getUnsynced();
  Future<void> markAsSynced(List<String> ids);
  Future<List<BillModel>> getAllBills();
  Future<void> updateBill(BillModel bill);
}

class BillLocalDatasourceImpl implements BillLocalDatasource {
  final SQLiteService _dbService;

  BillLocalDatasourceImpl(this._dbService);

  @override
  Future<void> insertBill(BillModel bill) async {
    final db = await _dbService.database;
    await db.insert(
      'bills',
      bill.toSqlite(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<BillModel>> getUnsynced() async {
    final db = await _dbService.database;
    final result = await db.query(
      'bills',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    return result.map((e) => BillModel.fromSqlite(e)).toList();
  }

  @override
  Future<void> markAsSynced(List<String> ids) async {
    final db = await _dbService.database;
    final batch = db.batch();
    for (final id in ids) {
      batch.update(
        'bills',
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<BillModel>> getAllBills() async {
    final db = await _dbService.database;
    final result = await db.query('bills');
    return result.map((e) => BillModel.fromSqlite(e)).toList();
  }

  @override
  Future<void> updateBill(BillModel bill) async {
    final db = await _dbService.database;
    final map = bill.toSqlite();
    map['is_synced'] = 0;

    await db.update(
      'bills',
      map,
      where: 'id = ?',
      whereArgs: [bill.id],
    );
  }
}
