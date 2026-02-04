import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String formatDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime parse(String dateString) {
    return DateTime.parse(dateString);
  }

  // Common utility to get current timestamp for DB
  static String getCurrentTimestamp() {
    return formatDateTime(DateTime.now());
  }
}
