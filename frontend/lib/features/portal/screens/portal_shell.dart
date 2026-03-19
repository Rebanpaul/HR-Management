import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'engage_screen.dart';
import 'home_screen.dart';
import 'leave_attendance_screen.dart';
import 'people_screen.dart';
import 'salary_screen.dart';

class PortalShell extends StatefulWidget {
  const PortalShell({super.key});

  @override
  State<PortalShell> createState() => _PortalShellState();
}

class _PortalShellState extends State<PortalShell> {
  int _index = 0;

  void _openProfile() {
    context.push('/portal/profile');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 1000;
    final isDesktopLayout = width >= 900;

    final screens = <Widget>[
      PortalHomeScreen(
        onOpenProfile: _openProfile,
        onOpenSalary: () => setState(() => _index = 1),
        onOpenLeave: () => setState(() => _index = 2),
      ),
      SalaryScreen(onOpenProfile: _openProfile),
      LeaveAttendanceScreen(onOpenProfile: _openProfile),
      EngageScreen(onOpenProfile: _openProfile),
      PeopleScreen(onOpenProfile: _openProfile),
    ];

    final destinations = const <NavigationDestination>[
      NavigationDestination(
        icon: Icon(Icons.grid_view_rounded),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.payments_rounded),
        label: 'Salary',
      ),
      NavigationDestination(
        icon: Icon(Icons.event_available_rounded),
        label: 'Leave',
      ),
      NavigationDestination(
        icon: Icon(Icons.campaign_rounded),
        label: 'Engage',
      ),
      NavigationDestination(
        icon: Icon(Icons.people_alt_rounded),
        label: 'People',
      ),
    ];

    void showInfo(String message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return Scaffold(
      body: isDesktopLayout
          ? Row(
              children: [
                _PortalSidebar(
                  selectedIndex: _index,
                  onSelect: (i) => setState(() => _index = i),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: Column(
                    children: [
                      _PortalTopBar(
                        title: destinations[_index].label,
                        onImportData: () => showInfo('Import is not wired yet.'),
                        onMail: () => showInfo('Mail is not wired yet.'),
                        onNotifications: () =>
                            showInfo('Notifications are not wired yet.'),
                        onOpenProfile: _openProfile,
                      ),
                      Expanded(
                        child: Container(
                          color: colorScheme.surface,
                          padding: EdgeInsets.symmetric(
                            horizontal: isWide ? 24 : 16,
                            vertical: isWide ? 18 : 12,
                          ),
                          child: IndexedStack(index: _index, children: screens),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: IndexedStack(index: _index, children: screens),
              ),
            ),
      bottomNavigationBar: isDesktopLayout
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: destinations,
            ),
    );
  }
}

class _PortalSidebar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _PortalSidebar({
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  State<_PortalSidebar> createState() => _PortalSidebarState();
}

class _PortalSidebarState extends State<_PortalSidebar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const sidebarGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 0.55, 1.0],
      colors: [
        Color(0xFF050B16),
        Color(0xFF071A2E),
        Color(0xFF041125),
      ],
    );

    Widget item({
      required int index,
      required String label,
      required IconData icon,
    }) {
      final selected = widget.selectedIndex == index;
      return InkWell(
        onTap: () => widget.onSelect(index),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white.withValues(alpha: 18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: selected
                ? Border.all(color: Colors.white.withValues(alpha: 35))
                : null,
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 18,
                  color: Colors.white
                      .withValues(alpha: selected ? 255 : 200)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white
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

    return Container(
      width: 280,
      decoration: const BoxDecoration(gradient: sidebarGradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.waves_rounded, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    'Collectiva',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 35),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          Colors.white.withValues(alpha: 22),
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
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
                              color: Colors.white.withValues(alpha: 180),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Employee',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white.withValues(alpha: 220),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'by name or ID',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 140),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.white.withValues(alpha: 200),
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 35),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 35),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 90),
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 6, bottom: 8),
                child: Text(
                  'PORTAL',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 160),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              item(index: 0, label: 'Home', icon: Icons.dashboard_outlined),
              item(index: 1, label: 'Salary', icon: Icons.payments_outlined),
              item(
                index: 2,
                label: 'Leave & Attendance',
                icon: Icons.event_available_outlined,
              ),
              item(index: 3, label: 'Engage', icon: Icons.campaign_outlined),
              item(index: 4, label: 'People', icon: Icons.people_alt_outlined),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Employee Portal',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 210),
                        fontWeight: FontWeight.w700,
                      ),
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

class _PortalTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onImportData;
  final VoidCallback onMail;
  final VoidCallback onNotifications;
  final VoidCallback onOpenProfile;

  const _PortalTopBar({
    required this.title,
    required this.onImportData,
    required this.onMail,
    required this.onNotifications,
    required this.onOpenProfile,
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
            onPressed: onMail,
            icon: const Icon(Icons.mail_outline_rounded),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: onNotifications,
            icon: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onOpenProfile,
            borderRadius: BorderRadius.circular(999),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.person_rounded,
                color: colorScheme.onPrimaryContainer,
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
