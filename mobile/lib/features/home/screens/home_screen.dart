import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';
import '../../attendance/providers/attendance_provider.dart';
import '../../attendance/widgets/punch_in_widget.dart';
import '../../salary/providers/payslips_provider.dart';
import '../../../shared/widgets/portal_header.dart';
import '../../../shared/widgets/section_header.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback? onOpenProfile;
  final VoidCallback? onOpenSalary;
  final VoidCallback? onOpenLeave;

  const HomeScreen({
    super.key,
    this.onOpenProfile,
    this.onOpenSalary,
    this.onOpenLeave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final attendanceState = ref.watch(attendanceProvider);
    final payslipsState = ref.watch(payslipsProvider);

    final today = DateTime.now();
    final dateLabel = DateFormat('EEEE, MMMM d').format(today);

    final clockIn = attendanceState.todayAttendance?.punchIn;
    final clockOut = attendanceState.todayAttendance?.punchOut;

    String fmtTime(DateTime? dt) =>
        dt == null ? '--:--' : DateFormat('hh:mm a').format(dt);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.read(attendanceProvider.notifier).fetchToday(),
            ref.read(payslipsProvider.notifier).fetchMyPayslips(),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            PortalHeader(onProfileTap: onOpenProfile),
            const SizedBox(height: 16),
            Text(
              'Welcome! Refreshing Monday.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Great companies are built by great people.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Today's overview card
            Card(
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.tertiary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Today's Overview",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          fmtTime(clockIn),
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary.withValues(alpha: 220),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('d MMM, y').format(today),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 210),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _OverviewTime(
                            label: 'Clock In',
                            value: fmtTime(clockIn),
                            onPrimary: colorScheme.onPrimary,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 44,
                          color: colorScheme.onPrimary.withValues(alpha: 70),
                        ),
                        Expanded(
                          child: _OverviewTime(
                            label: 'Clock Out',
                            value: fmtTime(clockOut),
                            onPrimary: colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Attendance action widget
            const PunchInWidget(),

            const SizedBox(height: 20),

            SectionHeader(
              title: 'Payslip',
              actionLabel: 'See all',
              onAction: onOpenSalary,
            ),
            const SizedBox(height: 10),
            _PayslipPreviewCard(
              isLoading: payslipsState.isLoading,
              error: payslipsState.error,
              payslip: payslipsState.latest,
            ),

            const SizedBox(height: 20),

            SectionHeader(
              title: "What's up Today",
              actionLabel: 'See all',
              onAction: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tasks & reviews coming soon.')),
                );
              },
            ),
            const SizedBox(height: 10),
            _SimpleListCard(
              items: const [
                _SimpleItem(
                  title: 'Performance Review',
                  subtitle: '10:00 AM - 10:30 AM',
                  icon: Icons.stars_rounded,
                ),
                _SimpleItem(
                  title: 'Team Standup',
                  subtitle: '11:00 AM - 11:15 AM',
                  icon: Icons.groups_rounded,
                ),
              ],
            ),

            const SizedBox(height: 20),

            SectionHeader(
              title: 'Leave balance',
              actionLabel: 'Apply',
              onAction: onOpenLeave,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Casual',
                    value: '8',
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricTile(
                    label: 'Sick',
                    value: '5',
                    color: colorScheme.tertiary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricTile(
                    label: 'Earned',
                    value: '12',
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SectionHeader(
              title: 'Upcoming holidays',
              actionLabel: dateLabel,
            ),
            const SizedBox(height: 10),
            _SimpleListCard(
              items: const [
                _SimpleItem(
                  title: 'Public Holiday',
                  subtitle: 'Next Friday',
                  icon: Icons.celebration_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewTime extends StatelessWidget {
  final String label;
  final String value;
  final Color onPrimary;

  const _OverviewTime({
    required this.label,
    required this.value,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: onPrimary.withValues(alpha: 210),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: onPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _PayslipPreviewCard extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final PayslipModel? payslip;

  const _PayslipPreviewCard({
    required this.isLoading,
    required this.error,
    required this.payslip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentPayslip = payslip;

    if (isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Loading payslip...'),
            ],
          ),
        ),
      );
    }

    if (error != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: colorScheme.error),
              const SizedBox(width: 12),
              Expanded(child: Text(error!)),
            ],
          ),
        ),
      );
    }

    if (currentPayslip == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No payslips yet.'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentPayslip.periodFormatted,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Net salary: ${currentPayslip.netSalary.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.color,
  });

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
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.circle,
                    size: 14,
                    color: color,
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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

class _SimpleListCard extends StatelessWidget {
  final List<_SimpleItem> items;

  const _SimpleListCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(items[i].icon, color: colorScheme.primary),
              ),
              title: Text(
                items[i].title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                items[i].subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(Icons.more_vert_rounded),
              onTap: () {},
            ),
            if (i != items.length - 1)
              Divider(height: 1, color: colorScheme.outlineVariant),
          ],
        ],
      ),
    );
  }
}

class _SimpleItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SimpleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
