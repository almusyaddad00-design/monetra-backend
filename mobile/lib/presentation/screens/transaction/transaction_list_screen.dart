import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/wallet_provider.dart';
import '../../../core/utils/id_formatter.dart';
import '../../../core/utils/currency_input_formatter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../../core/theme/app_colors.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'expense';
  double _amount = 0;
  String? _selectedWalletId;
  String? _note;

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionListProvider);
    final walletsAsync = ref.watch(walletListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
      ),
      body: transactionsAsync.when(
        data: (transactions) => transactions.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final t = transactions[index];
                  final isExpense = t.type == 'expense';
                  final color =
                      isExpense ? AppColors.error : AppColors.secondary;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isExpense
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              color: color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.note?.isNotEmpty == true
                                      ? t.note!
                                      : (isExpense
                                          ? 'Pengeluaran'
                                          : 'Pemasukan'),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  IdFormatter.formatDate(t.date),
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${isExpense ? "-" : "+"}${IdFormatter.formatRupiah(t.amount)}',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Terjadi kesalahan: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, walletsAsync),
        label: const Text('Tambah'),
        icon: const Icon(Icons.add_rounded),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 80, color: AppColors.textSecondary.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          const Text('Belum ada transaksi tercatat.',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, AsyncValue walletsAsync) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 32,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transaksi Baru',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildTypeButton(
                        'Pengeluaran',
                        'expense',
                        AppColors.error,
                        _type == 'expense',
                        () => setModalState(() => _type = 'expense'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTypeButton(
                        'Pemasukan',
                        'income',
                        AppColors.secondary,
                        _type == 'income',
                        () => setModalState(() => _type = 'income'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Jumlah (Rp)',
                    prefixIcon: Icon(Icons.money_rounded),
                  ),
                  inputFormatters: [CurrencyInputFormatter()],
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Masukkan jumlah' : null,
                  onSaved: (v) => _amount = IdFormatter.parseAmount(v!),
                ),
                const SizedBox(height: 16),
                walletsAsync.when(
                  data: (wallets) => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Pilih Dompet',
                      prefixIcon: Icon(Icons.account_balance_wallet_rounded),
                    ),
                    items: wallets
                        .map<DropdownMenuItem<String>>((w) =>
                            DropdownMenuItem<String>(
                                value: w.id, child: Text(w.name)))
                        .toList(),
                    onChanged: (v) => _selectedWalletId = v,
                    validator: (v) => v == null ? 'Pilih dompet' : null,
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => const Text('Gagal memuat dompet'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Catatan (Opsional)',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                  onSaved: (v) => _note = v,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final user = ref.read(authStateProvider).value;
                      if (user != null && _selectedWalletId != null) {
                        ref
                            .read(transactionListProvider.notifier)
                            .addTransaction(
                              userId: user.id,
                              walletId: _selectedWalletId!,
                              type: _type,
                              amount: _amount,
                              date: DateTime.now(),
                              note: _note,
                            );
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('SIMPAN TRANSAKSI'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, String value, Color color,
      bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
