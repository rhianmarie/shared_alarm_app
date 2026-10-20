import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reminder.dart';
import '../providers/reminder_provider.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const _Header(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _PeopleRail(),
                Expanded(child: _Feed()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Header ----------

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_none,
            size: 18,
            color: AppColors.textMuted,
          ),
          const SizedBox(width: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Remind ',
                  style: AppTheme.heading(size: 22, weight: FontWeight.w600),
                ),
                TextSpan(
                  text: 'Me',
                  style: AppTheme.heading(size: 22, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Left rail of people ----------
// TODO: placeholder. Replace with the linked account (UserProvider) once
// account linking is built (Sprint 4).

class _PeopleRail extends StatelessWidget {
  const _PeopleRail();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 64,
      child: Padding(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            _PersonChip(initial: 'M', label: 'You', selected: true),
            _PersonChip(initial: 'S', label: 'Scott'),
            _PersonChip(initial: 'J', label: 'Jared'),
            _PersonChip(initial: 'AJ', label: 'Ate J'),
            _PersonChip(initial: '', label: 'Add', isAdd: true),
          ],
        ),
      ),
    );
  }
}

class _PersonChip extends StatelessWidget {
  final String initial;
  final String label;
  final bool selected;
  final bool isAdd;

  const _PersonChip({
    required this.initial,
    required this.label,
    this.selected = false,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(12),
              border: isAdd ? Border.all(color: AppColors.border) : null,
            ),
            child: isAdd
                ? const Icon(Icons.add, size: 18, color: AppColors.textBody)
                : Text(
                    initial,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.textBody,
                    ),
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

// ---------- Main feed ----------

String _groupLabel(DateTime d) {
  final day = relativeDay(d);
  if (day == 'Today') return 'LATER TODAY';
  final date = '${weekdayShort(d)}, ${formatShortDate(d)}'.toUpperCase();
  return day == 'Tomorrow' ? 'TOMORROW · $date' : date;
}

/// Who a reminder involves. Names come later, once users have display names.
String _whoLabel(Reminder r) =>
    r.createdBy == r.assignedTo ? 'Just you' : 'Shared reminder';

class _Feed extends StatelessWidget {
  const _Feed();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReminderProvider>();

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Couldn’t load your reminders. Try again in a moment.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
      );
    }

    final upcoming = provider.upcoming;
    final next = upcoming.isEmpty ? null : upcoming.first;
    final rest = upcoming.length > 1 ? upcoming.sublist(1) : <Reminder>[];

    // Group the remaining reminders by day, keeping the order.
    final groups = <String, List<Reminder>>{};
    for (final r in rest) {
      groups.putIfAbsent(_groupLabel(r.scheduledTime), () => []).add(r);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(4, 16, 16, 24),
      children: [
        _SectionLabel(
          'NEXT TASK',
          trailing: next == null
              ? null
              : '${relativeDay(next.scheduledTime)} · ${weekdayShort(next.scheduledTime)}, ${formatShortDate(next.scheduledTime)}',
        ),
        const SizedBox(height: 8),
        if (next == null) const _EmptyCard() else _NextTaskCard(reminder: next),
        const SizedBox(height: 12),
        const _QuoteBox(),
        for (final entry in groups.entries) ...[
          const SizedBox(height: 20),
          _SectionLabel(entry.key),
          const SizedBox(height: 8),
          for (final r in entry.value) ...[
            _ReminderTile(reminder: r),
            const SizedBox(height: 8),
          ],
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final String? trailing;

  const _SectionLabel(this.text, {this.trailing});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
      color: AppColors.textMuted,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: style),
        if (trailing != null)
          Text(
            trailing!,
            style: style.copyWith(
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
          ),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text('Nothing coming up', style: AppTheme.heading(size: 17)),
          const SizedBox(height: 6),
          const Text(
            'Tap the + button to add a reminder.',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _NextTaskCard extends StatelessWidget {
  final Reminder reminder;

  const _NextTaskCard({required this.reminder});

  @override
  Widget build(BuildContext context) {
    final who = _whoLabel(reminder).toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  who,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const Icon(
                Icons.north_east,
                size: 14,
                color: AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: formatClock(reminder.scheduledTime),
                  style: AppTheme.heading(size: 34),
                ),
                TextSpan(
                  text: ' ${formatPeriod(reminder.scheduledTime)}',
                  style: AppTheme.heading(size: 14, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(reminder.title, style: AppTheme.heading(size: 17)),
          if (reminder.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              reminder.description,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: AppColors.textBody,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time,
                  size: 13,
                  color: AppColors.textBody,
                ),
                const SizedBox(width: 5),
                Text(
                  remainingText(reminder.scheduledTime),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textBody,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuoteBox extends StatelessWidget {
  const _QuoteBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '“Small steps every day lead to big results.”',
            style: AppTheme.heading(
              size: 12,
              color: AppColors.textBody,
            ).copyWith(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 4),
          // TODO: use the signed-in user's display name instead of "Marie".
          const Text(
            '— keep going, Marie ♡',
            style: TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  final Reminder reminder;

  const _ReminderTile({required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              formatTime(reminder.scheduledTime),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reminder.title, style: AppTheme.heading(size: 13)),
                const SizedBox(height: 2),
                Text(
                  _whoLabel(reminder),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () =>
                context.read<ReminderProvider>().toggleDone(reminder.id),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
