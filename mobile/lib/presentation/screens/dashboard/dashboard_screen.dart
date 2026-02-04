import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/id_formatter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/providers.dart';
import '../../providers/wallet_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/bill_provider.dart';
import '../../providers/umkm_provider.dart';
import '../../providers/auto_sync_provider.dart';
import '../../../core/theme/app_colors.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(totalBalanceProvider);
    final user = ref.watch(authStateProvider).value;
    final transactionsAsync = ref.watch(transactionListProvider);
    final billsAsync = ref.watch(billListProvider);
    final umkmSalesAsync = ref.watch(umkmSalesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, ref, user?.name ?? 'Pengguna'),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBalanceCard(context, balance, transactionsAsync),
                _buildSectionHeader(context, 'Menu Utama'),
                _buildActionGrid(context),
                _buildSectionHeader(context, 'Ringkasan Keuangan'),
                _buildSummaryList(context, billsAsync, umkmSalesAsync),
                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/transactions'),
        label: const Text('Transaksi Baru'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, WidgetRef ref, String userName) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        centerTitle: false,
        title: Text(
          'Halo, $userName',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
            ),
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/logo_icon.png',
                  width: 150,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.sync_rounded, color: Colors.white),
          onPressed: () => _handleSync(context, ref),
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: Colors.white70),
          onPressed: () => ref.read(authStateProvider.notifier).logout(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Future<void> _handleSync(BuildContext context, WidgetRef ref) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Sinkronisasi data...')));
    try {
      await ref.read(syncRepositoryProvider).syncData();
      ref.invalidate(walletListProvider);
      ref.invalidate(transactionListProvider);
      ref.invalidate(billListProvider);
      ref.invalidate(umkmSalesProvider);
      ref.invalidate(umkmDebtsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sinkronisasi Selesai!')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Sync Gagal: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, double balance,
      AsyncValue<List<dynamic>> transactionsAsync) {
    double income = 0;
    double expense = 0;

    transactionsAsync.whenData((transactions) {
      for (var t in transactions) {
        if (t.type == 'income') {
          income += t.amount;
        } else {
          expense += t.amount;
        }
      }
    });

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.surfaceGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Saldo',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_rounded, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'Tersimpan Aman',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Consumer(builder: (context, ref, child) {
            final lastSync = ref.watch(lastSyncTimeProvider);
            return Text(
              'Terakhir Sinkron: ${lastSync ?? 'Belum pernah'}',
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            );
          }),
          const SizedBox(height: 12),
          Text(
            IdFormatter.formatRupiah(balance),
            style: const TextStyle(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildBalanceStat(
                  Icons.arrow_downward_rounded,
                  'Pemasukan',
                  IdFormatter.formatRupiah(income),
                  AppColors.secondary,
                ),
              ),
              Container(width: 1, height: 40, color: Colors.white24),
              Expanded(
                child: _buildBalanceStat(
                  Icons.arrow_upward_rounded,
                  'Pengeluaran',
                  IdFormatter.formatRupiah(expense),
                  Colors.orangeAccent,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBalanceStat(
      IconData icon, String label, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              amount,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 0.9,
        children: [
          _buildActionItem(context, Icons.account_balance_wallet_rounded,
              'Dompet', '/wallets', AppColors.primary),
          _buildActionItem(context, Icons.receipt_long_rounded, 'Transaksi',
              '/transactions', Colors.blue),
          _buildActionItem(context, Icons.notifications_active_rounded,
              'Tagihan', '/bills', AppColors.error),
          _buildActionItem(context, Icons.storefront_rounded, 'UMKM', '/umkm',
              AppColors.secondary),
          _buildActionItem(context, Icons.pie_chart_rounded, 'Laporan',
              '/reports', Colors.purple),
          _buildActionItem(context, Icons.settings_rounded, 'Atur', '/settings',
              Colors.blueGrey),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String label,
      String route, Color color) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryList(
      BuildContext context,
      AsyncValue<List<dynamic>> billsAsync,
      AsyncValue<List<dynamic>> salesAsync) {
    int unpaidBills = 0;
    billsAsync.whenData((bills) {
      unpaidBills = bills.where((b) => b.status == 'unpaid').length;
    });

    double totalSales = 0;
    salesAsync.whenData((sales) {
      for (var s in sales) {
        totalSales += s.amount;
      }
    });

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryItem(
              Icons.warning_rounded,
              'Tagihan Mendatang',
              unpaidBills > 0
                  ? '$unpaidBills Belum dibayar'
                  : 'Semua tagihan lunas',
              AppColors.error,
              onTap: () => context.push('/bills')),
          const Divider(height: 1, indent: 60),
          _buildSummaryItem(
              Icons.trending_up_rounded,
              'Penjualan UMKM',
              totalSales > 0
                  ? 'Total: ${IdFormatter.formatRupiah(totalSales)}'
                  : 'Belum ada penjualan',
              AppColors.secondary,
              onTap: () => context.push('/umkm')),
          const Divider(height: 1, indent: 60),
          _buildSummaryItem(Icons.account_balance_rounded, 'Status Keuangan',
              'Stabil', Colors.orange,
              onTap: () => context.push('/reports')),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      IconData icon, String title, String subtitle, Color color,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
