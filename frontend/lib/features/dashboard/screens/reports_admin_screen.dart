import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class ReportsAdminScreen extends StatelessWidget {
  const ReportsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = MediaQuery.of(context).size.width < 600;
              final header = [
                Expanded(
                  flex: isMobile ? 0 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reports & Analytics', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.navyDeep, letterSpacing: -0.5)),
                      Text('Pre-built reports and custom query builder', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray)),
                    ],
                  ),
                ),
                if (isMobile) const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preparing consolidated report for export...')),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                  label: const Text('Combine & Export'),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.actionBlue, textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ];
              return isMobile ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: header) : Row(children: header);
            }
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 900;
              final content = [
                Expanded(
                  flex: isMobile ? 0 : 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Report Directory', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: isMobile ? 1 : 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: isMobile ? 3.5 : 2.5,
                        children: const [
                          _ReportCard('Q1 Output', 'Headcount & Attrition', Icons.people_alt_outlined, AppColors.actionBlue),
                          _ReportCard('Payroll Register', 'Detailed monthly payouts', Icons.payments_outlined, AppColors.green),
                          _ReportCard('Diversity Metrics', 'Gender & Demographic breakdown', Icons.pie_chart_outline_rounded, AppColors.purple),
                          _ReportCard('Leave Balances', 'Aggregated accrued liability', Icons.event_available_outlined, AppColors.amber),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isMobile) const SizedBox(height: 32) else const SizedBox(width: 24),
                Expanded(
                  flex: isMobile ? 0 : 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Query Builder', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Select Model', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slateGray)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(8)),
                              child: Row(children: [Text('Employees', style: GoogleFonts.inter(fontSize: 13, color: AppColors.navyDeep)), const Spacer(), const Icon(Icons.arrow_drop_down, color: AppColors.slateGray)]),
                            ),
                            const SizedBox(height: 16),
                            Text('Fields to Export', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slateGray)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8, runSpacing: 8,
                              children: ['Name', 'Department', 'Salary', '+ Add Field'].map((f) => Chip(
                                label: Text(f, style: GoogleFonts.inter(fontSize: 12, color: f.startsWith('+') ? AppColors.actionBlue : AppColors.navyDeep, fontWeight: f.startsWith('+') ? FontWeight.w600 : FontWeight.w500)),
                                backgroundColor: f.startsWith('+') ? AppColors.actionBlue.withOpacity(0.1) : AppColors.surface,
                                side: BorderSide(color: f.startsWith('+') ? Colors.transparent : AppColors.border),
                                deleteIcon: f.startsWith('+') ? null : const Icon(Icons.close, size: 14),
                                onDeleted: f.startsWith('+') ? null : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Removing field: $f')),
                                  );
                                },
                              )).toList(),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Generating custom CSV report...')),
                                  );
                                }, 
                                style: FilledButton.styleFrom(backgroundColor: AppColors.navyDeep), 
                                child: const Text('Generate CSV')
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ];
              return isMobile ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: content) : Row(children: content);
            }
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title, sub;
  final IconData icon;
  final Color color;
  const _ReportCard(this.title, this.sub, this.icon, this.color);
  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading report: $title')),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                  const SizedBox(height: 4),
                  Text(sub, style: GoogleFonts.inter(fontSize: 11, color: AppColors.slateGray)),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
