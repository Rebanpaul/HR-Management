import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../attendance/providers/attendance_history_provider.dart';
import '../../../shared/widgets/portal_header.dart';
import '../../../shared/widgets/section_header.dart';

class LeaveAttendanceScreen extends ConsumerStatefulWidget {
  final VoidCallback? onOpenProfile;

  const LeaveAttendanceScreen({
    super.key,
    this.onOpenProfile,
  });

  @override
  ConsumerState<LeaveAttendanceScreen> createState() =>
      _LeaveAttendanceScreenState();
}

class _LeaveAttendanceScreenState extends ConsumerState<LeaveAttendanceScreen> {
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final history = ref.watch(attendanceHistoryProvider);
    final record = history.recordForDate(_selected);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          PortalHeader(onProfileTap: widget.onOpenProfile),
          const SizedBox(height: 16),
          Text(
            'Leave & Attendance',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Balance, holidays, and daily attendance view.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          SectionHeader(
            title: 'Leave balance',
            actionLabel: 'Apply',
            onAction: () => _showApplyLeave(context),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _BalanceChip(label: 'Casual', value: '8'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BalanceChip(label: 'Sick', value: '5'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BalanceChip(label: 'Earned', value: '12'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SectionHeader(
            title: 'Holidays',
            actionLabel: 'View',
            onAction: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Holiday list coming soon.')),
              );
            },
          ),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              leading: Icon(Icons.celebration_rounded),
              title: Text('Public Holiday'),
              subtitle: Text('Next Friday'),
            ),
          ),

          const SizedBox(height: 20),

          SectionHeader(
            title: 'Attendance calendar',
            actionLabel: 'Refresh',
            onAction: () => ref.read(attendanceHistoryProvider.notifier).fetch(),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CalendarDatePicker(
                initialDate: _selected,
                firstDate: DateTime(DateTime.now().year - 1),
                lastDate: DateTime(DateTime.now().year + 1),
                onDateChanged: (d) => setState(() => _selected = d),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, MMM d, y').format(_selected),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (history.isLoading)
                    const Row(
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Loading attendance...'),
                      ],
                    )
                  else if (history.error != null)
                    Row(
                      children: [
                        Icon(Icons.error_outline, color: colorScheme.error),
                        const SizedBox(width: 12),
                        Expanded(child: Text(history.error!)),
                      ],
                    )
                  else if (record == null)
                    Text(
                      'No attendance record for this day.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: _TimeField(
                            label: 'Clock In',
                            value: DateFormat('hh:mm a').format(record.punchIn),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _TimeField(
                            label: 'Clock Out',
                            value: record.punchOut == null
                                ? '--:--'
                                : DateFormat('hh:mm a')
                                    .format(record.punchOut!),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showApplyLeave(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    DateTime? start;
    DateTime? end;
    final reasonController = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apply Leave',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              _DatePickTile(
                label: 'Start date',
                value: start,
                onPick: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime(DateTime.now().year + 1),
                    initialDate: start ?? DateTime.now(),
                  );
                  if (picked != null) {
                    start = picked;
                    // Refresh sheet
                    (context as Element).markNeedsBuild();
                  }
                },
              ),
              _DatePickTile(
                label: 'End date',
                value: end,
                onPick: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: start ?? DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                    initialDate: end ?? (start ?? DateTime.now()),
                  );
                  if (picked != null) {
                    end = picked;
                    (context as Element).markNeedsBuild();
                  }
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason',
                  hintText: 'Optional',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Leave request submitted (API wiring coming soon).',
                        ),
                        backgroundColor: colorScheme.primary,
                      ),
                    );
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        );
      },
    );

    reasonController.dispose();
  }
}

class _BalanceChip extends StatelessWidget {
  final String label;
  final String value;

  const _BalanceChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  final String label;
  final String value;

  const _TimeField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DatePickTile extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onPick;

  const _DatePickTile({
    required this.label,
    required this.value,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        value == null ? 'Select date' : DateFormat('d MMM, y').format(value!),
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.calendar_month_rounded),
      onTap: onPick,
    );
  }
}
