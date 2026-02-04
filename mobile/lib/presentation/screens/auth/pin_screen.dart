import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key});

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  final List<String> _pin = [];
  bool _isLoading = false;
  String? _error;

  void _onNumberPressed(String number) {
    if (_pin.length < 6) {
      setState(() {
        _pin.add(number);
        _error = null;
      });
      if (_pin.length == 6) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() => _pin.removeLast());
    }
  }

  Future<void> _verifyPin() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authStateProvider.notifier).verifyPin(_pin.join());
      // Router will automatically redirect to home because of state change
    } catch (e) {
      setState(() {
        _isLoading = false;
        _pin.clear();
        _error = 'PIN Salah. Silakan coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.surfaceGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'Masukkan PIN Keamanan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // PIN Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < _pin.length
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
              const SizedBox(height: 40),
              if (_isLoading)
                const CircularProgressIndicator(color: Colors.white)
              else
                _buildKeypad(),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => ref.read(authStateProvider.notifier).logout(),
                child: const Text('Keluar Akun',
                    style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        for (var i = 0; i < 3; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var j = 1; j <= 3; j++) _buildKey((i * 3 + j).toString()),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 80, height: 80),
            _buildKey('0'),
            _buildKey('backspace', isIcon: true),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String value, {bool isIcon = false}) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 60,
      height: 60,
      child: InkWell(
        onTap: isIcon ? _onBackspace : () => _onNumberPressed(value),
        borderRadius: BorderRadius.circular(30),
        child: Center(
          child: isIcon
              ? const Icon(Icons.backspace_outlined, color: Colors.white)
              : Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
        ),
      ),
    );
  }
}
