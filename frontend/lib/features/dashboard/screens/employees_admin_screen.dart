import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

// ─── Employee Admin Screen (4 Tabs) ─────────────────────────────
class EmployeesAdminScreen extends StatefulWidget {
  const EmployeesAdminScreen({super.key});

  @override
  State<EmployeesAdminScreen> createState() => _EmployeesAdminScreenState();
}

class _EmployeesAdminScreenState extends State<EmployeesAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 4-Tab Header Bar ──────────────────────────────────────
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Employee', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.navyDeep, letterSpacing: -0.5)),
                        Text('Manage workforce and employee information', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray)),
                      ],
                    ),
                  ),
                  // Action buttons
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = MediaQuery.of(context).size.width < 600;
                      final actions = [
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Importing employee data...')),
                            );
                          },
                          icon: const Icon(Icons.file_upload_outlined, size: 16),
                          label: const Text('Import'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.slateGray,
                            side: const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (!isMobile) const SizedBox(width: 8) else const SizedBox(height: 8),
                        FilledButton.icon(
                          onPressed: () => _showAddEmployeeDialog(context),
                          icon: const Icon(Icons.person_add_rounded, size: 16),
                          label: const Text('Add Employee'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.actionBlue,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ];
                      return isMobile ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: actions) : Row(children: actions);
                    }
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TabBar(
                controller: _tabController,
                isScrollable: false,
                labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
                labelColor: AppColors.actionBlue,
                unselectedLabelColor: AppColors.slateGray,
                indicatorColor: AppColors.actionBlue,
                indicatorWeight: 2.5,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: AppColors.border,
                tabs: const [
                  Tab(text: 'Main'),
                  Tab(text: 'Information'),
                  Tab(text: 'Admin'),
                  Tab(text: 'Setup'),
                ],
              ),
            ],
          ),
        ),
        // ── Tab Content ───────────────────────────────────────────
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _MainTab(),
              _InformationTab(),
              _AdminTab(),
              _SetupTab(),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add New Employee', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 17)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogInput(label: 'Full Name', hint: 'e.g., John Smith'),
            const SizedBox(height: 12),
            _DialogInput(label: 'Email', hint: 'john@company.com'),
            const SizedBox(height: 12),
            _DialogInput(label: 'Department', hint: 'e.g., Engineering'),
            const SizedBox(height: 12),
            _DialogInput(label: 'Role / Designation', hint: 'e.g., Software Engineer'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Employee profile created successfully!')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.actionBlue),
            child: const Text('Create Employee'),
          ),
        ],
      ),
    );
  }
}

// ─── Main Tab — Employee List Table ─────────────────────────────
class _MainTab extends StatefulWidget {
  const _MainTab();
  @override
  State<_MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<_MainTab> {
  String _searchQuery = '';
  String _selectedDept = 'All';

  final _depts = ['All', 'Engineering', 'HR', 'Finance', 'Marketing', 'Operations'];

  final _employees = [
    _EmployeeRow('John Smith', 'john@co.com', 'Engineering', 'Senior Developer', 'Active', 'JS'),
    _EmployeeRow('Aisha Williams', 'aisha@co.com', 'HR', 'HR Manager', 'Active', 'AW'),
    _EmployeeRow('Marcus Kim', 'marcus@co.com', 'Finance', 'Analyst', 'Active', 'MK'),
    _EmployeeRow('Rachel Brown', 'rachel@co.com', 'Engineering', 'QA Lead', 'On Leave', 'RB'),
    _EmployeeRow('Lily Nguyen', 'lily@co.com', 'Marketing', 'Designer', 'Active', 'LN'),
    _EmployeeRow('David Wilson', 'david@co.com', 'Operations', 'Ops Manager', 'Inactive', 'DW'),
    _EmployeeRow('Sara Patel', 'sara@co.com', 'Finance', 'CFO', 'Active', 'SP'),
    _EmployeeRow('Tom Richards', 'tom@co.com', 'Engineering', 'DevOps', 'Active', 'TR'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final filtered = _employees.where((e) {
      final matchSearch = e.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchDept = _selectedDept == 'All' || e.dept == _selectedDept;
      return matchSearch && matchDept;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filters Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              final filterRow = [
                Expanded(
                  flex: isMobile ? 0 : 3,
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Search employees...',
                        hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
                        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.slateGray),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.actionBlue, width: 2)),
                        filled: true, fillColor: AppColors.surface,
                      ),
                    ),
                  ),
                ),
                if (isMobile) const SizedBox(height: 12) else const SizedBox(width: 12),
                Expanded(
                  flex: isMobile ? 0 : 2,
                  child: SizedBox(
                    height: 48,
                    child: DropdownButtonFormField<String>(
                      value: _selectedDept,
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.navyDeep),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
                        filled: true, fillColor: AppColors.surface,
                      ),
                      items: _depts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                      onChanged: (d) => setState(() => _selectedDept = d ?? 'All'),
                    ),
                  ),
                ),
                if (!isMobile) const Spacer(),
                if (isMobile) const SizedBox(height: 8),
                Text('${filtered.length} Results', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray, fontWeight: FontWeight.w500)),
              ];

              return isMobile ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: filterRow) : Row(children: filterRow);
            }
          ),
          const SizedBox(height: 16),
          // Table
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: isMobile ? 800 : (MediaQuery.of(context).size.width > 1100 ? MediaQuery.of(context).size.width - 300 : 800),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        width: isMobile ? 800 : (MediaQuery.of(context).size.width > 1100 ? MediaQuery.of(context).size.width - 300 : 800),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: const BoxDecoration(
                          color: AppColors.bgLight,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                          border: Border(bottom: BorderSide(color: AppColors.border)),
                        ),
                        child: Row(
                          children: [
                            _TableHeaderCell('Name', flex: 3),
                            _TableHeaderCell('Department', flex: 2),
                            _TableHeaderCell('Designation', flex: 2),
                            _TableHeaderCell('Status', flex: 2),
                            _TableHeaderCell('Actions', flex: 1),
                          ],
                        ),
                      ),
                      // Table Rows
                      Expanded(
                        child: SizedBox(
                          width: isMobile ? 800 : (MediaQuery.of(context).size.width > 1100 ? MediaQuery.of(context).size.width - 300 : 800),
                          child: ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderSubtle),
                            itemBuilder: (_, i) => _EmployeeTableRow(employee: filtered[i]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  const _TableHeaderCell(this.text, {required this.flex});
  @override
  Widget build(BuildContext context) => Expanded(flex: flex, child: Text(text, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.slateGray, letterSpacing: 0.5)));
}

