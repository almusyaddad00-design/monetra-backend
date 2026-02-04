import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SQLiteService {
  static final SQLiteService instance = SQLiteService._init();
  static Database? _database;

  SQLiteService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('monetra.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      await sqfliteFfiWebLoadSqlite3Wasm(SqfliteFfiWebOptions());
      databaseFactory = databaseFactoryFfiWebNoWebWorker;
      return await openDatabase(
        filePath,
        version: 1,
        onCreate: _createDB,
      );
    }

    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const textNullable = 'TEXT';
    const boolType = 'INTEGER NOT NULL DEFAULT 0'; // 0 = false, 1 = true
    const realType = 'REAL NOT NULL';

    // Users
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        name $textType,
        email $textType,
        pin $textNullable,
        created_at $textType,
        updated_at $textType
      )
    ''');

    // Wallets
    await db.execute('''
      CREATE TABLE wallets (
        id $idType,
        user_id $textType,
        type $textType,
        name $textType,
        balance $realType,
        is_synced $boolType,
        updated_at $textType
      )
    ''');

    // Categories
    await db.execute('''
      CREATE TABLE categories (
        id $idType,
        user_id $textType,
        name $textType,
        type $textType,
        is_synced $boolType,
        updated_at $textType
      )
    ''');

    // Transactions
    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        user_id $textType,
        wallet_id $textType,
        category_id $textNullable,
        type $textType,
        amount $realType,
        date $textType,
        note $textNullable,
        is_synced $boolType,
        updated_at $textType
      )
    ''');

    // Bills
    await db.execute('''
      CREATE TABLE bills (
        id $idType,
        user_id $textType,
        title $textType,
        amount $realType,
        due_date $textType,
        repeat_cycle $textNullable,
        status $textType,
        is_synced $boolType,
        updated_at $textType
      )
    ''');

    // Sync Logs
    await db.execute('''
      CREATE TABLE sync_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_name $textType,
        record_id $textType,
        action $textType,
        timestamp $textType
      )
    ''');

    // UMKM Penjualan
    await db.execute('''
      CREATE TABLE umkm_sales (
        id $idType,
        user_id $textType,
        customer_name $textType,
        amount $realType,
        date $textType,
        is_synced $boolType,
        updated_at $textType
      )
    ''');

    // UMKM Hutang Piutang
    await db.execute('''
      CREATE TABLE umkm_debts (
        id $idType,
        user_id $textType,
        name $textType,
        type $textType,
        amount $realType,
        due_date $textType,
        is_paid $boolType,
        is_synced $boolType,
        updated_at $textType
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
