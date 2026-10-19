class Reminder {
  final String
  time; // plain text for now, we'll switch to DateTime when we add real alarms
  final String title;
  final String sharedWith;
  final bool done;

  const Reminder({
    required this.time,
    required this.title,
    required this.sharedWith,
    this.done = false,
  });
}
