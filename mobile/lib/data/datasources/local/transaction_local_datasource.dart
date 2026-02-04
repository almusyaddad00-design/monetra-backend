import 'package:sqflite/sqflite.dart';
import '../../../../core/database/sqlite_service.dart';
import '../../models/transaction_model.dart';

abstract class TransactionLocalDatasource {
  Future<void> insertTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getUnsynced();
  Future<void> markAsSynced(List<String> ids);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getAllTransactions();
}

class TransactionLocalDatasourceImpl implements TransactionLocalDatasource {
  final SQLiteService _dbService;

  TransactionLocalDatasourceImpl(this._dbService);

  @override
  Future<void> insertTransaction(TransactionModel transaction) async {
    final db = await _dbService.database;
    await db.insert(
      'transactions',
      transaction.toSqlite(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // Log sync action if needed, or handle in repository
  }

  @override
  Future<List<TransactionModel>> getUnsynced() async {
    final db = await _dbService.database;
    final result = await db.query(
      'transactions',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    return result.map((e) => TransactionModel.fromSqlite(e)).toList();
  }

  @override
  Future<void> markAsSynced(List<String> ids) async {
    final db = await _dbService.database;
    final batch = db.batch();
    for (final id in ids) {
      batch.update(
        'transactions',
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await _dbService.database;
    final result = await db.query('transactions', orderBy: 'date DESC');
    return result.map((e) => TransactionModel.fromSqlite(e)).toList();
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    final db = await _dbService.database;
    // When updating locally, mark as unsynced
    final map = transaction.toSqlite();
    map['is_synced'] = 0;

    await db.update(
      'transactions',
      map,
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }
}
