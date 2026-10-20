/// Repeat options for a reminder.
/// [value] is what gets stored in Firestore (none | daily | weekly | custom).
/// [label] is what the user sees.
enum RepeatRule {
  none('none', 'Does not repeat'),
  daily('daily', 'Every day'),
  weekdays('custom', 'Weekdays'), // stored as custom; weekday list comes later
  weekly('weekly', 'Every week');

  const RepeatRule(this.value, this.label);

  final String value;
  final String label;
}
