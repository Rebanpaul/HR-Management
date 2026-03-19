import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/attendance_provider.dart';
import '../providers/payslips_provider.dart';

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
    final payslips = ref.watch(payslipsProvider);

    ref.listen(attendanceProvider, (prev, next) {
      final msg = next.successMessage;
      if (msg != null && msg.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
      final err = next.error;
      if (err != null && err.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      }
    });

    ref.listen(payslipsProvider, (prev, next) {
      final err = next.error;
      if (err != null && err.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      }
    });

    final greetingName = user?.employee?.firstName ?? 'Employee';

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          ref.read(attendanceProvider.notifier).fetchToday(),
          ref.read(payslipsProvider.notifier).fetchMyPayslips(),
        ]);
      },
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Text(
            'Welcome, $greetingName',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ready to manage your HR tasks today?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _MetricsGrid(
            items: [
              _MetricItem(
                title: 'Total Employees',
                value: '245',
                subtitle: 'The total number of active employees currently in the company.',
                icon: Icons.people_alt_rounded,
                emphasized: true,
              ),
              _MetricItem(
                title: 'New Hires',
                value: '4',
                subtitle: 'The number of new employees in the current month.',
                icon: Icons.person_add_alt_1_rounded,
              ),
              _MetricItem(
                title: 'Average Tenure',
                value: '2.3 yr',
                subtitle: 'The average length of time employees joined the company.',
                icon: Icons.timeline_rounded,
              ),
              _MetricItem(
                title: 'Probation',
                value: '5',
                subtitle: 'The number of employees currently in their probation period.',
                icon: Icons.assignment_turned_in_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 1100;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth * 0.46)
                        : constraints.maxWidth,
                    child: const _BestEmployeeCard(),
                  ),
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth * 0.26)
                        : constraints.maxWidth,
                    child: const _WorkedHoursCard(),
                  ),
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth * 0.26)
                        : constraints.maxWidth,
                    child: const _TodayScheduleCard(),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 1100;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth * 0.62)
                        : constraints.maxWidth,
                    child: const _OnboardingTaskCard(),
                  ),
                  SizedBox(
                    width: isWide
                        ? (constraints.maxWidth * 0.36)
                        : constraints.maxWidth,
                    child: _ShortcutCard(
                      onOpenSalary: onOpenSalary,
                      onOpenLeave: onOpenLeave,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                attendance.isLoading || payslips.isLoading
                    ? 'Loading your attendance and payslip data…'
                    : 'Tip: Pull to refresh to fetch attendance and payslips.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
          itemBuilder: (context, i) {
            return _MetricCard(item: items[i]);
          },
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
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;
    final fg = item.emphasized ? colorScheme.onPrimary : colorScheme.onSurface;
    final subFg = item.emphasized
        ? colorScheme.onPrimary.withValues(alpha: 200)
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
                        ? colorScheme.onPrimary.withValues(alpha: 18)
                        : colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    size: 18,
                    color: item.emphasized
                        ? colorScheme.onPrimary
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

class _BestEmployeeCard extends StatelessWidget {
  const _BestEmployeeCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                    'Best Employee',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'This Month',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          size: 18, color: colorScheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 64,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rachel Johnson',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Marketing Director',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(label: 'Average Work Time', value: '4.2 Years'),
                      _InfoRow(label: 'Phone', value: '(406) 555-0120'),
                      _InfoRow(label: 'Email', value: 'r.johnson@mail.com'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkedHoursCard extends StatelessWidget {
  const _WorkedHoursCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Worked Hours',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 92,
              child: CustomPaint(
                painter: _SparklinePainter(
                  lineColor: colorScheme.primary,
                  fillColor: colorScheme.primary.withValues(alpha: 36),
                ),
                child: const SizedBox.expand(),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Current Pay Period',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '134h 21m',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'This pay period: Apr 31 – May 15',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: colorScheme.outlineVariant),
            const SizedBox(height: 12),
            Text(
              'Previous Pay Period',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '110h 12m',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Prev pay period: Apr 16 – Apr 30',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final Color lineColor;
  final Color fillColor;

  _SparklinePainter({
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const values = <double>[
      0.25,
      0.35,
      0.28,
      0.45,
      0.42,
      0.55,
      0.50,
      0.62,
      0.58,
      0.72,
      0.64,
      0.70,
      0.60,
      0.68,
      0.65,
    ];

    final stepX = size.width / (values.length - 1);

    final line = Path();
    for (var i = 0; i < values.length; i++) {
      final x = stepX * i;
      final y = size.height - (values[i] * size.height);
      if (i == 0) {
        line.moveTo(x, y);
      } else {
        line.lineTo(x, y);
      }
    }

    final fill = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(fill, fillPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(line, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}

class _TodayScheduleCard extends StatefulWidget {
  const _TodayScheduleCard();

  @override
  State<_TodayScheduleCard> createState() => _TodayScheduleCardState();
}

class _TodayScheduleCardState extends State<_TodayScheduleCard> {
  int _selectedDay = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                    "Today's Schedule",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('3 Schedule'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: List.generate(5, (i) {
                final day = i + 1;
                final selected = day == _selectedDay;
                return InkWell(
                  onTap: () => setState(() => _selectedDay = day),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                      ),
                    ),
                    child: Text(
                      '$day',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: selected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Text(
              'September 03, 2025',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            const _ScheduleItem(
              time: '09:00',
              title: 'Team Sync-Up (Marketing)',
              range: '09:00 - 11:00',
            ),
            const SizedBox(height: 10),
            const _ScheduleBreak(label: 'Lunch Break', range: '11:00 - 14:00'),
            const SizedBox(height: 10),
            const _ScheduleItem(
              time: '14:00',
              title: 'Interview with Sarah Lee (Developer)',
              range: '14:00 - 15:00',
            ),
            const SizedBox(height: 10),
            const _ScheduleItem(
              time: '16:00',
              title: 'Monthly Performance Review (Sales Team)',
              range: '16:00 - 17:00',
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String time;
  final String title;
  final String range;

  const _ScheduleItem({
    required this.time,
    required this.title,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 46,
          child: Text(
            time,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 16),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colorScheme.primary.withValues(alpha: 38)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  range,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleBreak extends StatelessWidget {
  final String label;
  final String range;

  const _ScheduleBreak({required this.label, required this.range});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 46),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Center(
              child: Text(
                '$label\n$range',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingTaskCard extends StatelessWidget {
  const _OnboardingTaskCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Onboarding Task',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: 0.6,
                      minHeight: 10,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '60%',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: const [
                _LegendDot(label: 'Completed Task'),
                _LegendDot(label: 'On Going Task'),
                _LegendDot(label: 'Waiting Task'),
                _LegendDot(label: 'Others'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final String label;

  const _LegendDot({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  final VoidCallback onOpenSalary;
  final VoidCallback onOpenLeave;

  const _ShortcutCard({
    required this.onOpenSalary,
    required this.onOpenLeave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shortcut',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton.icon(
                  onPressed: onOpenLeave,
                  icon: const Icon(Icons.event_rounded),
                  label: const Text('Leave'),
                ),
                OutlinedButton.icon(
                  onPressed: onOpenSalary,
                  icon: const Icon(Icons.payments_rounded),
                  label: const Text('Payslips'),
                ),
                IconButton.filledTonal(
                  onPressed: () {},
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Easier with Our\nMobile Apps',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Download on App Store / Google Play',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimary.withValues(alpha: 200),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.phone_iphone_rounded,
                      color: colorScheme.onPrimary.withValues(alpha: 220),
                      size: 42,
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
