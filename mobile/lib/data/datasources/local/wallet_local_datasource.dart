import 'package:sqflite/sqflite.dart';
import '../../../../core/database/sqlite_service.dart';
import '../../models/wallet_model.dart';

abstract class WalletLocalDatasource {
  Future<void> insertWallet(WalletModel wallet);
  Future<List<WalletModel>> getUnsynced();
  Future<void> markAsSynced(List<String> ids);
  Future<List<WalletModel>> getAllWallets();
  Future<void> updateWallet(WalletModel wallet);
}

class WalletLocalDatasourceImpl implements WalletLocalDatasource {
  final SQLiteService _dbService;

  WalletLocalDatasourceImpl(this._dbService);

  @override
  Future<void> insertWallet(WalletModel wallet) async {
    final db = await _dbService.database;
    await db.insert(
      'wallets',
      wallet.toSqlite(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<WalletModel>> getUnsynced() async {
    final db = await _dbService.database;
    final result = await db.query(
      'wallets',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    return result.map((e) => WalletModel.fromSqlite(e)).toList();
  }

  @override
  Future<void> markAsSynced(List<String> ids) async {
    final db = await _dbService.database;
    final batch = db.batch();
    for (final id in ids) {
      batch.update(
        'wallets',
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<WalletModel>> getAllWallets() async {
    final db = await _dbService.database;
    final result = await db.query('wallets');
    return result.map((e) => WalletModel.fromSqlite(e)).toList();
  }

  @override
  Future<void> updateWallet(WalletModel wallet) async {
    final db = await _dbService.database;
    final map = wallet.toSqlite();
    map['is_synced'] = 0;

    await db.update(
      'wallets',
      map,
      where: 'id = ?',
      whereArgs: [wallet.id],
    );
  }
}
