import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/id_formatter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/bill_provider.dart';
import '../../../core/theme/app_colors.dart';

class BillScreen extends ConsumerWidget {
  const BillScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(billListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengingat Tagihan'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
      ),
      body: billsAsync.when(
        data: (bills) => bills.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  final b = bills[index];
                  final isNear =
                      b.dueDate.difference(DateTime.now()).inDays < 3;
                  final isUnpaid = b.status == 'unpaid';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    color: isNear && isUnpaid
                        ? AppColors.error.withValues(alpha: 0.05)
                        : Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(isUnpaid
                                ? 'Konfirmasi Pembayaran'
                                : 'Batalkan Pembayaran'),
                            content: Text(isUnpaid
                                ? 'Tandai tagihan ini sebagai SUDAH DIBAYAR?'
                                : 'Kembalikan status tagihan ke BELUM BAYAR?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal')),
                              ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(billListProvider.notifier)
                                      .toggleStatus(b);
                                  Navigator.pop(context);
                                },
                                child:
                                    Text(isUnpaid ? 'Ya, Lunas' : 'Kembalikan'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isNear && isUnpaid
                                    ? AppColors.error.withValues(alpha: 0.1)
                                    : AppColors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.receipt_long_rounded,
                                color: isNear && isUnpaid
                                    ? AppColors.error
                                    : AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    b.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Jatuh tempo: ${IdFormatter.formatDate(b.dueDate)}',
                                    style: TextStyle(
                                      color: isNear && isUnpaid
                                          ? AppColors.error
                                          : AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: isNear && isUnpaid
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  IdFormatter.formatRupiah(b.amount),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isUnpaid
                                        ? AppColors.error.withValues(alpha: 0.1)
                                        : Colors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isUnpaid ? 'BELUM BAYAR' : 'LUNAS',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isUnpaid
                                          ? AppColors.error
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
        onPressed: () => _showAddBillDialog(context, ref),
        label: const Text('Tambah Tagihan'),
        icon: const Icon(Icons.add_task_rounded),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_outlined,
              size: 80, color: AppColors.textSecondary.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          const Text('Tidak ada tagihan aktif.',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _showAddBillDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Daftarkan Tagihan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      labelText: 'Nama Tagihan (Listrik, Wifi, dll)')),
              const SizedBox(height: 16),
              TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Jumlah Tagihan (Rp)')),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => selectedDate = picked);
                },
                child: InputDecorator(
                  decoration:
                      const InputDecoration(labelText: 'Tanggal Jatuh Tempo'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(IdFormatter.formatDate(selectedDate)),
                      const Icon(Icons.calendar_month_rounded,
                          color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                final user = ref.read(authStateProvider).value;
                if (user != null) {
                  ref.read(billListProvider.notifier).addBill(
                        userId: user.id,
                        title: titleController.text,
                        amount: double.tryParse(amountController.text) ?? 0,
                        dueDate: selectedDate,
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
