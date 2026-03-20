import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../attendance/providers/attendance_provider.dart';
import '../../attendance/widgets/punch_in_widget.dart';
import '../../../shared/widgets/portal_header.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../core/theme/app_theme.dart';

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

    final today = DateTime.now();
    final dateLabel = DateFormat('EEEE, MMMM d').format(today);
    final clockIn = attendanceState.todayAttendance?.punchIn;
    final clockOut = attendanceState.todayAttendance?.punchOut;

    String fmtTime(DateTime? dt) =>
        dt == null ? '--:--' : DateFormat('hh:mm a').format(dt);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(attendanceProvider.notifier).fetchToday();
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            PortalHeader(onProfileTap: onOpenProfile),
            const SizedBox(height: 16),

            // Greeting
            Text(
              'Hey there 👋',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            // ─ Today's Overview (Glassmorphic gradient card) ─
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.brandPrimary, AppTheme.brandAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Overview",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('d MMM, y').format(today),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _GlassTimeChip(
                          label: 'Clock In',
                          value: fmtTime(clockIn),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _GlassTimeChip(
                          label: 'Clock Out',
                          value: fmtTime(clockOut),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ─ Punch-in Widget ─
            const PunchInWidget(),

            const SizedBox(height: 24),

            // ─ Leave Balance (from API when connected) ─
            SectionHeader(
              title: 'Leave Balance',
              actionLabel: 'Apply',
              onAction: onOpenLeave,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _GlassMetricTile(
                    label: 'Casual',
                    value: '--',
                    color: AppTheme.brandPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GlassMetricTile(
                    label: 'Sick',
                    value: '--',
                    color: AppTheme.brandAccent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GlassMetricTile(
                    label: 'Earned',
                    value: '--',
                    color: AppTheme.brandTeal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ─ Payslip Preview ─
            SectionHeader(
              title: 'Latest Payslip',
              actionLabel: 'View all',
              onAction: onOpenSalary,
            ),
            const SizedBox(height: 10),
            _PayslipPlaceholderCard(),

            const SizedBox(height: 24),

            // ─ Upcoming ─
            SectionHeader(
              title: 'Upcoming',
              actionLabel: dateLabel,
            ),
            const SizedBox(height: 10),
            _EmptyStateCard(
              icon: Icons.celebration_outlined,
              text: 'No upcoming events.',
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Glass Widgets
// ─────────────────────────────────────────────────────────

class _GlassTimeChip extends StatelessWidget {
  final String label;
  final String value;

  const _GlassTimeChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(31),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha(46)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _GlassMetricTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withAlpha(38)),
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withAlpha(31),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.calendar_today_rounded, size: 16, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withAlpha(204),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayslipPlaceholderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
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
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Connect your backend to view payslips.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EmptyStateCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        child: Column(
          children: [
            Icon(icon, color: colorScheme.onSurfaceVariant.withAlpha(102), size: 36),
            const SizedBox(height: 10),
            Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
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
