import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'providers.dart';
import '../../core/database/db_cleaner.dart';

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository, ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _authRepository;
  final Ref _ref;
  bool _isPinVerified = false;

  bool get isPinVerified => _isPinVerified;

  AuthNotifier(this._authRepository, this._ref)
      : super(const AsyncValue.data(null)) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    if (isLoggedIn) {
      try {
        final user = await _authRepository.getProfile();
        state = AsyncValue.data(user);
      } catch (e) {
        // Token might be invalid or expired
        await _authRepository.logout();
        state = const AsyncValue.data(null);
      }
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      // Clear all local data to prevent next user from seeing previous user's data
      final sqlite = _ref.read(sqliteServiceProvider);
      final prefs = _ref.read(sharedPrefsServiceProvider);
      await DBCleaner.cleanLocalData(sqlite, prefs);

      final user = await _authRepository.login(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(
      String name, String email, String password, String? pin) async {
    state = const AsyncValue.loading();
    try {
      // Clear all local data to prevent next user from seeing previous user's data
      final sqlite = _ref.read(sqliteServiceProvider);
      final prefs = _ref.read(sharedPrefsServiceProvider);
      await DBCleaner.cleanLocalData(sqlite, prefs);

      final user = await _authRepository.register(name, email, password, pin);
      // If user sets pin during registration, they need to verify it next time or we can auto-verify now
      _isPinVerified = true;
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> verifyPin(String pin) async {
    // We don't want to set global state to loading because it might trigger full screen loading
    try {
      await _authRepository.verifyPin(pin);
      _isPinVerified = true;
      // Trigger a state update to refresh router
      state = AsyncValue.data(state.value);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithToken(String token) async {
    state = const AsyncValue.loading();
    try {
      // Clear data before logging in with new token
      final sqlite = _ref.read(sqliteServiceProvider);
      final prefs = _ref.read(sharedPrefsServiceProvider);
      await DBCleaner.cleanLocalData(sqlite, prefs);

      // Save token manually in repository/local storage
      // Note: Assuming AuthRepository has a way to persist token
      // For now, we'll try to get the profile with this token
      await _authRepository.setToken(token);
      final user = await _authRepository.getProfile();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.logout();

      // Clear all local data to prevent next user from seeing previous user's data
      final sqlite = _ref.read(sqliteServiceProvider);
      final prefs = _ref.read(sharedPrefsServiceProvider);
      await DBCleaner.cleanLocalData(sqlite, prefs);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