class _EmployeeRow {
  final String name, email, dept, role, status, initials;
  _EmployeeRow(this.name, this.email, this.dept, this.role, this.status, this.initials);
}

class _EmployeeTableRow extends StatelessWidget {
  final _EmployeeRow employee;
  const _EmployeeTableRow({required this.employee});

  @override
  Widget build(BuildContext context) {
    final statusColor = employee.status == 'Active' ? AppColors.green : (employee.status == 'On Leave' ? AppColors.amber : AppColors.slateGray);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.actionBlue.withOpacity(0.1),
                  child: Text(employee.initials, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.actionBlue)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(employee.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyDeep)),
                    Text(employee.email, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(employee.dept, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
          Expanded(flex: 2, child: Text(employee.role, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(employee.status, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility_outlined, size: 16, color: AppColors.slateGray), 
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Viewing profile: ${employee.name}')),
                    );
                  }, 
                  tooltip: 'View', 
                  padding: EdgeInsets.zero, 
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32)
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.slateGray), 
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening editor for: ${employee.name}')),
                    );
                  }, 
                  tooltip: 'Edit', 
                  padding: EdgeInsets.zero, 
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Information Tab — Vertical Sub-menu ────────────────────────
class _InformationTab extends StatefulWidget {
  const _InformationTab();
  @override
  State<_InformationTab> createState() => _InformationTabState();
}

class _InformationTabState extends State<_InformationTab> {
  String _selected = 'Personal Details';

  final _subSections = [
    ('Personal Details', Icons.person_outline_rounded),
    ('Bank / PF Details', Icons.account_balance_outlined),
    ('Salary History', Icons.payments_outlined),
    ('Documents', Icons.folder_outlined),
  ];

  Widget _buildContent() {
    switch (_selected) {
      case 'Bank / PF Details': return const _BankPFView();
      case 'Salary History':   return const _SalaryHistoryView();
      case 'Documents':        return const _DocumentsView();
      default:                 return const _PersonalDetailsView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        final menu = Container(
          width: isMobile ? double.infinity : 220,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              right: isMobile ? BorderSide.none : const BorderSide(color: AppColors.border),
              bottom: isMobile ? const BorderSide(color: AppColors.border) : BorderSide.none,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Information', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slateGray, letterSpacing: 0.6)),
              ),
              if (isMobile) 
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _subSections.map((s) => _SubMenuItem(
                      icon: s.$2, 
                      label: s.$1, 
                      selected: _selected == s.$1, 
                      onTap: () => setState(() => _selected = s.$1),
                      isMobile: true,
                    )).toList(),
                  ),
                )
              else 
                ..._subSections.map((s) => _SubMenuItem(icon: s.$2, label: s.$1, selected: _selected == s.$1, onTap: () => setState(() => _selected = s.$1))),
            ],
          ),
        );

        final content = Expanded(child: _buildContent());

        return isMobile 
          ? Column(children: [menu, content]) 
          : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [menu, content]);
      }
    );
  }
}

