import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/providers.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Akun'),
          _buildSettingsItem(context, Icons.person_outline_rounded,
              'Profil Saya', 'Ubah detail akun Anda',
              onTap: () => _showProfileDialog(context, ref)),
          _buildSettingsItem(context, Icons.security_rounded, 'Keamanan',
              'PIN, Password, & Biometrik',
              onTap: () => _showSecurityDialog(context, ref)),
          const SizedBox(height: 24),
          _buildSectionHeader('Aplikasi'),
          _buildSettingsItem(context, Icons.notifications_none_rounded,
              'Notifikasi', 'Atur pengingat tagihan',
              onTap: () => _showNotificationDialog(context)),
          _buildSettingsItem(
              context, Icons.language_rounded, 'Bahasa', 'Bahasa Indonesia',
              onTap: () => _showLanguageDialog(context)),
          _buildSettingsItem(
              context, Icons.dark_mode_outlined, 'Tampilan', 'Mode Terang',
              onTap: () => _showThemeDialog(context)),
          const SizedBox(height: 24),
          _buildSectionHeader('Bantuan'),
          _buildSettingsItem(context, Icons.help_outline_rounded,
              'Pusat Bantuan', 'Tanya jawab & panduan',
              onTap: () => _showHelpDialog(context)),
          _buildSettingsItem(context, Icons.info_outline_rounded,
              'Tentang Monetra', 'Versi 1.0.0',
              onTap: () => _showAboutDialog(context)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('KELUAR APLIKASI'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error.withValues(alpha: 0.1),
              foregroundColor: AppColors.error,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontSize: 14),
      ),
    );
  }

  Widget _buildSettingsItem(
      BuildContext context, IconData icon, String title, String subtitle,
      {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textPrimary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing:
            const Icon(Icons.chevron_right_rounded, color: Colors.black26),
        onTap: onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fitur $title akan segera hadir!'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
      ),
    );
  }

  void _showProfileDialog(BuildContext context, WidgetRef ref) {
    final user = ref.read(authStateProvider).value;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profil Saya'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.secondary,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Nama'),
              subtitle: Text(user?.name ?? 'Pengguna'),
              leading: const Icon(Icons.person_outline),
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(user?.email ?? '-'),
              leading: const Icon(Icons.email_outlined),
            ),
            ListTile(
              title: const Text('User ID'),
              subtitle: Text(user?.id.substring(0, 8) ?? '-'),
              leading: const Icon(Icons.fingerprint),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Monetra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: const AssetImage('assets/images/logo_icon.png'),
              height: 64,
              errorBuilder: (c, o, s) => const Icon(
                  Icons.account_balance_wallet,
                  size: 64,
                  color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Monetra v1.0.0',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aplikasi Manajemen Keuangan & Kasir UMKM Tercanggih di Indonesia.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showSecurityDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Keamanan'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _showUpdatePinDialog(context, ref);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Ganti / Set PIN'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Fitur Ganti Password segera hadir')));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Ganti Password'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Biometrik diaktifkan')));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Aktifkan Biometrik'),
                  Icon(Icons.fingerprint, color: AppColors.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationDialog(BuildContext context) {
    bool reminders = true;
    bool updates = false;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Notifikasi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Pengingat Tagihan'),
                value: reminders,
                onChanged: (v) => setState(() => reminders = v),
              ),
              SwitchListTile(
                title: const Text('Info Promo & Update'),
                value: updates,
                onChanged: (v) => setState(() => updates = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Pilih Bahasa'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Row(
              children: [
                Icon(Icons.check, color: AppColors.primary),
                SizedBox(width: 12),
                Text('Bahasa Indonesia'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('English language coming soon')));
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 36.0, top: 8, bottom: 8),
              child: Text('English'),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Tampilan Aplikasi'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Row(
              children: [
                Icon(Icons.check, color: AppColors.primary),
                SizedBox(width: 12),
                Text('Mode Terang'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Mode Gelap akan segera tersedia')));
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 36.0, top: 8, bottom: 8),
              child: Text('Mode Gelap'),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pusat Bantuan'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hubungi kami jika ada kendala:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(children: [
              Icon(Icons.email_outlined, size: 20, color: Colors.grey),
              SizedBox(width: 8),
              Text('support@monetra.id'),
            ]),
            SizedBox(height: 8),
            Row(children: [
              Icon(Icons.phone_outlined, size: 20, color: Colors.grey),
              SizedBox(width: 8),
              Text('+62 812-3456-7890'),
            ]),
            SizedBox(height: 16),
            Text('Panduan Penggunaan:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('1. Catat transaksi di menu "Transaksi"'),
            Text('2. Kelola hutang di menu "UMKM"'),
            Text('3. Pantau uang di "Dompet"'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Oke, Paham'),
          ),
        ],
      ),
    );
  }

  void _showUpdatePinDialog(BuildContext context, WidgetRef ref) {
    final pinController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Ganti / Set PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Masukkan 6 digit PIN baru Anda:'),
              const SizedBox(height: 16),
              TextField(
                controller: pinController,
                decoration: const InputDecoration(
                  labelText: 'PIN Baru',
                  hintText: '6 digit angka',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : TextButton(
                    onPressed: () async {
                      if (pinController.text.length != 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('PIN harus 6 digit')),
                        );
                        return;
                      }

                      setState(() => isLoading = true);
                      try {
                        final authRepo = ref.read(authRepositoryProvider);
                        await authRepo.updatePin(pinController.text);
                        // Refresh user data to update the pin state locally
                        await ref
                            .read(authStateProvider.notifier)
                            .checkLoginStatus();

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('PIN berhasil diperbarui')),
                          );
                        }
                      } catch (e) {
                        setState(() => isLoading = false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gagal: $e')),
                          );
                        }
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
