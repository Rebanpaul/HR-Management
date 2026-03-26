import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

// ─── Payroll Admin Screen (3 Tabs) ──────────────────────────────
class PayrollAdminScreen extends StatefulWidget {
  const PayrollAdminScreen({super.key});

  @override
  State<PayrollAdminScreen> createState() => _PayrollAdminScreenState();
}

class _PayrollAdminScreenState extends State<PayrollAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                        Text('Payroll', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.navyDeep, letterSpacing: -0.5)),
                        Text('March 2025 • Run Payroll by Mar 31', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(color: AppColors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.amber.withOpacity(0.3))),
                    child: Row(children: [
                      const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.amber),
                      const SizedBox(width: 8),
                      Text('3 revisions pending verification', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.amber)),
                    ]),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow_rounded, size: 16),
                    label: const Text('Run Payroll'),
                    style: FilledButton.styleFrom(backgroundColor: AppColors.green, textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
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
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: AppColors.border,
                tabs: const [
                  Tab(text: 'Information'),
                  Tab(text: 'Payroll Inputs'),
                  Tab(text: 'Verify'),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _PayrollInfoTab(),
              _PayrollInputsTab(),
              _PayrollVerifyTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Information Tab ─────────────────────────────────────────────
class _PayrollInfoTab extends StatelessWidget {
  const _PayrollInfoTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Summary
          Row(children: const [
            Expanded(child: _PayrollKpi(title: 'Total Payroll', value: '₹ 13,45,000', sub: 'Mar 2025', color: AppColors.actionBlue)),
            SizedBox(width: 16),
            Expanded(child: _PayrollKpi(title: 'Average Salary', value: '₹ 94,718', sub: 'Across 142 employees', color: AppColors.green)),
            SizedBox(width: 16),
            Expanded(child: _PayrollKpi(title: 'Pay Period', value: 'Mar 1–31', sub: 'Monthly cycle', color: AppColors.slateGray)),
            SizedBox(width: 16),
            Expanded(child: _PayrollKpi(title: 'Pending Items', value: '3', sub: 'Require review', color: AppColors.amber)),
          ]),
          const SizedBox(height: 24),
          // Payroll Component Breakdown
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payroll Components', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                const SizedBox(height: 16),
                ...[
                  ('Basic Salary', '₹ 7,80,000', AppColors.actionBlue),
                  ('HRA', '₹ 2,34,000', AppColors.green),
                  ('Special Allowance', '₹ 1,56,000', AppColors.purple),
                  ('PF Deduction', '−₹ 93,600', AppColors.red),
                  ('TDS', '−₹ 65,000', AppColors.red),
                ].map((c) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: c.$3, borderRadius: BorderRadius.circular(3))),
                    const SizedBox(width: 12),
                    Expanded(child: Text(c.$1, style: GoogleFonts.inter(fontSize: 13, color: AppColors.navyDeep))),
                    Text(c.$2, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: c.$3)),
                  ]),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PayrollKpi extends StatelessWidget {
  final String title, value, sub;
  final Color color;
  const _PayrollKpi({required this.title, required this.value, required this.sub, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.slateGray)),
      const SizedBox(height: 8),
      Text(value, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: color, letterSpacing: -0.5)),
      const SizedBox(height: 4),
      Text(sub, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
    ]),
  );
}

// ─── Payroll Inputs Tab ──────────────────────────────────────────
class _PayrollInputsTab extends StatelessWidget {
  const _PayrollInputsTab();

  // Salary Revisions: (name, prev, current, delta%)
  static const _revisions = [
    ('John Smith', '₹ 90,000', '₹ 95,000', 5.5),
    ('Rachel Brown', '₹ 70,000', '₹ 78,000', 11.4), // >5% highlight
    ('Marcus Kim', '₹ 80,000', '₹ 82,500', 3.1),
  ];