class _SubMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isMobile;
  const _SubMenuItem({required this.icon, required this.label, required this.selected, required this.onTap, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8, vertical: isMobile ? 8 : 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.actionBlue.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: selected ? Border.all(color: AppColors.actionBlue.withOpacity(0.2)) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: selected ? AppColors.actionBlue : AppColors.slateGray),
            const SizedBox(width: 10),
            Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.w500, color: selected ? AppColors.actionBlue : AppColors.navyDeep)),
          ],
        ),
      ),
    );
  }
}

class _PersonalDetailsView extends StatelessWidget {
  const _PersonalDetailsView();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal Details', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
          const SizedBox(height: 6),
          Text('Core employee profile information', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray)),
          const SizedBox(height: 24),
          // Profile Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.actionBlue.withOpacity(0.1),
                  child: Text('JS', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.actionBlue)),
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('John Smith', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                    const SizedBox(height: 4),
                    Text('Senior Developer • Engineering', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray)),
                    const SizedBox(height: 8),
                    Row(children: [
                      _StatusChip('Active', AppColors.green),
                      const SizedBox(width: 8),
                      _StatusChip('EMP-001', AppColors.slateGray),
                    ]),
                  ],
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Editing profile details...')),
                    );
                  },
                  style: FilledButton.styleFrom(backgroundColor: AppColors.actionBlue),
                  child: Text('Edit Profile', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _InfoGrid(items: const [
            ('Full Name', 'John Smith'),
            ('Date of Birth', 'Jan 15, 1993'),
            ('Gender', 'Male'),
            ('Nationality', 'Indian'),
            ('Phone', '+91 98765 43210'),
            ('Personal Email', 'john.personal@email.com'),
            ('Address', '12 MG Road, Bengaluru'),
            ('Emergency Contact', 'Mary Smith (+91 90000 00001)'),
          ]),
        ],
      ),
    );
  }
}

class _BankPFView extends StatelessWidget {
  const _BankPFView();
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(28),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Bank & PF Details', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
      const SizedBox(height: 24),
      _InfoGrid(items: const [
        ('Bank Name', 'HDFC Bank'),
        ('Account Number', '••••••••4521'),
        ('IFSC Code', 'HDFC0001234'),
        ('Account Type', 'Savings'),
        ('PF Account', 'KA/BN/12345/123'),
        ('UAN Number', '100123456789'),
        ('PF Contribution', '12% of Basic'),
        ('ESI Number', 'N/A'),
      ]),
    ]),
  );
}

class _SalaryHistoryView extends StatelessWidget {
  const _SalaryHistoryView();

  final _history = const [
    ('Apr 2025', '₹ 95,000', 'Current'),
    ('Jan 2025', '₹ 90,000', 'Revision +5.5%'),
    ('Jul 2024', '₹ 85,000', 'Revision +6.2%'),
    ('Jan 2024', '₹ 80,000', 'Joining'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Salary History', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Row(children: [
                Expanded(child: Text('Period', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.slateGray))),
                Expanded(child: Text('Amount', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.slateGray))),
                Expanded(child: Text('Note', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.slateGray))),
              ]),
            ),
            ..._history.map((h) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(children: [
                Expanded(child: Text(h.$1, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyDeep))),
                Expanded(child: Text(h.$2, style: GoogleFonts.inter(fontSize: 13, color: AppColors.navyDeep))),
                Expanded(child: Text(h.$3, style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateGray))),
              ]),
            )),
          ]),
        ),
      ]),
    );
  }
}

class _DocumentsView extends StatelessWidget {
  const _DocumentsView();

