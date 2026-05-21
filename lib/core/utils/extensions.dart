/// Extensions for date/time formatting
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Format date as 'DD/MM/YYYY'
  String toFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  /// Format date and time as 'DD/MM/YYYY HH:mm'
  String toFormattedDateTime() {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }

  /// Format time as 'HH:mm'
  String toFormattedTime() {
    return DateFormat('HH:mm').format(this);
  }

  /// Get relative time (e.g., "2 hours ago", "Tomorrow")
  String toRelativeTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final todayDateTime = DateTime(year, month, day);

    if (todayDateTime == today) {
      return 'Today at ${toFormattedTime()}';
    } else if (todayDateTime == yesterday) {
      return 'Yesterday at ${toFormattedTime()}';
    } else if (todayDateTime == tomorrow) {
      return 'Tomorrow at ${toFormattedTime()}';
    } else {
      return toFormattedDateTime();
    }
  }
}

/// String validation extensions
extension StringExtension on String {
  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool isEmpty() => trim().isEmpty;

  bool isNotEmpty() => trim().isNotEmpty;
}
