import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';

import 'employees_admin_screen.dart';
import 'leave_admin_screen.dart';
import 'payroll_admin_screen.dart';
import 'workflow_admin_screen.dart';
import 'reports_admin_screen.dart';
import 'engage_admin_screen.dart';

// ─── Dashboard Shell ────────────────────────────────────────────
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _selected = 'Home';

  void _select(String label) => setState(() => _selected = label);

  Widget _buildContent() {
    switch (_selected) {
      case 'Employee': return const EmployeesAdminScreen();
      case 'Payroll': return const PayrollAdminScreen();
      case 'Leave & Attendance': return const LeaveAdminScreen();
      case 'Workflow': return const WorkflowAdminScreen();
      case 'Reports': return const ReportsAdminScreen();
      case 'Engage': return const EngageAdminScreen();
      case 'Home':
      default:
        return const _HomeDashboard(); // Phase 2 implementation
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final fullName = user?.employee?.fullName ?? 'Administrator';
    final avatarLetter = (user?.employee?.firstName ?? 'A').substring(0, 1).toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Row(
        children: [
          // ── Sidebar (Deep Navy) ──────────────────────────────────
          _Sidebar(
            selected: _selected,
            userName: fullName,
            avatarLetter: avatarLetter,
            onItemSelected: _select,
          ),
          // ── Main Content Area ────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                _TopBar(
                  avatarLetter: avatarLetter,
                  userName: fullName,
                  title: _selected,
                  onLogout: () => ref.read(authProvider.notifier).logout(),
                ),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sidebar ─────────────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final String selected;
  final String userName;
  final String avatarLetter;
  final ValueChanged<String> onItemSelected;

  const _Sidebar({
    required this.selected,
    required this.userName,
    required this.avatarLetter,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppColors.navyDeep,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Logo Area
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
              child: Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.actionBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'StaffSource',
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Navigation Links
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NavSectionLabel('OVERVIEW'),
                    _NavItem(icon: Icons.dashboard_rounded, label: 'Home', selected: selected == 'Home', onTap: () => onItemSelected('Home')),
                    
                    const SizedBox(height: 16),
                    _NavSectionLabel('MANAGEMENT'),
                    _NavItem(icon: Icons.people_alt_rounded, label: 'Employee', selected: selected == 'Employee', onTap: () => onItemSelected('Employee')),
                    _NavItem(icon: Icons.receipt_long_rounded, label: 'Payroll', selected: selected == 'Payroll', onTap: () => onItemSelected('Payroll')),
                    _NavItem(
                      icon: Icons.event_available_rounded, 
                      label: 'Leave & Attendance', 
                      selected: selected == 'Leave & Attendance', 
                      onTap: () => onItemSelected('Leave & Attendance'),
                      badgeCount: 3, // Notification badge for Pending Leave Requests
                    ),

                    const SizedBox(height: 16),
                    _NavSectionLabel('OPERATIONS'),
                    _NavItem(icon: Icons.account_tree_rounded, label: 'Workflow', selected: selected == 'Workflow', onTap: () => onItemSelected('Workflow')),
                    _NavItem(icon: Icons.bar_chart_rounded, label: 'Reports', selected: selected == 'Reports', onTap: () => onItemSelected('Reports')),
                    _NavItem(icon: Icons.forum_rounded, label: 'Engage', selected: selected == 'Engage', onTap: () => onItemSelected('Engage')),
                  ],
                ),
              ),
            ),

            // Bottom Profile Area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF1E293B))),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.actionBlue.withOpacity(0.2),
                    child: Text(avatarLetter, style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: AppColors.actionBlue, fontSize: 13)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white)),
                        Text('System Admin', style: GoogleFonts.inter(fontSize: 11, color: AppColors.slateGray)),
                      ],
                    ),
                  ),
                  const Icon(Icons.unfold_more_rounded, size: 18, color: AppColors.slateGray),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavSectionLabel extends StatelessWidget {
  final String text;
  const _NavSectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8, top: 4),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.slateGray, letterSpacing: 0.8),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? badgeCount;

  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap, this.badgeCount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.actionBlue.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: selected ? AppColors.actionBlue : Colors.transparent, width: 3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? AppColors.actionBlue : const Color(0xFF94A3B8)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? Colors.white : const Color(0xFFCBD5E1),
                ),
              ),
            ),
            if (badgeCount != null && badgeCount! > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(10)),
                child: Text('$badgeCount', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Bar ─────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final String avatarLetter;
  final String userName;
  final String title;
  final VoidCallback onLogout;

  const _TopBar({required this.avatarLetter, required this.userName, required this.title, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navyDeep, letterSpacing: -0.5)),
          const Spacer(),
          // Global Search
          Container(
            width: 240,
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.bgLight,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, size: 16, color: AppColors.slateGray),
                const SizedBox(width: 8),
                Text('Search anywhere...', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4), border: Border.all(color: AppColors.border)),
                  child: Text('⌘K', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.slateGray)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Notification Bell
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(icon: const Icon(Icons.notifications_none_rounded, color: AppColors.slateGray), onPressed: () {}),
              Positioned(
                top: 8, right: 8,
                child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle)),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const VerticalDivider(width: 1, indent: 16, endIndent: 16, color: AppColors.border),
          const SizedBox(width: 16),
          // Profile Dropdown
          PopupMenuButton<String>(
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onSelected: (val) { if (val == 'logout') onLogout(); },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'profile', child: Text('My Profile', style: GoogleFonts.inter(fontSize: 13))),
              PopupMenuItem(value: 'settings', child: Text('Account Settings', style: GoogleFonts.inter(fontSize: 13))),
              const PopupMenuDivider(),
              PopupMenuItem(value: 'logout', child: Text('Log out', style: GoogleFonts.inter(fontSize: 13, color: AppColors.red))),
            ],
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.actionBlue.withOpacity(0.1),
                  child: Text(avatarLetter, style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.actionBlue, fontSize: 12)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.slateGray),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Home Dashboard (Phase 2) ────────────────────────────────────
