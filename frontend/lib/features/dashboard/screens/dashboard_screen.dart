import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../auth/providers/auth_provider.dart';
import 'attendance_admin_screen.dart';
import 'employees_admin_screen.dart';
import 'leave_admin_screen.dart';
import 'payroll_admin_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _selected = 'Dashboard';

  void _select(String label) {
    setState(() => _selected = label);
  }

  Widget _buildContent(String label) {
    switch (label) {
      case 'Employees':
        return const EmployeesAdminScreen();
      case 'Leave':
        return const LeaveAdminScreen();
      case 'Attendance':
        return const AttendanceAdminScreen();
      case 'Payslips':
        return const PayrollAdminScreen();
      case 'Dashboard':
      default:
        return const _DashboardOverview();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    final greetingName = user?.employee?.firstName;
    final avatarLetter = (greetingName == null || greetingName.isEmpty)
        ? 'A'
        : greetingName.substring(0, 1).toUpperCase();

    return Scaffold(
      body: Row(
        children: [
          _Sidebar(
            userName: user?.employee?.fullName ?? 'Administrator',
            roleLabel: 'Administrator',
            selected: _selected,
            onItemSelected: _select,
            onLogout: () => ref.read(authProvider.notifier).logout(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                _TopBar(
                  avatarLetter: avatarLetter,
                  title: _selected,
                  onImportData: () => showInfo('Import is not wired yet.'),
                  onOpenMail: () => showInfo('Mail is not wired yet.'),
                  onOpenNotifications: () =>
                      showInfo('Notifications are not wired yet.'),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                    child: _buildContent(_selected),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showInfo(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _Sidebar extends StatelessWidget {
  final String userName;
  final String roleLabel;
  final ValueChanged<String> onItemSelected;
  final String selected;
  final VoidCallback onLogout;

  const _Sidebar({
    required this.userName,
    required this.roleLabel,
    required this.onItemSelected,
    required this.selected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Uses theme colors only; creates a darker surface using primary.
    final background = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 230),
      colorScheme.surface,
    );

    return Container(
      width: 280,
      color: background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.waves_rounded, color: colorScheme.onPrimary),
                  const SizedBox(width: 10),
                  Text(
                    'Collectiva',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withValues(alpha: 18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.onPrimary.withValues(alpha: 35),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          colorScheme.onPrimary.withValues(alpha: 22),
                      child: Icon(
                        Icons.person_rounded,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login as',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color:
                                  colorScheme.onPrimary.withValues(alpha: 180),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            roleLabel,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.onPrimary.withValues(alpha: 220),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                style: TextStyle(color: colorScheme.onPrimary),
                decoration: InputDecoration(
                  hintText: 'by name or ID',
                  hintStyle:
                      TextStyle(color: colorScheme.onPrimary.withValues(alpha: 140)),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: colorScheme.onPrimary.withValues(alpha: 200),
                  ),
                  filled: true,
                  fillColor: colorScheme.onPrimary.withValues(alpha: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: colorScheme.onPrimary.withValues(alpha: 35),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: colorScheme.onPrimary.withValues(alpha: 35),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: colorScheme.onPrimary.withValues(alpha: 90),
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              _SidebarSection(
                title: 'ADMINISTRATIVE',
                children: [
                  _SidebarItem(
                    label: 'Dashboard',
                    icon: Icons.dashboard_outlined,
                    selected: selected == 'Dashboard',
                    onTap: () => onItemSelected('Dashboard'),
                  ),
                  _SidebarItem(
                    label: 'Employees',
                    icon: Icons.badge_outlined,
                    selected: selected == 'Employees',
                    onTap: () => onItemSelected('Employees'),
                  ),
                  _SidebarItem(
                    label: 'Leave',
                    icon: Icons.event_available_rounded,
                    selected: selected == 'Leave',
                    onTap: () => onItemSelected('Leave'),
                  ),
                  _SidebarItem(
                    label: 'Attendance',
                    icon: Icons.access_time_rounded,
                    selected: selected == 'Attendance',
                    onTap: () => onItemSelected('Attendance'),
                  ),
                  _SidebarItem(
                    label: 'Payslips',
                    icon: Icons.receipt_long_outlined,
                    selected: selected == 'Payslips',
                    onTap: () => onItemSelected('Payslips'),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 210),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Sign out',
                    onPressed: onLogout,
                    icon: Icon(
                      Icons.logout_rounded,
                      color: colorScheme.onPrimary.withValues(alpha: 230),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardOverview extends ConsumerWidget {
  const _DashboardOverview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${user?.employee?.firstName ?? 'Admin'}',
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
            items: const [
              _MetricItem(
                title: 'Employees',
                value: '—',
                subtitle: 'Employees in your tenant',
                icon: Icons.people_alt_rounded,
                emphasized: true,
              ),
              _MetricItem(
                title: 'Pending Leaves',
                value: '—',
                subtitle: 'Awaiting approval',
                icon: Icons.event_available_rounded,
              ),
              _MetricItem(
                title: 'Team Attendance',
                value: '—',
                subtitle: 'Records for today',
                icon: Icons.access_time_rounded,
              ),
              _MetricItem(
                title: 'Payslips',
                value: '—',
                subtitle: 'Generated payslips',
                icon: Icons.receipt_long_outlined,
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
                    child: const _ShortcutCard(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SidebarSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SidebarSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 8),
          child: Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onPrimary.withValues(alpha: 160),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.onPrimary.withValues(alpha: 18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: selected
              ? Border.all(color: colorScheme.onPrimary.withValues(alpha: 35))
              : null,
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18,
                color: colorScheme.onPrimary
                    .withValues(alpha: selected ? 255 : 200)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary
                      .withValues(alpha: selected ? 255 : 210),
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String avatarLetter;
  final String title;
  final VoidCallback onImportData;
  final VoidCallback onOpenMail;
  final VoidCallback onOpenNotifications;

  const _TopBar({
    required this.avatarLetter,
    required this.title,
    required this.onImportData,
    required this.onOpenMail,
    required this.onOpenNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: onImportData,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Import Data'),
          ),
          const SizedBox(width: 10),
          _DateChip(value: DateTime.now()),
          const SizedBox(width: 10),
          IconButton(
            tooltip: 'Mail',
            onPressed: onOpenMail,
            icon: const Icon(Icons.mail_outline_rounded),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: onOpenNotifications,
            icon: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(width: 6),
          CircleAvatar(
            radius: 18,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
              avatarLetter,
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final DateTime value;

  const _DateChip({required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month_rounded,
              size: 18, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            DateFormat('MMM dd, y').format(value),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
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
    return oldDelegate.lineColor != lineColor || oldDelegate.fillColor != fillColor;
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
            _ScheduleItem(
              time: '09:00',
              title: 'Team Sync-Up (Marketing)',
              range: '09:00 - 11:00',
            ),
            const SizedBox(height: 10),
            _ScheduleBreak(label: 'Lunch Break', range: '11:00 - 14:00'),
            const SizedBox(height: 10),
            _ScheduleItem(
              time: '14:00',
              title: 'Interview with Sarah Lee (Developer)',
              range: '14:00 - 15:00',
            ),
            const SizedBox(height: 10),
            _ScheduleItem(
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
  const _ShortcutCard();

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
                  onPressed: () {},
                  icon: const Icon(Icons.post_add_rounded),
                  label: const Text('Post Job'),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.event_rounded),
                  label: const Text('Schedule Meeting'),
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
