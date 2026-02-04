import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/auth/pin_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/wallet/wallet_list_screen.dart';
import '../../presentation/screens/transaction/transaction_list_screen.dart';
import '../../presentation/screens/umkm/umkm_screen.dart';
import '../../presentation/screens/bill/bill_screen.dart';
import '../../presentation/screens/reports/reports_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isPinVerified = ref.read(authStateProvider.notifier).isPinVerified;
      final hasPin =
          authState.value?.pin != null && authState.value!.pin!.isNotEmpty;

      final isAuthRoute = state.uri.path == '/login' ||
          state.uri.path == '/register' ||
          state.uri.path == '/forgot-password';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/';

      // PIN Logic: If logged in, has PIN, but not verified, force PIN screen
      if (isLoggedIn && hasPin && !isPinVerified && state.uri.path != '/pin') {
        return '/pin';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/pin',
        builder: (context, state) => const PinScreen(),
      ),
      GoRoute(
        path: '/wallets',
        builder: (context, state) => const WalletListScreen(),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionListScreen(),
      ),
      GoRoute(
        path: '/umkm',
        builder: (context, state) => const UmkmScreen(),
      ),
      GoRoute(
        path: '/bills',
        builder: (context, state) => const BillScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
