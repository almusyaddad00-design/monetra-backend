import 'package:flutter/foundation.dart'; // For kIsWeb
import '../../../core/utils/web_utils.dart'
    if (dart.library.html) '../../../core/utils/web_utils_web.dart'
    as web_utils;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Check for Google Auth token in URL (for Web)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kIsWeb) {
        final token = web_utils.getWebToken();
        if (token != null) {
          ref.read(authStateProvider.notifier).loginWithToken(token);
          // Clean the URL
          web_utils.cleanWebUrl();
        }
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginWithGoogle() {
    if (kIsWeb) {
      // Redirect to Laravel Google Auth endpoint
      web_utils.redirectToGoogleAuth();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Google Sign-In is only available on Web for now')),
      );
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authStateProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.surfaceGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Monetra Logo with Glow Effect
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.2),
                            blurRadius: 100,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo_full.png',
                        height: 200, // Slightly larger for impact
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(alpha: 0.95), // Slight glassmorphism
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang',
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Silakan login untuk melanjutkan',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'user@example.com',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                value == null || !value.contains('@')
                                    ? 'Masukkan email yang valid'
                                    : null,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) =>
                                value == null || value.length < 6
                                    ? 'Password minimal 6 karakter'
                                    : null,
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context.push('/forgot-password'),
                              child: const Text('Lupa Password?'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          authState.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: _submit,
                                      child: const Text('MASUK'),
                                    ),
                                    const SizedBox(height: 16),
                                    const Row(
                                      children: [
                                        Expanded(child: Divider()),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Text('atau',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                        Expanded(child: Divider()),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    OutlinedButton.icon(
                                      onPressed: _loginWithGoogle,
                                      icon: Image.network(
                                        'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                                        height: 24,
                                        width: 24,
                                        // Some network images of SVGs might fail, usually we use a local asset
                                        // But for now let's use a standard icon if fail
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.login),
                                      ),
                                      label: const Text('Masuk dengan Google'),
                                      style: OutlinedButton.styleFrom(
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                      ),
                                    ),
                                  ],
                                ),
                          if (authState.hasError) ...[
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                'Error: ${authState.error}',
                                style: const TextStyle(color: AppColors.error),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun? ',
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        child: const Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