  static const _overtime = [
    ('Lily Nguyen', 'Marketing', '12 hrs', '₹ 6,000'),
    ('Tom Richards', 'Engineering', '8 hrs', '₹ 5,200'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salary Revisions
          Text('Salary Revisions', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
          const SizedBox(height: 4),
          Text('Changes effective this payroll period', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateGray)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Column(children: [
              _TableHead(const ['Employee', 'Previous', 'Revised', 'Change %', 'Status']),
              ..._revisions.map((r) {
                final isLarge = r.$4 > 5.0;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  color: isLarge ? AppColors.amber.withOpacity(0.04) : Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(child: Text(r.$1, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyDeep))),
                      Expanded(child: Text(r.$2, style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray))),
                      Expanded(child: Text(r.$3, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyDeep))),
                      Expanded(
                        child: Row(children: [
                          Icon(Icons.trending_up_rounded, size: 14, color: isLarge ? AppColors.amber : AppColors.green),
                          const SizedBox(width: 4),
                          Text('+${r.$4}%', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: isLarge ? AppColors.amber : AppColors.green)),
                          if (isLarge) ...[
                            const SizedBox(width: 8),
                            Tooltip(
                              message: '>5% change — requires review',
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.amber.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                                child: Text('Review', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.amber)),
                              ),
                            ),
                          ],
                        ]),
                      ),
                      Expanded(child: Text(isLarge ? 'Pending Review' : 'Approved', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isLarge ? AppColors.amber : AppColors.green))),
                    ],
                  ),
                );
              }),
            ]),
          ),
          const SizedBox(height: 28),
          // Overtime Register
          Text('Overtime Register', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Column(children: [
              _TableHead(const ['Employee', 'Department', 'OT Hours', 'OT Pay']),
              ..._overtime.map((o) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(children: [
                  Expanded(child: Text(o.$1, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyDeep))),
                  Expanded(child: Text(o.$2, style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray))),
                  Expanded(child: Text(o.$3, style: GoogleFonts.inter(fontSize: 13, color: AppColors.navyDeep))),
                  Expanded(child: Text(o.$4, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.green))),
                ]),
              )),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─── Verify Tab (Side-by-side diff, >5% amber) ──────────────────
class _PayrollVerifyTab extends StatelessWidget {
  const _PayrollVerifyTab();

  // (Name, lastMonth salary, thisMonth salary)
  static const _data = [
    ('John Smith',       85000.0, 95000.0),
    ('Aisha Williams',   72000.0, 72000.0),
    ('Marcus Kim',       80000.0, 82500.0),
    ('Rachel Brown',     64000.0, 72000.0), // big jump
    ('Lily Nguyen',      55000.0, 55000.0),
    ('David Wilson',     90000.0, 90000.0),
    ('Sara Patel',      150000.0,150000.0),
    ('Tom Richards',     78000.0, 80000.0),
  ];

  double _pct(double prev, double curr) => ((curr - prev) / prev) * 100;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Payroll Verification', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.amber.withOpacity(0.3))),
              child: Row(children: [
                const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.amber),
                const SizedBox(width: 6),
                Text('Highlighted rows have >5% variation', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.amber)),
              ]),
            ),
          ]),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Column(children: [
              _TableHead(const ['Employee', 'Feb 2025', 'Mar 2025', 'Difference', 'Change %', 'Flag']),
              ..._data.map((d) {
                final pct = _pct(d.$2, d.$3);
                final diff = d.$3 - d.$2;
                final isWarning = pct.abs() > 5;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: isWarning ? AppColors.amber.withOpacity(0.05) : Colors.transparent,
                    border: Border(left: BorderSide(color: isWarning ? AppColors.amber : Colors.transparent, width: 3)),
                  ),
                  child: Row(children: [
                    Expanded(child: Text(d.$1, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyDeep))),
                    Expanded(child: Text('₹ ${_fmt(d.$2)}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray))),
                    Expanded(child: Text('₹ ${_fmt(d.$3)}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.navyDeep))),
                    Expanded(child: Text('${diff >= 0 ? '+' : ''}₹ ${_fmt(diff)}', style: GoogleFonts.inter(fontSize: 13, color: diff >= 0 ? AppColors.green : AppColors.red))),
                    Expanded(child: Text('${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(1)}%', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: isWarning ? AppColors.amber : AppColors.slateGray))),
                    Expanded(child: isWarning
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.amber.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                          child: Text('Needs Review', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.amber)),
                        )
                      : Text('OK', style: GoogleFonts.inter(fontSize: 12, color: AppColors.green, fontWeight: FontWeight.w600)),
                    ),
                  ]),
                );
              }),
            ]),
          ),
        ],
      ),
    );
  }

  String _fmt(double n) => n.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}

// ─── Shared Widgets ──────────────────────────────────────────────
class _TableHead extends StatelessWidget {
  final List<String> cols;
  const _TableHead(this.cols);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: const BoxDecoration(
      color: AppColors.bgLight,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      border: Border(bottom: BorderSide(color: AppColors.border)),
    ),
    child: Row(
      children: cols.map((c) => Expanded(child: Text(c, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.slateGray, letterSpacing: 0.5)))).toList(),
    ),
  );
}
