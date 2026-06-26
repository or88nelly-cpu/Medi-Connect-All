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

  AppDateUtils._();
}
