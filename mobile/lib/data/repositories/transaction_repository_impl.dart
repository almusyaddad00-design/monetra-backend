import '../../domain/repositories/transaction_repository.dart';
import '../../domain/entities/transaction.dart';
import '../../data/models/transaction_model.dart';
import '../datasources/local/transaction_local_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDatasource _localDatasource;

  TransactionRepositoryImpl(this._localDatasource);

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final model = TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      walletId: transaction.walletId,
      categoryId: transaction.categoryId,
      type: transaction.type,
      amount: transaction.amount,
      date: transaction.date,
      note: transaction.note,
      isSynced: transaction.isSynced,
      updatedAt: transaction.updatedAt,
    );
    await _localDatasource.insertTransaction(model);
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final models = await _localDatasource.getAllTransactions();
    return models; // TransactionModel extends Transaction, so this works
  }
}
