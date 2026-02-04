import '../../domain/repositories/wallet_repository.dart';
import '../../domain/entities/wallet.dart';
import '../../data/models/wallet_model.dart';
import '../datasources/local/wallet_local_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletLocalDatasource _localDatasource;

  WalletRepositoryImpl(this._localDatasource);

  @override
  Future<void> addWallet(Wallet wallet) async {
    // We need userId here. Ideally passed from UseCase or context.
    // For now assuming existing flow handles it or we pass a Model.
    // But repository accepts Entity.
    // Let's assume Entity has userId or we inject user context.
    // Since Entity doesn't have userId in definition above, let's add it or assume.
    // Wait, Entity definition was: id, type, name, balance.
    // Model has userId.
    // I'll update Entity to have userId or manage it here.

    final model = WalletModel(
      id: wallet.id,
      userId: wallet.userId,
      type: wallet.type,
      name: wallet.name,
      balance: wallet.balance,
      updatedAt: DateTime.now(),
      isSynced: false,
    );
    await _localDatasource.insertWallet(model);
  }

  @override
  Future<List<Wallet>> getAllWallets() async {
    return await _localDatasource.getAllWallets();
  }

  @override
  Future<void> updateWalletBalance(String walletId, double newBalance) async {
    final wallets = await _localDatasource.getAllWallets();
    final wallet = wallets.firstWhere((w) => w.id == walletId);

    final updatedModel = WalletModel(
      id: wallet.id,
      userId: wallet.userId,
      type: wallet.type,
      name: wallet.name,
      balance: newBalance,
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    await _localDatasource.updateWallet(updatedModel);
  }
}
