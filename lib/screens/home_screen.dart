import 'package:flutter/material.dart';

import '../models/reminder.dart';
import '../theme/app_theme.dart';

// Fake data for now. We'll replace it with real data later.
const _tonight = [
  Reminder(
    time: '10:00 PM',
    title: 'Review Flutter Layout',
    sharedWith: 'Jared',
  ),
  Reminder(
    time: '11:30 PM',
    title: 'Post IG Carousel',
    sharedWith: 'Ate Jovis',
  ),
];

const _tomorrow = [
  Reminder(time: '6:00 AM', title: 'NSTP Class Prep', sharedWith: 'Scott'),
];

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

class _Feed extends StatelessWidget {
  const _Feed();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(4, 16, 16, 24),
      children: [
        const _SectionLabel('NEXT TASK', trailing: 'Today · Thu, Oct 15'),
        const SizedBox(height: 8),
        const _NextTaskCard(),
        const SizedBox(height: 12),
        const _QuoteBox(),
        const SizedBox(height: 20),
        const _SectionLabel('UPCOMING · TONIGHT'),
        const SizedBox(height: 8),
        for (final r in _tonight) ...[
          _ReminderTile(reminder: r),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 12),
        const _SectionLabel('TOMORROW · FRI, OCT 16'),
        const SizedBox(height: 8),
        for (final r in _tomorrow) ...[
          _ReminderTile(reminder: r),
          const SizedBox(height: 8),
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

class _NextTaskCard extends StatelessWidget {
  const _NextTaskCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SHARED WITH SCOTT',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: AppColors.textMuted,
                ),
              ),
              Icon(Icons.north_east, size: 14, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '9:30', style: AppTheme.heading(size: 34)),
                TextSpan(
                  text: ' PM',
                  style: AppTheme.heading(size: 14, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text('Task 1 — Submit Report', style: AppTheme.heading(size: 17)),
          const SizedBox(height: 6),
          const Text(
            'Finalize and submit the midterm project report to the class portal before deadline.',
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: AppColors.textBody,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time, size: 13, color: AppColors.textBody),
                SizedBox(width: 5),
                Text(
                  '26 min remaining',
                  style: TextStyle(fontSize: 10, color: AppColors.textBody),
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
            width: 52,
            child: Text(
              reminder.time,
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
                  'Shared with ${reminder.sharedWith}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
