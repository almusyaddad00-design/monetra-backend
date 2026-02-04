import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/id_formatter.dart';
import '../../../core/utils/currency_input_formatter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/umkm_provider.dart';
import '../../../core/theme/app_colors.dart';

class UmkmScreen extends ConsumerWidget {
  const UmkmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(umkmSalesProvider);
    final debtsAsync = ref.watch(umkmDebtsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mode Bisnis UMKM'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            tabs: [
              Tab(icon: Icon(Icons.shopping_cart_rounded), text: 'Penjualan'),
              Tab(icon: Icon(Icons.handshake_rounded), text: 'Hutang Piutang'),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(color: AppColors.background),
          child: TabBarView(
            children: [
              _buildSalesTab(context, ref, salesAsync),
              _buildDebtsTab(context, ref, debtsAsync),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesTab(
      BuildContext context, WidgetRef ref, AsyncValue<List> asyncData) {
    double totalToday = 0;
    if (asyncData.hasValue) {
      totalToday = asyncData.value!.fold(0, (sum, item) => sum + item.amount);
    }

    return Column(
      children: [
        _buildHeaderCard(context, 'Total Penjualan Hari Ini', totalToday,
            AppColors.secondary, Icons.trending_up_rounded),
        Expanded(
          child: asyncData.when(
            data: (data) => data.isEmpty
                ? _buildEmptyState(Icons.shopping_bag_outlined,
                    'Belum ada data penjualan hari ini.')
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor:
                                AppColors.secondary.withValues(alpha: 0.1),
                            child: const Icon(Icons.person,
                                color: AppColors.secondary),
                          ),
                          title: Text(item.customerName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(IdFormatter.formatDate(item.date)),
                          trailing: Text(
                            IdFormatter.formatRupiah(item.amount),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.secondary),
                          ),
                        ),
                      );
                    },
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () => _showAddSaleDialog(context, ref),
            icon: const Icon(Icons.add_shopping_cart_rounded),
            label: const Text('CATAT PENJUALAN BARU'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56)),
          ),
        ),
      ],
    );
  }

  Widget _buildDebtsTab(
      BuildContext context, WidgetRef ref, AsyncValue<List> asyncData) {
    double totalDebt = 0;
    if (asyncData.hasValue) {
      totalDebt = asyncData.value!.fold(0, (sum, item) => sum + item.amount);
    }

    return Column(
      children: [
        _buildHeaderCard(context, 'Total Pinjaman/Piutang', totalDebt,
            Colors.orange, Icons.history_edu_rounded),
        Expanded(
          child: asyncData.when(
            data: (data) => data.isEmpty
                ? _buildEmptyState(Icons.assignment_outlined,
                    'Belum ada catatan hutang piutang.')
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      final isHutang = item.type == 'debt';
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: (isHutang
                                    ? AppColors.error
                                    : AppColors.secondary)
                                .withValues(alpha: 0.1),
                            child: Icon(
                                isHutang
                                    ? Icons.call_made_rounded
                                    : Icons.call_received_rounded,
                                color: isHutang
                                    ? AppColors.error
                                    : AppColors.secondary),
                          ),
                          title: Text(item.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              'Tempo: ${IdFormatter.formatDate(item.dueDate)}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                IdFormatter.formatRupiah(item.amount),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isHutang
                                      ? AppColors.error
                                      : AppColors.secondary,
                                ),
                              ),
                              Text(isHutang ? 'HUTANG' : 'PIUTANG',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isHutang
                                          ? AppColors.error
                                          : AppColors.secondary)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () => _showAddDebtDialog(context, ref),
            icon: const Icon(Icons.person_add_rounded),
            label: const Text('CATAT HUTANG/PIUTANG'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard(BuildContext context, String title, double amount,
      Color color, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Text(IdFormatter.formatRupiah(amount),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Icon(icon, color: Colors.white, size: 48),
        ],
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 64, color: AppColors.textSecondary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _showAddSaleDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Catat Penjualan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Pelanggan')),
            const SizedBox(height: 16),
            TextField(
                controller: amountController,
                inputFormatters: [CurrencyInputFormatter()],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah (Rp)')),
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
                ref.read(umkmSalesProvider.notifier).addSale(
                      userId: user.id,
                      customerName: nameController.text,
                      amount: IdFormatter.parseAmount(amountController.text),
                      date: DateTime.now(),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showAddDebtDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    String type = 'debt';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Catat Hutang/Piutang'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: type,
                items: const [
                  DropdownMenuItem<String>(
                      value: 'debt', child: Text('Hutang (Saya Berhutang)')),
                  DropdownMenuItem<String>(
                      value: 'receivable', child: Text('Piutang (Dihutangi)')),
                ],
                onChanged: (v) => setState(() => type = v!),
                decoration: const InputDecoration(labelText: 'Jenis'),
              ),
              const SizedBox(height: 16),
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Orang')),
              const SizedBox(height: 16),
              TextField(
                  controller: amountController,
                  inputFormatters: [CurrencyInputFormatter()],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Jumlah (Rp)')),
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
                  ref.read(umkmDebtsProvider.notifier).addDebt(
                        userId: user.id,
                        name: nameController.text,
                        type: type,
                        amount: IdFormatter.parseAmount(amountController.text),
                        dueDate: DateTime.now().add(const Duration(days: 30)),
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
