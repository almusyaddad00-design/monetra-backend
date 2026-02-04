import '../entities/bill.dart';

abstract class BillRepository {
  Future<void> addBill(Bill bill);
  Future<void> updateBill(Bill bill);
  Future<List<Bill>> getAllBills();
}
