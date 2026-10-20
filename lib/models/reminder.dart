/// A reminder / alarm. Field names match the Firestore `alarms` schema.
/// Plain Dart on purpose (no Firebase imports) so the UI builds without it.
/// Jared's repository converts to/from Firestore Timestamps.
class Reminder {
  final String id;
  final String title;
  final String description;
  final String ttsText; // exact text spoken when the alarm fires
  final DateTime scheduledTime;
  final int preNotifyMinutes; // 0 = no heads-up
  final String createdBy; // userId of the VA who created it
  final String assignedTo; // userId of the person who receives it
  final String status; // active | completed | snoozed | cancelled
  final String repeat; // none | daily | weekly | custom
  final DateTime createdAt;
  final DateTime updatedAt;

  const Reminder({
    required this.id,
    required this.title,
    this.description = '',
    required this.ttsText,
    required this.scheduledTime,
    this.preNotifyMinutes = 5,
    required this.createdBy,
    required this.assignedTo,
    this.status = 'active',
    this.repeat = 'none',
    required this.createdAt,
    required this.updatedAt,
  });

  Reminder copyWith({
    String? title,
    String? description,
    String? ttsText,
    DateTime? scheduledTime,
    int? preNotifyMinutes,
    String? createdBy,
    String? assignedTo,
    String? status,
    String? repeat,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Reminder(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      ttsText: ttsText ?? this.ttsText,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      preNotifyMinutes: preNotifyMinutes ?? this.preNotifyMinutes,
      createdBy: createdBy ?? this.createdBy,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      repeat: repeat ?? this.repeat,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
