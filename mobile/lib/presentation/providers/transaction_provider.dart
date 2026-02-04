import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/wallet_repository.dart';
import 'providers.dart';
import 'wallet_provider.dart';

final transactionListProvider = StateNotifierProvider<TransactionListNotifier,
    AsyncValue<List<Transaction>>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  final walletRepository = ref.watch(walletRepositoryProvider);
  return TransactionListNotifier(repository, walletRepository, ref);
});

class TransactionListNotifier
    extends StateNotifier<AsyncValue<List<Transaction>>> {
  final TransactionRepository _repository;
  final WalletRepository _walletRepository;
  final Ref _ref;

  TransactionListNotifier(this._repository, this._walletRepository, this._ref)
      : super(const AsyncValue.loading()) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      final transactions = await _repository.getAllTransactions();
      state = AsyncValue.data(transactions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTransaction({
    required String userId,
    required String walletId,
    required String type,
    required double amount,
    required DateTime date,
    String? categoryId,
    String? note,
  }) async {
    final transaction = Transaction(
      id: const Uuid().v4(),
      userId: userId,
      walletId: walletId,
      categoryId: categoryId,
      type: type,
      amount: amount,
      date: date,
      note: note,
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    await _repository.addTransaction(transaction);

    // Update Wallet Balance
    final wallets = await _walletRepository.getAllWallets();
    try {
      final wallet = wallets.firstWhere((w) => w.id == walletId);
      double newBalance = wallet.balance;
      if (type == 'expense') {
        newBalance -= amount;
      } else {
        newBalance += amount;
      }

      await _walletRepository.updateWalletBalance(walletId, newBalance);
    } catch (e) {
      // Wallet not found or other error
    }

    // Refresh both providers
    await loadTransactions();
    _ref.invalidate(walletListProvider);
  }
}