class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Recent Tabs & Date
          Row(
            children: [
              Text('Recent: ', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray)),
              _RecentTab(label: 'Leave Approvals'),
              const SizedBox(width: 8),
              _RecentTab(label: 'Payroll Inputs (Mar)'),
              const Spacer(),
              Text(DateFormat('EEEE, MMMM d').format(DateTime.now()), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slateGray)),
            ],
          ),
          const SizedBox(height: 24),

          // Main 2-column layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column (Metrics, Favorites, Live Status)
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KPI Row
                    Row(
                      children: [
                        Expanded(child: _KpiCard(title: 'Active Employees', value: '142', trend: '+3 this month', isPositive: true)),
                        const SizedBox(width: 16),
                        Expanded(child: _KpiCard(title: 'Leaves Pending', value: '3', trend: 'Requires action', isWarning: true)),
                        const SizedBox(width: 16),
                        Expanded(child: _KpiCard(title: 'Attendance Today', value: '94%', trend: 'Avg arrival 9:02 AM')),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Pinned Favorites Grid
                    Text('Pinned Favorites', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.2,
                      children: const [
                        _FavoriteCard(icon: Icons.person_add_rounded, title: 'Onboard Employee', color: AppColors.actionBlue),
                        _FavoriteCard(icon: Icons.receipt_rounded, title: 'Process Payroll', color: AppColors.green),
                        _FavoriteCard(icon: Icons.assignment_turned_in_rounded, title: 'Approve Leaves', color: AppColors.amber),
                        _FavoriteCard(icon: Icons.bar_chart_rounded, title: 'Q1 Reports', color: AppColors.purple),
                        _FavoriteCard(icon: Icons.settings_rounded, title: 'Update Policies', color: AppColors.slateGray),
                        _FavoriteCard(icon: Icons.add_rounded, title: 'Add Shortcut', isAdd: true),
                      ],
                    ),

                    const SizedBox(height: 24),
                    
                    // Who is In (Live Status)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)),
                                  const SizedBox(width: 8),
                                  Text('Who Is In', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                                ],
                              ),
                              TextButton(onPressed: (){}, child: Text('View Details', style: GoogleFonts.inter(fontSize: 12, color: AppColors.actionBlue, fontWeight: FontWeight.w600))),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _WhoIsInColumn('Present', [('JS', AppColors.green), ('AW', AppColors.green), ('MK', AppColors.green), ('+', AppColors.bgLight)]),
                              const SizedBox(width: 32),
                              _WhoIsInColumn('On Leave', [('RB', AppColors.amber), ('LN', AppColors.amber)]),
                              const SizedBox(width: 32),
                              _WhoIsInColumn('Absent', [('DW', AppColors.red)]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 24),
              
              // Right Column (Calendar & Recent Feed)
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    const _InteractiveCalendar(),
                    const SizedBox(height: 24),
                    
                    // Activity Feed
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Recent Activity', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                          const SizedBox(height: 16),
                          _ActivityItem(title: 'John Smith applied for Sick Leave', time: '10 mins ago', iconColor: AppColors.amber),
                          _ActivityItem(title: 'Payroll verified for Engineering', time: '2 hours ago', iconColor: AppColors.green),
                          _ActivityItem(title: 'New policy document uploaded', time: 'Yesterday', iconColor: AppColors.actionBlue),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Help & Documentation', style: GoogleFonts.inter(fontSize: 12, color: AppColors.actionBlue, decoration: TextDecoration.underline)),
              Text(' • ', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateGray)),
              Text('Submit Feedback', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateGray)),
              Text(' • ', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateGray)),
              Text('System Status: All Operational', style: GoogleFonts.inter(fontSize: 12, color: AppColors.green)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Helpers Components ──────────────────────────────────────────

class _RecentTab extends StatelessWidget {
  final String label;
  const _RecentTab({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4), border: Border.all(color: AppColors.border)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.navyDeep)),
          const SizedBox(width: 6),
          const Icon(Icons.close_rounded, size: 12, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final bool isPositive;
  final bool isWarning;

  const _KpiCard({required this.title, required this.value, required this.trend, this.isPositive = false, this.isWarning = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slateGray)),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.navyDeep, letterSpacing: -1)),
          const SizedBox(height: 8),
          Row(
            children: [
              if (isPositive) const Icon(Icons.trending_up_rounded, size: 14, color: AppColors.green),
              if (isWarning) const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.amber),
              if (isPositive || isWarning) const SizedBox(width: 4),
              Text(trend, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: isPositive ? AppColors.green : (isWarning ? AppColors.amber : AppColors.slateGray))),
            ],
          ),
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final bool isAdd;

  const _FavoriteCard({required this.icon, required this.title, this.color, this.isAdd = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isAdd ? AppColors.borderSubtle : AppColors.border),
      ),
      child: isAdd 
        ? Center(child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 18, color: AppColors.slateGray), const SizedBox(width: 8), Text(title, style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray, fontWeight: FontWeight.w500))]))
        : Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (){},
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: color!.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Icon(icon, size: 16, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyDeep))),
                ],
              ),
            ),
          ),
        ),
    );
  }
}

