import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import 'providers.dart';
import 'auth_provider.dart';

final walletListProvider = StateNotifierProvider<WalletListNotifier, AsyncValue<List<Wallet>>>((ref) {
  final repository = ref.watch(walletRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  final userId = authState.value?.id;
  
  return WalletListNotifier(repository, userId);
});

class WalletListNotifier extends StateNotifier<AsyncValue<List<Wallet>>> {
  final WalletRepository _repository;
  final String? _userId;

  WalletListNotifier(this._repository, this._userId) : super(const AsyncValue.loading()) {
    loadWallets();
  }

  Future<void> loadWallets() async {
    try {
      final wallets = await _repository.getAllWallets();
      state = AsyncValue.data(wallets);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addWallet(String name, String type, double balance) async {
    if (_userId == null) return;
    
    final wallet = Wallet(
      id: const Uuid().v4(),
      userId: _userId!,
      type: type,
      name: name,
      balance: balance,
    );
    
    await _repository.addWallet(wallet);
    // Reload to refresh list
    await loadWallets();
  }
}

final totalBalanceProvider = Provider<double>((ref) {
  final walletsAsync = ref.watch(walletListProvider);
  return walletsAsync.maybeWhen(
    data: (wallets) => wallets.fold(0, (sum, item) => sum + item.balance),
    orElse: () => 0.0,
  );
});
