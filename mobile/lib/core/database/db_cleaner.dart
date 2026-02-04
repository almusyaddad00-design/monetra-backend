import '../database/sqlite_service.dart';
import '../../core/utils/shared_prefs_service.dart';

class DBCleaner {
  static Future<void> cleanLocalData(
      SQLiteService sqliteService, SharedPrefsService sharedPrefs) async {
    final db = await sqliteService.database;

    await db.transaction((txn) async {
      await txn.delete('transactions');
      await txn.delete('wallets');
      await txn.delete('categories');
      await txn.delete('bills');
      await txn.delete('umkm_sales');
      await txn.delete('umkm_debts');
      await txn.delete('sync_logs');
    });

    // Reset last sync time so new user gets fresh pull
    await sharedPrefs.clearAll();
  }
}
