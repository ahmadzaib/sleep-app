import 'package:intl/intl.dart';

class AppDateUtils {
  /// Standard date format: January 19, 2002
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMMM d, y').format(date);
  }

  /// Parse date from formatted string: January 19, 2002
  static DateTime? parseDate(String dateString) {
    if (dateString.isEmpty) return null;
    try {
      return DateFormat('MMMM d, y').parse(dateString);
    } catch (e) {
      // Try alternative formats if the main format fails
      try {
        return DateFormat('MMM d, y').parse(dateString);
      } catch (e) {
        try {
          return DateFormat('yyyy-MM-dd').parse(dateString);
        } catch (e) {
          return null;
        }
      }
    }
  }

  /// Format with time: January 19, 2002 - 10:00 AM
  static String formatDateWithTime(DateTime? date) {
    if (date == null) return '';
    return '${formatDate(date)} - ${formatTime(date)}';
  }

  /// Standard time format: 10:00 AM
  static String formatTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('h:mm a').format(date);
  }

  /// Compact date format if needed (e.g. for small cards): Jan 19, 2002
  static String formatShortDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d, y').format(date);
  }
}
