import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/transaction_provider.dart';
import '../../../core/utils/id_formatter.dart';
import '../../widgets/financial_pie_chart.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: transactionsAsync.when(
          data: (transactions) {
            // Use all transactions for now to ensure data visibility
            final currentTransactions = transactions;

            // Calculate totals
            double totalIncome = 0;
            double totalExpense = 0;
            double maxExpenseAmount = 0;
            String maxExpenseNote = '-';

            for (var t in currentTransactions) {
              if (t.type == 'income') {
                totalIncome += t.amount;
              } else {
                totalExpense += t.amount;
                if (t.amount > maxExpenseAmount) {
                  maxExpenseAmount = t.amount;
                  maxExpenseNote = t.note?.isNotEmpty == true
                      ? t.note!
                      : 'Transaksi Tanpa Catatan';
                }
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FinancialPieChart(income: totalIncome, expense: totalExpense),
                const SizedBox(height: 24),
                Text(
                  'Ringkasan Keuangan (Semua)',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildReportItem(
                    'Pengeluaran Terbesar',
                    maxExpenseAmount > 0
                        ? '$maxExpenseNote (${IdFormatter.formatRupiah(maxExpenseAmount)})'
                        : '-',
                    Colors.orange),
                _buildReportItem('Pemasukan Total',
                    IdFormatter.formatRupiah(totalIncome), AppColors.secondary),
                _buildReportItem('Pengeluaran Total',
                    IdFormatter.formatRupiah(totalExpense), AppColors.error),
                _buildReportItem(
                  'Sisa Uang (Net)',
                  IdFormatter.formatRupiah(totalIncome - totalExpense),
                  Colors.blue,
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  Widget _buildReportItem(String title, String value, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(Icons.analytics_rounded, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
