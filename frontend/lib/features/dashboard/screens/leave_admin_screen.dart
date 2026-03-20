import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/team_leaves_provider.dart';

class LeaveAdminScreen extends ConsumerWidget {
  const LeaveAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(teamLeavesProvider);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leave Requests',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Approve or reject team leave requests.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              tooltip: 'Refresh',
              onPressed: state.isLoading
                  ? null
                  : () => ref.read(teamLeavesProvider.notifier).fetchTeamLeaves(),
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
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
        if (state.isLoading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (state.leaves.isEmpty)
          Text(
            'No leave requests found.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          )
        else
          ...state.leaves.map((leave) {
            final subtitle =
                '${DateFormat('MMM d, y').format(leave.startDate)} → ${DateFormat('MMM d, y').format(leave.endDate)} • ${leave.totalDays} day(s)';

            Color chipBg;
            Color chipFg;
            switch (leave.status) {
              case 'APPROVED':
                chipBg = colorScheme.primaryContainer;
                chipFg = colorScheme.onPrimaryContainer;
                break;
              case 'REJECTED':
                chipBg = colorScheme.errorContainer;
                chipFg = colorScheme.onErrorContainer;
                break;
              default:
                chipBg = colorScheme.surfaceContainerHighest;
                chipFg = colorScheme.onSurfaceVariant;
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${leave.employeeName ?? 'Employee'} (${leave.employeeCode ?? '-'})',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: chipBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            leave.status,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: chipFg,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${leave.leaveType} • ${leave.departmentName ?? '—'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (leave.reason.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        leave.reason,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (leave.isPending) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () => ref
                                .read(teamLeavesProvider.notifier)
                                .approve(leave.id),
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('Approve'),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton.icon(
                            onPressed: () => ref
                                .read(teamLeavesProvider.notifier)
                                .reject(leave.id),
                            icon: const Icon(Icons.close_rounded),
                            label: const Text('Reject'),
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
