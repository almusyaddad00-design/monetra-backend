import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/shared_prefs_service.dart';
import 'presentation/providers/providers.dart';
import 'presentation/providers/auto_sync_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(SharedPrefsService(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // Initialize auto sync service
    ref.watch(autoSyncProvider);

    return MaterialApp.router(
      title: 'Monetra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
