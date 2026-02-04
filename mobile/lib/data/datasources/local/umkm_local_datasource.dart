import 'package:sqflite/sqflite.dart';
import '../../../core/database/sqlite_service.dart';
import '../../models/umkm_sale_model.dart';
import '../../models/umkm_debt_model.dart';

abstract class UmkmLocalDatasource {
  Future<void> insertSale(UmkmSaleModel sale);
  Future<List<UmkmSaleModel>> getAllSales();
  Future<List<UmkmSaleModel>> getUnsyncedSales();
  Future<void> markSalesAsSynced(List<String> ids);

  Future<void> insertDebt(UmkmDebtModel debt);
  Future<List<UmkmDebtModel>> getAllDebts();
  Future<List<UmkmDebtModel>> getUnsyncedDebts();
  Future<void> markDebtsAsSynced(List<String> ids);
}

class UmkmLocalDatasourceImpl implements UmkmLocalDatasource {
  final SQLiteService _dbService;

  UmkmLocalDatasourceImpl(this._dbService);

  @override
  Future<void> insertSale(UmkmSaleModel sale) async {
    final db = await _dbService.database;
    await db.insert(
      'umkm_sales',
      sale.toSqlite(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<UmkmSaleModel>> getAllSales() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('umkm_sales', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => UmkmSaleModel.fromSqlite(maps[i]));
  }

  @override
  Future<List<UmkmSaleModel>> getUnsyncedSales() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('umkm_sales', where: 'is_synced = 0');
    return List.generate(maps.length, (i) => UmkmSaleModel.fromSqlite(maps[i]));
  }

  @override
  Future<void> markSalesAsSynced(List<String> ids) async {
    final db = await _dbService.database;
    await db.update('umkm_sales', {'is_synced': 1},
        where: 'id IN (${ids.map((e) => "'$e'").join(',')})');
  }

  @override
  Future<void> insertDebt(UmkmDebtModel debt) async {
    final db = await _dbService.database;
    await db.insert(
      'umkm_debts',
      debt.toSqlite(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<UmkmDebtModel>> getAllDebts() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('umkm_debts', orderBy: 'due_date ASC');
    return List.generate(maps.length, (i) => UmkmDebtModel.fromSqlite(maps[i]));
  }

  @override
  Future<List<UmkmDebtModel>> getUnsyncedDebts() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('umkm_debts', where: 'is_synced = 0');
    return List.generate(maps.length, (i) => UmkmDebtModel.fromSqlite(maps[i]));
  }

  @override
  Future<void> markDebtsAsSynced(List<String> ids) async {
    final db = await _dbService.database;
    await db.update('umkm_debts', {'is_synced': 1},
        where: 'id IN (${ids.map((e) => "'$e'").join(',')})');
  }
}
