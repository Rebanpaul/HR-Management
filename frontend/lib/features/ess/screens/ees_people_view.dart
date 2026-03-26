import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ess_theme.dart';

class EesPeopleView extends StatefulWidget {
  const EesPeopleView({super.key});

  @override
  State<EesPeopleView> createState() => _EesPeopleViewState();
}

class _EesPeopleViewState extends State<EesPeopleView> {
  String _searchQuery = '';

  final List<(String, String, String)> _allUsers = const [
    ('John Smith', 'Senior Developer', 'Engineering'),
    ('Aisha Williams', 'HR Manager', 'Human Resources'),
    ('Marcus Kim', 'Financial Analyst', 'Finance'),
    ('Rachel Brown', 'QA Lead', 'Engineering'),
    ('Lily Nguyen', 'UI/UX Designer', 'Design'),
    ('David Wilson', 'Operations Manager', 'Operations'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: EssTheme.surface,
            child: TabBar(
              labelColor: EssTheme.slateBlue,
              unselectedLabelColor: EssTheme.textSecondary,
              indicatorColor: EssTheme.slateBlue,
              indicatorWeight: 3,
              labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'Directory'),
                Tab(text: 'Org Chart'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildDirectoryTab(),
                _buildOrgChartTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectoryTab() {
     return Column(
       children: [
         // Global Search Area
         Container(
           padding: const EdgeInsets.all(24),
           decoration: const BoxDecoration(
             color: EssTheme.surface,
             border: Border(bottom: BorderSide(color: EssTheme.border)),
           ),
           child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search people by name, role, or department...',
                prefixIcon: const Icon(Icons.search_rounded, color: EssTheme.textSecondary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: EssTheme.background,
              ),
            ),
         ),
         // Directory Grid
         Expanded(
           child: LayoutBuilder(
             builder: (context, constraints) {
               final filteredUsers = _allUsers.where((u) => 
                 u.$1.toLowerCase().contains(_searchQuery) || 
                 u.$2.toLowerCase().contains(_searchQuery) ||
                 u.$3.toLowerCase().contains(_searchQuery)
               ).toList();

               if (filteredUsers.isEmpty) {
                 return Center(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       const Icon(Icons.search_off_rounded, size: 48, color: EssTheme.textMuted),
                       const SizedBox(height: 16),
                       Text('No results found for "$_searchQuery"', style: GoogleFonts.inter(color: EssTheme.textSecondary)),
                     ],
                   ),
                 );
               }

               final isMobile = constraints.maxWidth < 600;
               return GridView.builder(
                 padding: const EdgeInsets.all(24),
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: isMobile ? 1 : 3,
                   childAspectRatio: isMobile ? 3 : 2,
                   crossAxisSpacing: 16,
                   mainAxisSpacing: 16,
                 ),
                 itemCount: filteredUsers.length,
                 itemBuilder: (context, index) {
                   final u = filteredUsers[index];
                   return _DirectoryCard(u.$1, u.$2, u.$3);
                 },
               );
             }
           ),
         ),
       ],
     );
  }

  Widget _buildOrgChartTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_tree_outlined, size: 48, color: EssTheme.slateBlueLight),
          const SizedBox(height: 16),
          Text('Hierarchical Organization Chart', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: EssTheme.textPrimary)),
          const SizedBox(height: 8),
          Text('Zoomable reporting lines will be populated here.', style: GoogleFonts.inter(color: EssTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _DirectoryCard extends StatelessWidget {
  final String name, role, dept;
  const _DirectoryCard(this.name, this.role, this.dept);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: EssTheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: EssTheme.border)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: EssTheme.slateBlueLight.withValues(alpha: 0.2),
            child: Text(name[0], style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: EssTheme.slateBlue)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(role, style: GoogleFonts.inter(fontSize: 13, color: EssTheme.textSecondary)),
                const SizedBox(height: 2),
                Text(dept, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: EssTheme.textMuted)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.mail_outline_rounded, color: EssTheme.slateBlueLight), onPressed: () {}),
        ],
      ),
    );
  }
}
