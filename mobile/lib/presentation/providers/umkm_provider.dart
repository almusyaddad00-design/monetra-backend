import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/umkm_sale.dart';
import '../../domain/entities/umkm_debt.dart';
import '../../domain/repositories/umkm_repository.dart';
import 'providers.dart';

final umkmSalesProvider =
    StateNotifierProvider<UmkmSalesNotifier, AsyncValue<List<UmkmSale>>>((ref) {
  final repository = ref.watch(umkmRepositoryProvider);
  return UmkmSalesNotifier(repository);
});

class UmkmSalesNotifier extends StateNotifier<AsyncValue<List<UmkmSale>>> {
  final UmkmRepository _repository;
  UmkmSalesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadSales();
  }

  Future<void> loadSales() async {
    try {
      final sales = await _repository.getAllSales();
      state = AsyncValue.data(sales);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> addSale({
    required String userId,
    required String customerName,
    required double amount,
    required DateTime date,
  }) async {
    final sale = UmkmSale(
      id: const Uuid().v4(),
      userId: userId,
      customerName: customerName,
      amount: amount,
      date: date,
      updatedAt: DateTime.now(),
    );
    await _repository.addSale(sale);
    await loadSales();
  }
}

final umkmDebtsProvider =
    StateNotifierProvider<UmkmDebtsNotifier, AsyncValue<List<UmkmDebt>>>((ref) {
  final repository = ref.watch(umkmRepositoryProvider);
  return UmkmDebtsNotifier(repository);
});

class UmkmDebtsNotifier extends StateNotifier<AsyncValue<List<UmkmDebt>>> {
  final UmkmRepository _repository;
  UmkmDebtsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadDebts();
  }

  Future<void> loadDebts() async {
    try {
      final debts = await _repository.getAllDebts();
      state = AsyncValue.data(debts);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> addDebt({
    required String userId,
    required String name,
    required String type,
    required double amount,
    required DateTime dueDate,
  }) async {
    final debt = UmkmDebt(
      id: const Uuid().v4(),
      userId: userId,
      name: name,
      type: type,
      amount: amount,
      dueDate: dueDate,
      updatedAt: DateTime.now(),
    );
    await _repository.addDebt(debt);
    await loadDebts();
  }
}
