import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/reminder.dart';
import '../repositories/reminder_repository.dart';

class ReminderProvider extends ChangeNotifier {
  ReminderProvider(this._repo);

  final ReminderRepository _repo;
  StreamSubscription<List<Reminder>>? _sub;

  List<Reminder> _items = [];
  bool _loading = true;
  Object? _error;

  bool get loading => _loading;
  Object? get error => _error;

  /// Start listening for this user's reminders.
  /// Call again (e.g. after login) to switch users.
  void listen(String userId) {
    _sub?.cancel();
    _loading = true;
    _sub = _repo
        .watch(userId)
        .listen(
          (list) {
            _items = list;
            _loading = false;
            _error = null;
            notifyListeners();
          },
          onError: (Object e) {
            _error = e;
            _loading = false;
            notifyListeners();
          },
        );
  }

  /// Active or snoozed reminders, soonest first.
  List<Reminder> get upcoming {
    final list =
        _items
            .where((r) => r.status == 'active' || r.status == 'snoozed')
            .toList()
          ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return list;
  }

  /// Reminders that are done, newest first.
  List<Reminder> get completed {
    final list = _items.where((r) => r.status == 'completed').toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  String newId() => _repo.newId();

  /// Not awaited by the UI: with Firestore the local write is instant and the
  /// snapshot listener updates the list, even when offline.
  Future<void> add(Reminder reminder) => _repo.save(reminder);

  Future<void> setStatus(String id, String status) async {
    final i = _items.indexWhere((r) => r.id == id);
    if (i == -1) return;
    await _repo.save(
      _items[i].copyWith(status: status, updatedAt: DateTime.now()),
    );
  }

  /// Checkbox on Home: active <-> completed.
  Future<void> toggleDone(String id) async {
    final i = _items.indexWhere((r) => r.id == id);
    if (i == -1) return;
    final next = _items[i].status == 'completed' ? 'active' : 'completed';
    await setStatus(id, next);
  }

  Future<void> remove(String id) => _repo.delete(id);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
