import 'package:intl/intl.dart';

class IdFormatter {
  static String formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static double parseAmount(String value) {
    // Remove all non-digit characters
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleanValue) ?? 0.0;
  }
}
