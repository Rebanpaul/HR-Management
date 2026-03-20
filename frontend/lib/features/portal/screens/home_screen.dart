import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/attendance_provider.dart';
import '../../../core/theme/app_theme.dart';

class PortalHomeScreen extends ConsumerWidget {
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenSalary;
  final VoidCallback onOpenLeave;

  const PortalHomeScreen({
    super.key,
    required this.onOpenProfile,
    required this.onOpenSalary,
    required this.onOpenLeave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authProvider).user;
    final attendance = ref.watch(attendanceProvider);

    final greetingName = user?.employee?.firstName ?? 'there';

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(attendanceProvider.notifier).fetchToday();
      },
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Text(
            'Welcome, $greetingName 👋',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s what\'s happening across your organization.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          // ─ Metric Summary Cards ────────────────────────────
          _MetricsGrid(items: const [
            _MetricItem(
              title: 'Total Employees',
              value: '--',
              subtitle: 'Connect backend to load.',
              icon: Icons.people_alt_rounded,
              emphasized: true,
            ),
            _MetricItem(
              title: 'Present Today',
              value: '--',
              subtitle: 'Attendance data loads on connect.',
              icon: Icons.check_circle_rounded,
            ),
            _MetricItem(
              title: 'Pending Leaves',
              value: '--',
              subtitle: 'Leave requests awaiting approval.',
              icon: Icons.pending_actions_rounded,
            ),
            _MetricItem(
              title: 'Departments',
              value: '--',
              subtitle: 'Active departments in organization.',
              icon: Icons.business_rounded,
            ),
          ]),

          const SizedBox(height: 20),

          // ─ Two-column layout ───────────────────────────────
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 1100;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth * 0.58)
                        : constraints.maxWidth,
                    child: _AttendanceStatusCard(attendance: attendance),
                  ),
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth * 0.40)
                        : constraints.maxWidth,
                    child: const _QuickActionsCard(),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // ─ Recent Activity ─────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 40,
                            color: colorScheme.onSurfaceVariant.withOpacity(0.3),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Activity feed will populate once the backend is connected.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Internal widgets
// ─────────────────────────────────────────────────────────────

class _MetricItem {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final bool emphasized;

  const _MetricItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.emphasized = false,
  });
}

class _MetricsGrid extends StatelessWidget {
  final List<_MetricItem> items;
  const _MetricsGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 1100
            ? 4
            : (constraints.maxWidth >= 720 ? 2 : 1);
        return GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: crossAxisCount == 1 ? 2.8 : 2.4,
          ),
          itemBuilder: (context, i) => _MetricCard(item: items[i]),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final _MetricItem item;
  const _MetricCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bg = item.emphasized
        ? AppTheme.brandPrimary
        : colorScheme.surfaceContainerHighest;
    final fg = item.emphasized ? Colors.white : colorScheme.onSurface;
    final subFg = item.emphasized
        ? Colors.white70
        : colorScheme.onSurfaceVariant;

    return Card(
      color: bg,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: item.emphasized
                        ? Colors.white.withOpacity(0.15)
                        : colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    size: 18,
                    color: item.emphasized
                        ? Colors.white
                        : colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              item.value,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: subFg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceStatusCard extends StatelessWidget {
  final AttendanceState attendance;
  const _AttendanceStatusCard({required this.attendance});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Attendance',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            if (attendance.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 40,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.3),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Connect to backend API to see live attendance data.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final actions = [
      ('Approve Leaves', Icons.task_alt_rounded, AppTheme.brandPrimary),
      ('Create Payslip', Icons.receipt_long_rounded, AppTheme.brandAccent),
      ('Add Employee', Icons.person_add_rounded, AppTheme.brandTeal),
      ('View Reports', Icons.analytics_rounded, Colors.orange),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            ...actions.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${a.$1} — coming soon.')),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: a.$3.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: a.$3.withOpacity(0.12)),
                    ),
                    child: Row(
                      children: [
                        Icon(a.$2, size: 20, color: a.$3),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            a.$1,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: a.$3,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: a.$3.withOpacity(0.5)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
