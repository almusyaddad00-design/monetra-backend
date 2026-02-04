import '../../domain/entities/umkm_sale.dart';
import '../../domain/entities/umkm_debt.dart';
import '../../domain/repositories/umkm_repository.dart';
import '../datasources/local/umkm_local_datasource.dart';
import '../models/umkm_sale_model.dart';
import '../models/umkm_debt_model.dart';

class UmkmRepositoryImpl implements UmkmRepository {
  final UmkmLocalDatasource _localDatasource;

  UmkmRepositoryImpl(this._localDatasource);

  @override
  Future<void> addSale(UmkmSale sale) async {
    final model = UmkmSaleModel(
      id: sale.id,
      userId: sale.userId,
      customerName: sale.customerName,
      amount: sale.amount,
      date: sale.date,
      isSynced: false,
      updatedAt: DateTime.now(),
    );
    await _localDatasource.insertSale(model);
  }

  @override
  Future<List<UmkmSale>> getAllSales() async {
    return await _localDatasource.getAllSales();
  }

  @override
  Future<void> addDebt(UmkmDebt debt) async {
    final model = UmkmDebtModel(
      id: debt.id,
      userId: debt.userId,
      name: debt.name,
      type: debt.type,
      amount: debt.amount,
      dueDate: debt.dueDate,
      isPaid: debt.isPaid,
      isSynced: false,
      updatedAt: DateTime.now(),
    );
    await _localDatasource.insertDebt(model);
  }

  @override
  Future<List<UmkmDebt>> getAllDebts() async {
    return await _localDatasource.getAllDebts();
  }
}
