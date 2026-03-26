import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/team_attendance_provider.dart';

class AttendanceAdminScreen extends ConsumerWidget {
  const AttendanceAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(teamAttendanceProvider);

    Future<void> pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: state.date,
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (picked != null) {
        await ref.read(teamAttendanceProvider.notifier).fetch(date: picked);
      }
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final header = [
              Expanded(
                flex: isMobile ? 0 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View team attendance for a date.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isMobile) const SizedBox(height: 16),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: state.isLoading ? null : pickDate,
                    icon: const Icon(Icons.calendar_month_rounded),
                    label: Text(DateFormat('MMM d, y').format(state.date)),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    tooltip: 'Refresh',
                    onPressed: state.isLoading
                        ? null
                        : () {
                            ref.read(teamAttendanceProvider.notifier).fetch();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Refreshing attendance data...')),
                            );
                          },
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
            ];
            return isMobile ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: header) : Row(children: header);
          }
        ),
        const SizedBox(height: 16),
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              state.error!,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.error),
            ),
          ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: state.isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : state.records.isEmpty
                    ? Text(
                        'No attendance records for this date.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Column(
                        children: state.records.map((a) {
                          final name = a.employeeName ?? a.employeeId;
                          final code = a.employeeCode;
                          final timeRange =
                              '${DateFormat('HH:mm').format(a.punchIn)} → ${a.punchOut != null ? DateFormat('HH:mm').format(a.punchOut!) : '—'}';

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        code == null ? name : '$name ($code)',
                                        style:
                                            theme.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        a.departmentName ?? '—',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      timeRange,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      a.workedHoursFormatted,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
          ),
        ),
      ],
    );
  }
}
