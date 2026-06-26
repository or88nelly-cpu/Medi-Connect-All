import 'package:intl/intl.dart';

class DashboardUtils {
  DashboardUtils._();

  /// Good Morning / Afternoon / Evening
  static String getWelcomeMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  /// 10 Jun 2026
  static String getCurrentDate() {
    return DateFormat('dd MMM yyyy').format(DateTime.now());
  }

  /// Wednesday
  static String getCurrentDay() {
    return DateFormat('EEEE').format(DateTime.now());
  }

  /// 09:30 AM
  static String getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  /// 09:30
  static String getCurrentTime24() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  /// Wednesday, 10 Jun 2026
  static String getFullDate() {
    return DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());
  }

  /// 10 Jun 2026 | 09:30 AM
  static String getDateTime() {
    return DateFormat('dd MMM yyyy | hh:mm a').format(DateTime.now());
  }
}
