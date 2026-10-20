class Reminder {
  final String id;
  final String title;
  final String notes;
  final DateTime dateTime;
  final String repeat;
  final int remindMinutesBefore;
  final List<String> sharedWith;
  final bool done;

  const Reminder({
    required this.id,
    required this.title,
    this.notes = '',
    required this.dateTime,
    this.repeat = 'Does not repeat',
    this.remindMinutesBefore = 10,
    this.sharedWith = const [],
    this.done = false,
  });

  Reminder copyWith({bool? done}) {
    return Reminder(
      id: id,
      title: title,
      notes: notes,
      dateTime: dateTime,
      repeat: repeat,
      remindMinutesBefore: remindMinutesBefore,
      sharedWith: sharedWith,
      done: done ?? this.done,
    );
  }
}
