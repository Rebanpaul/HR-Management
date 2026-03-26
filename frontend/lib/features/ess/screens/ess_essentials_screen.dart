import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ess_theme.dart';

import 'ees_salary_view.dart';
import 'ees_leave_view.dart';
import 'ees_attendance_view.dart';
import 'ees_people_view.dart';
import 'ees_profile_view.dart';

class EssEssentialsScreen extends StatefulWidget {
  const EssEssentialsScreen({super.key});

  @override
  State<EssEssentialsScreen> createState() => _EssEssentialsScreenState();
}

class _EssEssentialsScreenState extends State<EssEssentialsScreen> {
  int _selectedIndex = 0;

  final List<Widget> _views = const [
    EesSalaryView(),
    EesLeaveView(),
    EesAttendanceView(),
    EesPeopleView(),
    EesProfileView(),
  ];

  final List<({IconData icon, String label})> _menuItems = const [
    (icon: Icons.payments_rounded, label: 'Salary & Finance'),
    (icon: Icons.event_available_rounded, label: 'Leave & Time-Off'),
    (icon: Icons.access_time_filled_rounded, label: 'Attendance (My Time)'),
    (icon: Icons.groups_rounded, label: 'People Directory'),
    (icon: Icons.person_rounded, label: 'My Profile & Vault'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        if (isMobile) {
          // Mobile: Use a top horizontal scrolling tab bar
          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: List.generate(_menuItems.length, (index) {
                    final isSelected = _selectedIndex == index;
                    final item = _menuItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(item.label),
                        labelStyle: GoogleFonts.inter(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? Colors.white : EssTheme.textSecondary),
                        backgroundColor: EssTheme.surface,
                        selectedColor: EssTheme.slateBlue,
                        side: BorderSide(color: isSelected ? Colors.transparent : EssTheme.border),
                        onSelected: (_) => setState(() => _selectedIndex = index),
                      ),
                    );
                  }),
                ),
              ),
              const Divider(height: 1),
              Expanded(child: _views[_selectedIndex]),
            ],
          );
        } else {
          // Desktop: Use a nested vertical navigation rail/sidebar
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 280,
                decoration: const BoxDecoration(
                  color: EssTheme.background,
                  border: Border(right: BorderSide(color: EssTheme.border)),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    final item = _menuItems[index];
                    final isSelected = _selectedIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(item.icon, color: isSelected ? Colors.white : EssTheme.textSecondary, size: 20),
                        title: Text(item.label, style: GoogleFonts.inter(fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: isSelected ? Colors.white : EssTheme.textPrimary)),
                        tileColor: isSelected ? EssTheme.slateBlue : EssTheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: isSelected ? Colors.transparent : EssTheme.border),
                        ),
                        selected: isSelected,
                        onTap: () => setState(() => _selectedIndex = index),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: _views[_selectedIndex],
              ),
            ],
          );
        }
      },
    );
  }
}