  final _docs = const [
    (Icons.picture_as_pdf_rounded, 'Offer Letter', '1.2 MB', 'Jan 2024'),
    (Icons.picture_as_pdf_rounded, 'Employment Contract', '2.4 MB', 'Jan 2024'),
    (Icons.image_outlined, 'Aadhaar Card', '0.5 MB', 'Jan 2024'),
    (Icons.image_outlined, 'PAN Card', '0.3 MB', 'Jan 2024'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Documents', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
          const Spacer(),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening document upload portal...')),
              );
            },
            icon: const Icon(Icons.upload_rounded, size: 16),
            label: const Text('Upload'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.actionBlue, textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ]),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.6),
          itemCount: _docs.length,
          itemBuilder: (_, i) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(_docs[i].$1, color: AppColors.red, size: 28),
              const Spacer(),
              Text(_docs[i].$2, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyDeep)),
              Text('${_docs[i].$3} • ${_docs[i].$4}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ─── Admin Tab ──────────────────────────────────────────────────
class _AdminTab extends StatelessWidget {
  const _AdminTab();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Admin Actions', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
          const SizedBox(height: 6),
          Text('Bulk operations and access management', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray)),
          const SizedBox(height: 24),
          // Action Grid
          GridView.count(
            crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.8,
            children: const [
              _AdminActionCard(icon: Icons.file_upload_outlined, title: 'Import Employees', subtitle: 'Upload CSV', color: AppColors.actionBlue),
              _AdminActionCard(icon: Icons.file_download_outlined, title: 'Export Data', subtitle: 'CSV / Excel', color: AppColors.green),
              _AdminActionCard(icon: Icons.picture_as_pdf_outlined, title: 'Generate Reports', subtitle: 'PDF format', color: AppColors.amber),
              _AdminActionCard(icon: Icons.lock_person_outlined, title: 'Manage Roles', subtitle: 'Access control', color: AppColors.purple),
              _AdminActionCard(icon: Icons.archive_outlined, title: 'Archive Employees', subtitle: 'Deactivate selected', color: AppColors.slateGray),
              _AdminActionCard(icon: Icons.email_outlined, title: 'Send Onboarding', subtitle: 'Email invite', color: AppColors.actionBlue),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _AdminActionCard({required this.icon, required this.title, required this.subtitle, required this.color});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigating to $title...')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 20, color: color),
            ),
            const Spacer(),
            Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyDeep)),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppColors.slateGray)),
          ]),
        ),
      ),
    );
  }
}

// ─── Setup Tab ──────────────────────────────────────────────────
class _SetupTab extends StatefulWidget {
  const _SetupTab();
  @override
  State<_SetupTab> createState() => _SetupTabState();
}

class _SetupTabState extends State<_SetupTab> {
  bool _probation = true;
  bool _noticePeriod = true;
  bool _overtime = false;
  bool _flexiHours = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Employee Setup', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
          const SizedBox(height: 6),
          Text('Configure policies and default values', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray)),
          const SizedBox(height: 24),
          _SectionCard(
            title: 'Policy Toggles',
            children: [
              _ToggleRow(label: 'Probation Period (90 days)', subtitle: 'New employees go through a 90-day probation', value: _probation, onChanged: (v) => setState(() => _probation = v)),
              _ToggleRow(label: 'Notice Period Required', subtitle: 'Employees must serve 30 days notice', value: _noticePeriod, onChanged: (v) => setState(() => _noticePeriod = v)),
              _ToggleRow(label: 'Overtime Tracking', subtitle: 'Log and compensate extra hours', value: _overtime, onChanged: (v) => setState(() => _overtime = v)),
              _ToggleRow(label: 'Flexible Working Hours', subtitle: 'Allow employees to set custom hours', value: _flexiHours, onChanged: (v) => setState(() => _flexiHours = v)),
            ],
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Departments',
            children: [
              Row(children: [
                Expanded(child: Text('Engineering, HR, Finance, Marketing, Operations', style: GoogleFonts.inter(fontSize: 13, color: AppColors.navyDeep))),
                TextButton.icon(onPressed: () {}, icon: const Icon(Icons.edit_outlined, size: 16), label: const Text('Edit')),
              ]),
            ],
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Designation Levels',
            children: [
              Row(children: [
                Expanded(child: Text('Intern, Junior, Mid, Senior, Lead, Manager, Director, C-Level', style: GoogleFonts.inter(fontSize: 13, color: AppColors.navyDeep))),
                TextButton.icon(onPressed: () {}, icon: const Icon(Icons.edit_outlined, size: 16), label: const Text('Edit')),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Shared Small Widgets ─────────────────────────────────────────
class _InfoGrid extends StatelessWidget {
  final List<(String, String)> items;
  const _InfoGrid({required this.items});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 24, mainAxisSpacing: 20, childAspectRatio: 3),
        itemCount: items.length,
        itemBuilder: (_, i) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(items[i].$1, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.slateGray, letterSpacing: 0.4)),
            const SizedBox(height: 4),
            Text(items[i].$2, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.navyDeep)),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
    child: Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
  );
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
        const SizedBox(height: 16),
        ...children,
      ],
    ),
  );
}

class _ToggleRow extends StatelessWidget {
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.label, required this.subtitle, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyDeep)),
          Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppColors.slateGray)),
        ])),
        Switch.adaptive(value: value, onChanged: onChanged, activeColor: AppColors.actionBlue),
      ],
    ),
  );
}

class _DialogInput extends StatelessWidget {
  final String label, hint;
  const _DialogInput({required this.label, required this.hint});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slateGray)),
      const SizedBox(height: 6),
      TextFormField(
        style: GoogleFonts.inter(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.actionBlue, width: 2)),
          filled: true, fillColor: AppColors.bgLight,
        ),
      ),
    ],
  );
}
