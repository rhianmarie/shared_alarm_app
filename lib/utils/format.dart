const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
const _months = [
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
  'Dec',
];

/// "9:30"
String formatClock(DateTime d) {
  final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final minute = d.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

/// "PM"
String formatPeriod(DateTime d) => d.hour >= 12 ? 'PM' : 'AM';

/// "9:30 PM"
String formatTime(DateTime d) => '${formatClock(d)} ${formatPeriod(d)}';

/// "Oct 16"
String formatShortDate(DateTime d) => '${_months[d.month - 1]} ${d.day}';

/// "Fri"
String weekdayShort(DateTime d) => _weekdays[d.weekday - 1].substring(0, 3);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// "Today", "Tomorrow", or "Fri, Oct 16"
String relativeDay(DateTime d) {
  final now = DateTime.now();
  if (isSameDay(d, now)) return 'Today';
  if (isSameDay(d, now.add(const Duration(days: 1)))) return 'Tomorrow';
  return '${weekdayShort(d)}, ${formatShortDate(d)}';
}

/// "26 min remaining"
String remainingText(DateTime d) {
  final diff = d.difference(DateTime.now());
  if (diff.isNegative) return 'Overdue';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min remaining';
  if (diff.inHours < 24) {
    return '${diff.inHours} hr ${diff.inMinutes % 60} min remaining';
  }
  return '${diff.inDays} d remaining';
}
