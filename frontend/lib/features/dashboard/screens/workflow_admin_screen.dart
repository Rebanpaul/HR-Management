import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class WorkflowAdminScreen extends StatelessWidget {
  const WorkflowAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Workflow Engine', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.navyDeep, letterSpacing: -0.5)),
          Text('Manage approvals and process automation', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray)),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pending My Approval', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                    const SizedBox(height: 16),
                    _ApprovalCard('Expense Report - Q1 Marketing', 'Submitted by Aisha Williams', 'Requires Finance Review', AppColors.amber),
                    _ApprovalCard('Offer Letter - Lead Engineer', 'Submitted by HR Dept', 'Requires Final Sign-off', AppColors.purple),
                    _ApprovalCard('Vendor Payment - Stripe', 'Submitted by Operations', 'Due Tomorrow', AppColors.red),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Workflow Builder', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening Visual Workflow Builder...')),
                            );
                          },
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('New Flow'),
                          style: FilledButton.styleFrom(backgroundColor: AppColors.actionBlue, textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 350,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 2, strokeAlign: BorderSide.strokeAlignInside),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_tree_outlined, size: 48, color: AppColors.border),
                            const SizedBox(height: 16),
                            Text('Drag & Drop Canvas', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.slateGray)),
                            Text('(Interactive builder visualization)', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  final String title, sub, status;
  final Color color;
  const _ApprovalCard(this.title, this.sub, this.status, this.color);
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
    child: Row(
      children: [
        Container(width: 4, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navyDeep)),
              const SizedBox(height: 4),
              Text(sub, style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateGray)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(status, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
              ),
            ],
          ),
        ),
        FilledButton.tonal(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Successfully approved: $title')),
            );
          },
          style: FilledButton.styleFrom(backgroundColor: AppColors.green.withOpacity(0.1), foregroundColor: AppColors.green),
          child: const Text('Approve'),
        ),
      ],
    ),
  );
}