class _WhoIsInColumn extends StatelessWidget {
  final String label;
  final List<(String, Color)> avatars;

  const _WhoIsInColumn(this.label, this.avatars);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slateGray)),
        const SizedBox(height: 10),
        Row(
          children: avatars.map((a) => Padding(
            padding: const EdgeInsets.only(right: -8.0),
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.surface, width: 2)),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: a.$2.withOpacity(0.2),
                child: Text(a.$1, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: a.$1 == '+' ? AppColors.slateGray : AppColors.navyDeep)),
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class _InteractiveCalendar extends StatefulWidget {
  const _InteractiveCalendar();
  @override
  State<_InteractiveCalendar> createState() => _InteractiveCalendarState();
}
class _InteractiveCalendarState extends State<_InteractiveCalendar> {
  DateTime _focusedMonth = DateTime.now();

  void _prevMonth() => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1));
  void _nextMonth() => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1));

  void _onDayTap(DateTime day) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(DateFormat('EE, MMM d').format(day), style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attendance Stats:', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.slateGray)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _StatMini('124', 'Present', AppColors.green),
              _StatMini('4', 'Leave', AppColors.amber),
              _StatMini('2', 'Absent', AppColors.red),
            ]),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('View Full Attendance')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7; 

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('MMMM yyyy').format(_focusedMonth), style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
              Row(
                children: [
                  IconButton(onPressed: _prevMonth, icon: const Icon(Icons.chevron_left_rounded, size: 20), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 32, minHeight: 32)),
                  IconButton(onPressed: _nextMonth, icon: const Icon(Icons.chevron_right_rounded, size: 20), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 32, minHeight: 32)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((d) =>
              Expanded(child: Center(child: Text(d, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.slateGray)))),
            ).toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
            itemCount: startWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startWeekday) return const SizedBox.shrink();
              final day = index - startWeekday + 1;
              final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
              final isToday = date.year == DateTime.now().year && date.month == DateTime.now().month && date.day == DateTime.now().day;
              
              // Mock statuses
              Color statusColor = Colors.transparent;
              if (date.isBefore(DateTime.now())) statusColor = day % 7 == 0 ? AppColors.amber : AppColors.green;
              if (isToday) statusColor = AppColors.actionBlue;

              return GestureDetector(
                onTap: () => _onDayTap(date),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isToday ? AppColors.actionBlue.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: isToday ? Border.all(color: AppColors.actionBlue.withOpacity(0.3)) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$day', style: GoogleFonts.inter(fontSize: 12, fontWeight: isToday ? FontWeight.w700 : FontWeight.w500, color: isToday ? AppColors.actionBlue : AppColors.navyDeep)),
                      if (statusColor != Colors.transparent && !isToday)
                        Container(margin: const EdgeInsets.only(top: 2), width: 4, height: 4, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatMini extends StatelessWidget {
  final String val; final String label; final Color c;
  const _StatMini(this.val, this.label, this.c);
  @override
  Widget build(BuildContext context) => Column(children: [Text(val, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: c)), Text(label, style: GoogleFonts.inter(fontSize: 10, color: AppColors.slateGray))]);
}

class _ActivityItem extends StatelessWidget {
  final String title; final String time; final Color iconColor;
  const _ActivityItem({required this.title, required this.time, required this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(margin: const EdgeInsets.only(top: 2), width: 8, height: 8, decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.navyDeep)),
            const SizedBox(height: 2),
            Text(time, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
          ])),
        ],
      ),
    );
  }
}
