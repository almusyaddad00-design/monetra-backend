import '../entities/wallet.dart';

abstract class WalletRepository {
  Future<void> addWallet(Wallet wallet);
  Future<List<Wallet>> getAllWallets();
  Future<void> updateWalletBalance(String walletId, double newBalance);
}
