import 'package:monetra/data/datasources/local/transaction_local_datasource.dart';
import 'package:monetra/data/datasources/remote/sync_remote_datasource.dart';
import 'package:monetra/data/models/transaction_model.dart';
import 'package:monetra/data/datasources/local/wallet_local_datasource.dart';
import 'package:monetra/data/models/wallet_model.dart';
import 'package:monetra/data/datasources/local/bill_local_datasource.dart';
import 'package:monetra/data/models/bill_model.dart';
import 'package:monetra/data/datasources/local/umkm_local_datasource.dart';
import 'package:monetra/data/datasources/local/category_local_datasource.dart';
import 'package:monetra/data/models/umkm_sale_model.dart';
import 'package:monetra/data/models/umkm_debt_model.dart';
import 'package:monetra/data/models/category_model.dart';
import 'package:monetra/core/utils/shared_prefs_service.dart';

class SyncRepositoryImpl {
  final TransactionLocalDatasource _transactionLocalDatasource;
  final WalletLocalDatasource _walletLocalDatasource;
  final BillLocalDatasource _billLocalDatasource;
  final UmkmLocalDatasource _umkmLocalDatasource;
  final CategoryLocalDatasource _categoryLocalDatasource;
  final SyncRemoteDatasource _syncRemoteDatasource;
  final SharedPrefsService _sharedPrefsService;

  SyncRepositoryImpl(
    this._transactionLocalDatasource,
    this._walletLocalDatasource,
    this._billLocalDatasource,
    this._umkmLocalDatasource,
    this._categoryLocalDatasource,
    this._syncRemoteDatasource,
    this._sharedPrefsService,
  );

  Future<void> syncData() async {
    await _push();
    await _pull();
  }

  Future<void> _push() async {
    // 1. Gather Unsynced
    final transactions = await _transactionLocalDatasource.getUnsynced();
    final wallets = await _walletLocalDatasource.getUnsynced();
    final categories = await _categoryLocalDatasource.getUnsynced();
    final bills = await _billLocalDatasource.getUnsynced();
    final sales = await _umkmLocalDatasource.getUnsyncedSales();
    final debts = await _umkmLocalDatasource.getUnsyncedDebts();

    if (transactions.isEmpty &&
        wallets.isEmpty &&
        categories.isEmpty &&
        bills.isEmpty &&
        sales.isEmpty &&
        debts.isEmpty) {
      return;
    }

    final dataToPush = {
      'transactions': transactions.map((e) => e.toJson()).toList(),
      'wallets': wallets.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
      'bills': bills.map((e) => e.toJson()).toList(),
      'umkm_sales': sales.map((e) => e.toJson()).toList(),
      'umkm_debts': debts.map((e) => e.toJson()).toList(),
    };

    // 2. Push to Server
    await _syncRemoteDatasource.pushSync(dataToPush);

    // 3. Mark as Synced
    if (transactions.isNotEmpty) {
      await _transactionLocalDatasource.markAsSynced(
        transactions.map((e) => e.id).toList(),
      );
    }
    if (wallets.isNotEmpty) {
      await _walletLocalDatasource.markAsSynced(
        wallets.map((e) => e.id).toList(),
      );
    }
    if (categories.isNotEmpty) {
      await _categoryLocalDatasource.markAsSynced(
        categories.map((e) => e.id).toList(),
      );
    }
    if (bills.isNotEmpty) {
      await _billLocalDatasource.markAsSynced(
        bills.map((e) => e.id).toList(),
      );
    }
    if (sales.isNotEmpty) {
      await _umkmLocalDatasource.markSalesAsSynced(
        sales.map((e) => e.id).toList(),
      );
    }
    if (debts.isNotEmpty) {
      await _umkmLocalDatasource.markDebtsAsSynced(
        debts.map((e) => e.id).toList(),
      );
    }
  }

  Future<void> _pull() async {
    // 1. Get Last Sync Time
    String? lastSyncTime = _sharedPrefsService.getLastSyncTime();

    // 2. Fetch from Server
    final data = await _syncRemoteDatasource.pullSync(lastSyncTime);

    // 3. Update Local
    if (data['wallets'] != null) {
      final list = data['wallets'] as List;
      for (var item in list) {
        final w = WalletModel.fromJson(item);
        // Insert (or update) wallet. Since mapped from JSON, isSynced=true.
        await _walletLocalDatasource.insertWallet(w);
      }
    }

    if (data['transactions'] != null) {
      final list = data['transactions'] as List;
      for (var item in list) {
        final t = TransactionModel.fromJson(item);
        await _transactionLocalDatasource.insertTransaction(t);
        await _transactionLocalDatasource.markAsSynced([t.id]);
      }
    }

    if (data['bills'] != null) {
      final list = data['bills'] as List;
      for (var item in list) {
        final b = BillModel.fromJson(item);
        await _billLocalDatasource.insertBill(b);
        await _billLocalDatasource.markAsSynced([b.id]);
      }
    }

    if (data['categories'] != null) {
      final list = data['categories'] as List;
      for (var item in list) {
        final c = CategoryModel.fromJson(item);
        await _categoryLocalDatasource.insertCategory(c);
        await _categoryLocalDatasource.markAsSynced([c.id]);
      }
    }

    if (data['umkm_sales'] != null) {
      final list = data['umkm_sales'] as List;
      for (var item in list) {
        final s = UmkmSaleModel.fromJson(item);
        await _umkmLocalDatasource.insertSale(s);
        await _umkmLocalDatasource.markSalesAsSynced([s.id]);
      }
    }

    if (data['umkm_debts'] != null) {
      final list = data['umkm_debts'] as List;
      for (var item in list) {
        final d = UmkmDebtModel.fromJson(item);
        await _umkmLocalDatasource.insertDebt(d);
        await _umkmLocalDatasource.markDebtsAsSynced([d.id]);
      }
    }

    // 4. Update last sync time
    if (data['server_time'] != null) {
      await _sharedPrefsService
          .saveLastSyncTime(data['server_time'].toString());
    }
  }
}
