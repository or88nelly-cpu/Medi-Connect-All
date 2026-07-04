/// Reusable date and time formatting and comparison helper functions.
class AppDateUtils {
  /// Formats DateTime into a human-readable string (e.g. "June 5, 2026").
  static String formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  /// Formats DateTime with time details (e.g. "June 5, 2026 at 12:30 PM").
  static String formatDateTime(DateTime date) {
    final dateStr = formatDate(date);
    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minuteStr = date.minute.toString().padLeft(2, '0');
    return "$dateStr at $hour:$minuteStr $period";
  }

  /// Formats time portion only (e.g. "12:30 PM").
  static String formatTime(DateTime date) {
    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minuteStr = date.minute.toString().padLeft(2, '0');
    return "$hour:$minuteStr $period";
  }

  /// Checks if a date falls in the future.
  static bool isFutureDate(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  /// Checks if a date falls in the past.
  static bool isPastDate(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Checks if two dates represent the same day.
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static String? calculateAge(DateTime? dob) {
    if (dob == null) return null;

    final now = DateTime.now();

    int years = now.year - dob.year;
    int months = now.month - dob.month;
    int days = now.day - dob.day;

    if (days < 0) {
      months--;
      final previousMonth = DateTime(now.year, now.month, 0);
      days += previousMonth.day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    final totalDays = now.difference(dob).inDays;

    // Less than 1 week
    if (totalDays < 7) {
      return '$totalDays day${totalDays == 1 ? '' : 's'}';
    }

    // Less than 1 month
    if (years == 0 && months == 0) {
      final weeks = totalDays ~/ 7;
      return '$weeks week${weeks == 1 ? '' : 's'}';
    }

    // Less than 1 year
    if (years == 0) {
      return '$months month${months == 1 ? '' : 's'}';
    }

    // Less than 10 years
    if (years < 10) {
      if (months == 0) {
        return '$years year${years == 1 ? '' : 's'}';
      }
      return '$years year${years == 1 ? '' : 's'} '
          '$months month${months == 1 ? '' : 's'}';
    }

    // 10 years or above
    return '$years year${years == 1 ? '' : 's'}';
  }

  AppDateUtils._();
}
