import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/sqlite_service.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/local/transaction_local_datasource.dart';
import '../../data/datasources/remote/sync_remote_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../data/datasources/local/wallet_local_datasource.dart';
import '../../data/datasources/local/category_local_datasource.dart';
import '../../data/datasources/local/bill_local_datasource.dart';
import '../../data/repositories/sync_repository_impl.dart';
import '../../data/datasources/local/umkm_local_datasource.dart';
import '../../data/repositories/umkm_repository_impl.dart';
import '../../core/utils/shared_prefs_service.dart';
import '../../core/network/api_interceptor.dart';
import '../../data/repositories/bill_repository_impl.dart';

// Core
final sharedPrefsServiceProvider = Provider<SharedPrefsService>((ref) {
  throw UnimplementedError('SharedPrefsService must be overridden in main');
});
final sqliteServiceProvider = Provider((ref) => SQLiteService.instance);
final dioClientProvider = Provider((ref) {
  final dioClient = DioClient();
  dioClient.dio.interceptors.add(ref.watch(apiInterceptorProvider));
  return dioClient;
});
final apiInterceptorProvider = Provider((ref) {
  return ApiInterceptor(ref.watch(sharedPrefsServiceProvider));
});

// Datasources
final authRemoteDatasourceProvider = Provider((ref) {
  return AuthRemoteDatasourceImpl(
      ref.watch(dioClientProvider), ref.watch(sharedPrefsServiceProvider));
});

final transactionLocalDatasourceProvider = Provider((ref) {
  final dbService = ref.watch(sqliteServiceProvider);
  return TransactionLocalDatasourceImpl(dbService);
});

final walletLocalDatasourceProvider = Provider((ref) {
  final dbService = ref.watch(sqliteServiceProvider);
  return WalletLocalDatasourceImpl(dbService);
});

final categoryLocalDatasourceProvider = Provider((ref) {
  final dbService = ref.watch(sqliteServiceProvider);
  return CategoryLocalDatasourceImpl(dbService);
});

final billLocalDatasourceProvider = Provider((ref) {
  final dbService = ref.watch(sqliteServiceProvider);
  return BillLocalDatasourceImpl(dbService);
});

final umkmLocalDatasourceProvider = Provider((ref) {
  final dbService = ref.watch(sqliteServiceProvider);
  return UmkmLocalDatasourceImpl(dbService);
});

final syncRemoteDatasourceProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SyncRemoteDatasourceImpl(dioClient);
});

// Repositories
final authRepositoryProvider = Provider((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDatasourceProvider),
      ref.watch(sharedPrefsServiceProvider));
});

final walletRepositoryProvider = Provider((ref) {
  return WalletRepositoryImpl(ref.watch(walletLocalDatasourceProvider));
});

final transactionRepositoryProvider = Provider((ref) {
  return TransactionRepositoryImpl(
      ref.watch(transactionLocalDatasourceProvider));
});

final billRepositoryProvider = Provider((ref) {
  return BillRepositoryImpl(ref.watch(billLocalDatasourceProvider));
});

final umkmRepositoryProvider = Provider((ref) {
  return UmkmRepositoryImpl(ref.watch(umkmLocalDatasourceProvider));
});

final syncRepositoryProvider = Provider((ref) {
  return SyncRepositoryImpl(
      ref.watch(transactionLocalDatasourceProvider),
      ref.watch(walletLocalDatasourceProvider),
      ref.watch(billLocalDatasourceProvider),
      ref.watch(umkmLocalDatasourceProvider),
      ref.watch(categoryLocalDatasourceProvider),
      ref.watch(syncRemoteDatasourceProvider),
      ref.watch(sharedPrefsServiceProvider));
});
