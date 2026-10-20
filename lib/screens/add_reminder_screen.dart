import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reminder.dart';
import '../providers/reminder_provider.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  static const _people = ['Scott', 'Jared', 'Ate Jovis'];
  static const _repeatOptions = [
    'Does not repeat',
    'Every day',
    'Weekdays',
    'Every week',
  ];
  static const _remindOptions = [0, 5, 10, 15, 30, 60];

  final _titleCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  late DateTime _date;
  late TimeOfDay _time;
  String _repeat = 'Does not repeat';
  int _remindBefore = 10;
  final Set<String> _shared = {};

  @override
  void initState() {
    super.initState();
    final soon = DateTime.now().add(const Duration(hours: 1));
    _date = DateTime(soon.year, soon.month, soon.day);
    _time = TimeOfDay(hour: soon.hour, minute: 0);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String _remindLabel(int minutes) {
    if (minutes == 0) return 'At time of reminder';
    if (minutes == 60) return '1 hour before';
    return '$minutes min before';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null && mounted) setState(() => _time = picked);
  }

  Future<T?> _pickOption<T>(
    String title,
    List<T> options,
    String Function(T) labelOf,
  ) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: AppTheme.heading(size: 18)),
              ),
            ),
            for (final o in options)
              ListTile(
                title: Text(labelOf(o)),
                onTap: () => Navigator.pop(ctx, o),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickRepeat() async {
    final picked = await _pickOption<String>(
      'Repeat',
      _repeatOptions,
      (s) => s,
    );
    if (picked != null && mounted) setState(() => _repeat = picked);
  }

  Future<void> _pickRemind() async {
    final picked = await _pickOption<int>(
      'Remind me',
      _remindOptions,
      _remindLabel,
    );
    if (picked != null && mounted) setState(() => _remindBefore = picked);
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Give your reminder a title first.')),
      );
      return;
    }

    final when = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );

    context.read<ReminderProvider>().add(
      Reminder(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        notes: _notesCtrl.text.trim(),
        dateTime: when,
        repeat: _repeat,
        remindMinutesBefore: _remindBefore,
        sharedWith: _shared.toList(),
      ),
    );

    Navigator.of(context).pop();
  }

  InputDecoration _decoration(String hint) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.primary),
      border: border(AppColors.border),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: AppColors.textBody,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pickedTime = DateTime(2000, 1, 1, _time.hour, _time.minute);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    color: AppColors.textBody,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add reminder', style: AppTheme.heading(size: 24)),
                      const Text(
                        'Make room for what matters.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('TITLE'),
                    TextField(
                      controller: _titleCtrl,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: _decoration('e.g. Pack materials for NSTP'),
                    ),
                    _label('NOTES'),
                    TextField(
                      controller: _notesCtrl,
                      minLines: 3,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: _decoration('Anything you want to remember'),
                    ),
                    _label('DATE & TIME'),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _PickerBox(
                            icon: Icons.calendar_today_outlined,
                            text:
                                '${relativeDay(_date)}, ${formatShortDate(_date)}',
                            onTap: _pickDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: _PickerBox(
                            icon: Icons.access_time,
                            text: formatTime(pickedTime),
                            onTap: _pickTime,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          _OptionRow(
                            icon: Icons.repeat,
                            label: 'Repeat',
                            value: _repeat,
                            onTap: _pickRepeat,
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _OptionRow(
                            icon: Icons.notifications_none,
                            label: 'Remind me',
                            value: _remindLabel(_remindBefore),
                            onTap: _pickRemind,
                          ),
                        ],
                      ),
                    ),
                    _label('SHARE WITH'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final p in _people)
                          _PersonChoice(
                            name: p,
                            selected: _shared.contains(p),
                            onTap: () => setState(() {
                              if (!_shared.add(p)) _shared.remove(p);
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'People you pick can view and complete this reminder. Only you can edit or delete it.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Save button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _save,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Save reminder'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _PickerBox({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textBody),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: AppColors.textBody),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _OptionRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textBody),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.brown800,
              ),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonChoice extends StatelessWidget {
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const _PersonChoice({
    required this.name,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.surfaceSoft : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.surfaceSoft,
                shape: BoxShape.circle,
              ),
              child: Text(
                name[0],
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBody,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.brown800,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.check, size: 16, color: AppColors.primary),
            ],
          ],
        ),
      ),
    );
  }
}
