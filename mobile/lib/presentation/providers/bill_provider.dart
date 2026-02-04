import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/bill.dart';
import '../../domain/repositories/bill_repository.dart';
import 'providers.dart';

final billListProvider =
    StateNotifierProvider<BillListNotifier, AsyncValue<List<Bill>>>((ref) {
  final repository = ref.watch(billRepositoryProvider);
  return BillListNotifier(repository);
});

class BillListNotifier extends StateNotifier<AsyncValue<List<Bill>>> {
  final BillRepository _repository;

  BillListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadBills();
  }

  Future<void> loadBills() async {
    try {
      final bills = await _repository.getAllBills();
      state = AsyncValue.data(bills);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addBill({
    required String userId,
    required String title,
    required double amount,
    required DateTime dueDate,
    String? repeatCycle,
  }) async {
    final bill = Bill(
      id: const Uuid().v4(),
      userId: userId,
      title: title,
      amount: amount,
      dueDate: dueDate,
      repeatCycle: repeatCycle,
      status: 'unpaid',
    );
    await _repository.addBill(bill);
    await loadBills();
  }

  Future<void> toggleStatus(Bill bill) async {
    final newStatus = bill.status == 'unpaid' ? 'paid' : 'unpaid';
    final updatedBill = Bill(
      id: bill.id,
      userId: bill.userId,
      title: bill.title,
      amount: bill.amount,
      dueDate: bill.dueDate,
      repeatCycle: bill.repeatCycle,
      status: newStatus,
    );
    await _repository.updateBill(updatedBill);
    await loadBills();
  }
}
