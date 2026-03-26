import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ess_theme.dart';

// Placeholder screens for ESS
import 'ess_home_screen.dart';
import 'ess_engage_screen.dart';
import 'ess_todo_screen.dart';
import 'ess_essentials_screen.dart';

class EssShell extends StatefulWidget {
  final bool isManager; // If true, default to To-Do tab
  const EssShell({super.key, this.isManager = false});

  @override
  State<EssShell> createState() => _EssShellState();
}

class _EssShellState extends State<EssShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isManager) {
      _currentIndex = 2; // Default to To-Do for managers
    }
  }

  final List<Widget> _screens = const [
    EssHomeScreen(),
    EssEngageScreen(),
    EssTodoScreen(),
    EssEssentialsScreen(),
  ];

  final List<({IconData icon, String label})> _navItems = const [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.groups_rounded, label: 'Engage'),
    (icon: Icons.checklist_rounded, label: 'To-Do'),
    (icon: Icons.work_rounded, label: 'EES (Essentials)'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return Scaffold(
          backgroundColor: EssTheme.background,
          appBar: isMobile
              ? AppBar(
                  backgroundColor: EssTheme.surface,
                  title: Row(
                    children: [
                      Icon(Icons.flash_on_rounded, color: EssTheme.slateBlue, size: 24),
                      const SizedBox(width: 8),
                      Text('StaffSource', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: EssTheme.textPrimary)),
                    ],
                  ),
                  actions: [
                    IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
                    Padding(
                      padding: const EdgeInsets.only(right: 16, left: 8),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: EssTheme.slateBlueLight.withOpacity(0.2),
                        child: Text('JS', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: EssTheme.slateBlue)),
                      ),
                    ),
                  ],
                )
              : null, // Desktop gets a custom top bar in the content area
          body: isMobile
              ? _screens[_currentIndex]
              : Row(
                  children: [
                    _buildDesktopSidebar(),
                    Expanded(
                      child: Column(
                        children: [
                          _buildDesktopTopBar(),
                          Expanded(child: _screens[_currentIndex]),
                        ],
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: isMobile
              ? NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (i) => setState(() => _currentIndex = i),
                  backgroundColor: EssTheme.surface,
                  indicatorColor: EssTheme.slateBlueLight.withOpacity(0.2),
                  destinations: _navItems.map((item) {
                    return NavigationDestination(
                      icon: Icon(item.icon, color: EssTheme.textSecondary),
                      selectedIcon: Icon(item.icon, color: EssTheme.slateBlue),
                      label: item.label,
                    );
                  }).toList(),
                )
              : null,
        );
      },
    );
  }

  Widget _buildDesktopSidebar() {
    return Container(
      width: 260,
      color: EssTheme.surface,
      child: Column(
        children: [
          // Logo Area
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: EssTheme.slateBlue, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text('StaffSource', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: EssTheme.textPrimary)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Navigation
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final isSelected = _currentIndex == index;
                final item = _navItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(item.icon, color: isSelected ? EssTheme.slateBlue : EssTheme.textSecondary, size: 22),
                    title: Text(item.label, style: GoogleFonts.inter(fontSize: 14, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? EssTheme.textPrimary : EssTheme.textSecondary)),
                    selected: isSelected,
                    selectedTileColor: EssTheme.slateBlueLight.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    onTap: () => setState(() => _currentIndex = index),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                );
              },
            ),
          ),
          // User Profile Foot
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: EssTheme.border))),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: EssTheme.slateBlueLight.withOpacity(0.2), child: Text('JS', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: EssTheme.slateBlue))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('John Smith', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: EssTheme.textPrimary)),
                      Text('Engineering', style: GoogleFonts.inter(fontSize: 12, color: EssTheme.textSecondary)),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.logout_rounded, size: 20, color: EssTheme.textSecondary), onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTopBar() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: EssTheme.surface,
        border: Border(bottom: BorderSide(color: EssTheme.border), left: BorderSide(color: EssTheme.border)),
      ),
      child: Row(
        children: [
          Text(_navItems[_currentIndex].label, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
          const Spacer(),
          // Global Search Placeholder
          SizedBox(
            width: 300,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search people, leaves...',
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                filled: true,
                fillColor: EssTheme.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(icon: const Icon(Icons.notifications_none_rounded, color: EssTheme.textSecondary), onPressed: () {}),
        ],
      ),
    );
  }
}
