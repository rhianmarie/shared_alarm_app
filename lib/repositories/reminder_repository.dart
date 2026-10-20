import 'dart:async';

import '../models/reminder.dart';

/// The provider talks to this, never to storage directly.
/// Jared will add FirestoreReminderRepository implementing the same interface.
abstract class ReminderRepository {
  /// Emits the full list now and again after every change.
  Stream<List<Reminder>> watch(String userId);

  /// Create or update.
  Future<void> save(Reminder reminder);

  Future<void> delete(String id);

  /// New unique id for a reminder.
  String newId();
}

/// Temporary, until the Firestore repository is ready.
class InMemoryReminderRepository implements ReminderRepository {
  InMemoryReminderRepository();

  InMemoryReminderRepository.seeded() {
    _seed();
  }

  final Map<String, Reminder> _items = {};
  final _controller = StreamController<List<Reminder>>.broadcast();

  void _emit() => _controller.add(_items.values.toList());

  @override
  Stream<List<Reminder>> watch(String userId) async* {
    yield _items.values.toList();
    yield* _controller.stream;
  }

  @override
  Future<void> save(Reminder reminder) async {
    _items[reminder.id] = reminder;
    _emit();
  }

  @override
  Future<void> delete(String id) async {
    _items.remove(id);
    _emit();
  }

  @override
  String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  // Sample data so Home isn't empty. Remove once Firestore is connected.
  void _seed() {
    const userId = 'local-user';
    final now = DateTime.now();

    Reminder make({
      required String id,
      required String title,
      String description = '',
      required DateTime when,
    }) {
      return Reminder(
        id: id,
        title: title,
        description: description,
        ttsText: title,
        scheduledTime: when,
        createdBy: userId,
        assignedTo: userId,
        createdAt: now,
        updatedAt: now,
      );
    }

    final seeds = [
      make(
        id: 's1',
        title: 'Task 1 — Submit Report',
        description: 'Finalize and submit the midterm project report to the class portal before deadline.',
        when: now.add(const Duration(minutes: 26)),
      ),
      make(
        id: 's2',
        title: 'Review Flutter Layout',
        when: now.add(const Duration(hours: 2)),
      ),
      make(
        id: 's3',
        title: 'NSTP Class Prep',
        when: DateTime(now.year, now.month, now.day + 1, 6, 0),
      ),
    ];

    for (final r in seeds) {
      _items[r.id] = r;
    }
  }
}
