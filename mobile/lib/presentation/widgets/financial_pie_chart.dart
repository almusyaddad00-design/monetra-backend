import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/id_formatter.dart';

class FinancialPieChart extends StatelessWidget {
  final double income;
  final double expense;

  const FinancialPieChart({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    if (income == 0 && expense == 0) {
      return _buildEmptyChart();
    }

    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(200, 200),
            painter: _PieChartPainter(
              income: income,
              expense: expense,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Saldo Bersih',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${((income - expense) / (income == 0 ? (expense == 0 ? 1 : expense) : income) * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                IdFormatter.formatRupiah(income - expense),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      height: 250,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.pie_chart_outline_rounded,
              size: 80, color: AppColors.textSecondary.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          const Text('Belum ada data transaksi',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final double income;
  final double expense;

  _PieChartPainter({required this.income, required this.expense});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    const strokeWidth = 25.0;

    final total = income + expense;
    final incomeSweep = total == 0 ? 0.0 : (income / total) * 2 * pi;
    final expenseSweep = total == 0 ? 0.0 : (expense / total) * 2 * pi;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw Expense Arc (Orange)
    if (expense > 0) {
      paint.color = Colors.orangeAccent;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        -pi / 2, // Start from top
        expenseSweep,
        false,
        paint,
      );
    }

    // Draw Income Arc (Secondary)
    if (income > 0) {
      paint.color = AppColors.secondary;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        -pi / 2 + expenseSweep, // Start where expense ended
        incomeSweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
