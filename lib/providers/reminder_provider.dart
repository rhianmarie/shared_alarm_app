import 'package:flutter/foundation.dart';

import '../models/reminder.dart';

class ReminderProvider extends ChangeNotifier {
  final List<Reminder> _items = [];

  ReminderProvider() {
    _seed();
  }

  /// Not-done reminders, soonest first.
  List<Reminder> get upcoming {
    final list = _items.where((r) => !r.done).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  void add(Reminder reminder) {
    _items.add(reminder);
    notifyListeners();
  }

  void toggleDone(String id) {
    final i = _items.indexWhere((r) => r.id == id);
    if (i == -1) return;
    _items[i] = _items[i].copyWith(done: !_items[i].done);
    notifyListeners();
  }

  // Sample data so Home isn't empty. Delete this once saving to storage works.
  void _seed() {
    final now = DateTime.now();
    _items.addAll([
      Reminder(
        id: 's1',
        title: 'Task 1 — Submit Report',
        notes: 'Finalize and submit the midterm project report to the class portal before deadline.',
        dateTime: now.add(const Duration(minutes: 26)),
        sharedWith: const ['Scott'],
      ),
      Reminder(
        id: 's2',
        title: 'Review Flutter Layout',
        dateTime: now.add(const Duration(hours: 2)),
        sharedWith: const ['Jared'],
      ),
      Reminder(
        id: 's3',
        title: 'NSTP Class Prep',
        dateTime: DateTime(now.year, now.month, now.day + 1, 6, 0),
        sharedWith: const ['Scott'],
      ),
    ]);
  }
}
