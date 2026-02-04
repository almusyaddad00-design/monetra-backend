import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/sync_repository_impl.dart';
import 'providers.dart';
import 'auth_provider.dart';
import 'wallet_provider.dart';
import 'transaction_provider.dart';
import 'bill_provider.dart';
import 'umkm_provider.dart';

final autoSyncProvider = Provider<AutoSyncService>((ref) {
  final syncRepo = ref.watch(syncRepositoryProvider);
  return AutoSyncService(ref, syncRepo);
});

final lastSyncTimeProvider = StateProvider<String?>((ref) {
  final prefs = ref.watch(sharedPrefsServiceProvider);
  return prefs.getLastSyncTime();
});

class AutoSyncService {
  final Ref _ref;
  final SyncRepositoryImpl _syncRepo;
  Timer? _timer;
  bool _isSyncing = false;

  AutoSyncService(this._ref, this._syncRepo) {
    _init();
  }

  void _init() {
    // Listen to authentication state
    _ref.listen(authStateProvider, (previous, next) {
      final user = next.value;
      if (user != null) {
        _startTimer();
      } else {
        _stopTimer();
      }
    });

    // Initial check if already logged in
    final user = _ref.read(authStateProvider).value;
    if (user != null) {
      _startTimer();
    }
  }

  void _startTimer() {
    _stopTimer();
    // Auto sync every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => performSync());
    // Also perform an immediate sync on start
    Future.delayed(const Duration(seconds: 5), () => performSync());
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> performSync() async {
    if (_isSyncing) return;

    final user = _ref.read(authStateProvider).value;
    if (user == null) return;

    _isSyncing = true;
    try {
      await _syncRepo.syncData();

      // Update last sync time provider
      final prefs = _ref.read(sharedPrefsServiceProvider);
      _ref.read(lastSyncTimeProvider.notifier).state = prefs.getLastSyncTime();

      // Refresh all providers to show new data
      _ref.invalidate(walletListProvider);
      _ref.invalidate(transactionListProvider);
      _ref.invalidate(billListProvider);
      _ref.invalidate(umkmSalesProvider);
      _ref.invalidate(umkmDebtsProvider);

      if (kDebugMode) {
        print('Auto-Sync: Data synchronized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Auto-Sync Error: $e');
      }
    } finally {
      _isSyncing = false;
    }
  }
}
