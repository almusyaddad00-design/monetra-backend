import '../../domain/repositories/bill_repository.dart';
import '../../domain/entities/bill.dart';
import '../datasources/local/bill_local_datasource.dart';
import '../models/bill_model.dart';

class BillRepositoryImpl implements BillRepository {
  final BillLocalDatasource _localDatasource;

  BillRepositoryImpl(this._localDatasource);

  @override
  Future<void> addBill(Bill bill) async {
    final model = BillModel(
      id: bill.id,
      userId: bill.userId,
      title: bill.title,
      amount: bill.amount,
      dueDate: bill.dueDate,
      repeatCycle: bill.repeatCycle,
      status: bill.status,
      updatedAt: DateTime.now(),
      isSynced: false,
    );
    await _localDatasource.insertBill(model);
  }

  @override
  Future<void> updateBill(Bill bill) async {
    final model = BillModel(
      id: bill.id,
      userId: bill.userId,
      title: bill.title,
      amount: bill.amount,
      dueDate: bill.dueDate,
      repeatCycle: bill.repeatCycle,
      status: bill.status,
      updatedAt: DateTime.now(),
      isSynced: false,
    );
    await _localDatasource.updateBill(model);
  }

  @override
  Future<List<Bill>> getAllBills() async {
    return await _localDatasource.getAllBills();
  }
}
