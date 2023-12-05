class TimeUtils {
  static String formatDate(DateTime dateTime) {
    return '${_getWeekday(dateTime)}, ${_getMonth(dateTime)} ${dateTime.year}';
  }

  static String formatTime(DateTime dateTime) {
    return '${_getFormattedHour(dateTime)}:${_getFormattedMinute(dateTime)} ${_getAmPm(dateTime)}';
  }

  static String _getWeekday(DateTime dateTime) {
    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return weekdays[dateTime.weekday - 1];
  }

  static String _getMonth(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[dateTime.month - 1];
  }

  static String _getFormattedHour(DateTime dateTime) {
    int hour = dateTime.hour % 12;
    hour = hour == 0 ? 12 : hour;
    return hour.toString().padLeft(2, '0');
  }

  static String _getFormattedMinute(DateTime dateTime) {
    return dateTime.minute.toString().padLeft(2, '0');
  }

  static String _getAmPm(DateTime dateTime) {
    return dateTime.hour < 12 ? 'am' : 'pm';
  }

  static DateTime? parseDate(String dateText) {
    try {
      RegExp dashFormat = RegExp(r'^\d{2}-\d{2}-\d{4}$');
      RegExp slashFormat = RegExp(r'^\d{2}/\d{2}/\d{4}$');
      List<String>? parts;
      if (dashFormat.hasMatch(dateText)) {
        parts = dateText.split('-');
        int month = int.parse(parts[0]);
        int day = int.parse(parts[1]);
        int year = int.parse(parts[2]);

        return DateTime(year, month, day);
      } else if (slashFormat.hasMatch(dateText)) {
        parts = dateText.split('/');
        int month = int.parse(parts[0]);
        int day = int.parse(parts[1]);
        int year = int.parse(parts[2]);

        return DateTime(year, month, day);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
