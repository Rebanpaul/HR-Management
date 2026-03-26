import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ess_theme.dart';

class EesSalaryView extends StatelessWidget {
  const EesSalaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                Tab(text: 'Payslips'),
                Tab(text: 'YTD Reports'),
                Tab(text: 'Reimbursements'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildPayslipsTab(context),
                _buildYTDTab(context),
                _buildReimbursementsTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayslipsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _MobileFirstSalaryCard('March 2026', '₹ 1,12,450', 'Credited: Apr 1, 2026', EssTheme.success),
        _MobileFirstSalaryCard('February 2026', '₹ 1,12,450', 'Credited: Mar 1, 2026', EssTheme.success),
        _MobileFirstSalaryCard('January 2026', '₹ 1,10,200', 'Credited: Feb 1, 2026', EssTheme.success),
      ],
    );
  }

  Widget _buildYTDTab(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Icon(Icons.pie_chart_outline_rounded, size: 48, color: EssTheme.textMuted),
           const SizedBox(height: 16),
           Text('Year-To-Date Summary', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: EssTheme.textPrimary)),
           Text('Financial Year 2025-26 will be available soon.', style: GoogleFonts.inter(color: EssTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildReimbursementsTab(BuildContext context) {
     return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Claims', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
            FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 18), label: const Text('New Claim')),
          ],
        ),
        const SizedBox(height: 16),
        _MobileFirstSalaryCard('Client Dinner - EXP002', '₹ 4,500', 'Pending Approval', EssTheme.warning, icon: Icons.restaurant_rounded),
        _MobileFirstSalaryCard('Internet Allowance - EXP001', '₹ 1,200', 'Reimbursed', EssTheme.success, icon: Icons.wifi_rounded),
      ],
    );
  }
}

class _MobileFirstSalaryCard extends StatelessWidget {
  final String title, amount, status;
  final Color statusColor;
  final IconData icon;

  const _MobileFirstSalaryCard(this.title, this.amount, this.status, this.statusColor, {this.icon = Icons.receipt_long_rounded});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: EssTheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: EssTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: EssTheme.slateBlueLight.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: EssTheme.slateBlue, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
                    const SizedBox(height: 4),
                    Text(status, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: statusColor)),
                  ],
                ),
              ),
              Text(amount, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: EssTheme.textPrimary)),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening detailed view...'))), 
                icon: const Icon(Icons.visibility_outlined, size: 18), 
                label: Text('View Details', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                style: TextButton.styleFrom(foregroundColor: EssTheme.slateBlue),
              ),
              TextButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading payslip PDF...'))), 
                icon: const Icon(Icons.file_download_outlined, size: 18), 
                label: Text('Download', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                style: TextButton.styleFrom(foregroundColor: EssTheme.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
