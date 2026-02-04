import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monetra/core/theme/app_colors.dart';
import '../../providers/wallet_provider.dart';
import '../../../core/utils/id_formatter.dart';
import '../../../core/utils/currency_input_formatter.dart';

class WalletListScreen extends ConsumerWidget {
  const WalletListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(walletListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dompet & Rekening'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
      ),
      body: walletsAsync.when(
        data: (wallets) => wallets.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: wallets.length,
                itemBuilder: (context, index) {
                  final wallet = wallets[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_getIconForType(wallet.type),
                            color: AppColors.primary),
                      ),
                      title: Text(
                        wallet.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        wallet.type.toUpperCase(),
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            letterSpacing: 1.1,
                            fontSize: 12),
                      ),
                      trailing: Text(
                        IdFormatter.formatRupiah(wallet.balance),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddWalletDialog(context, ref),
        label: const Text('Tambah Dompet'),
        icon: const Icon(Icons.add_card_rounded),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'bank':
        return Icons.account_balance_rounded;
      case 'e-wallet':
        return Icons.account_balance_wallet_rounded;
      case 'cash':
        return Icons.payments_rounded;
      default:
        return Icons.wallet_rounded;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              size: 80, color: AppColors.textSecondary.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          const Text('Belum ada dompet yang terdaftar.',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _showAddWalletDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final balanceController = TextEditingController();
    String type = 'bank';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Tambah Dompet Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Nama Dompet (e.g. BCA, OVO)')),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: type,
                items: const [
                  DropdownMenuItem<String>(value: 'bank', child: Text('Bank')),
                  DropdownMenuItem<String>(
                      value: 'e-wallet', child: Text('E-Wallet')),
                  DropdownMenuItem<String>(value: 'cash', child: Text('Tunai')),
                ],
                onChanged: (v) => setState(() => type = v!),
                decoration: const InputDecoration(labelText: 'Jenis Dompet'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: balanceController,
                inputFormatters: [CurrencyInputFormatter()],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Saldo Awal (Rp)'),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                ref.read(walletListProvider.notifier).addWallet(
                      nameController.text,
                      type,
                      IdFormatter.parseAmount(balanceController.text),
                    );
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
