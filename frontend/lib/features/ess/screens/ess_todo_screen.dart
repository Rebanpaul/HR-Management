import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ess_theme.dart';

class EssTodoScreen extends StatelessWidget {
  const EssTodoScreen({super.key});

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
                Tab(text: 'My Tasks'),
                Tab(text: 'My Reviews (Manager)'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              children: [
                _buildTaskList(context),
                _buildReviewsList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _SectionHeader('Overdue', EssTheme.error),
        _TodoItem('Submit Q1 Self-Appraisal', 'Due: March 20', isOverdue: true),
        const SizedBox(height: 24),
        
        _SectionHeader('Pending', EssTheme.warning),
        _TodoItem('Complete Annual Compliance Training', 'Due: April 5'),
        _TodoItem('Update Emergency Contact Details', 'Due: April 10'),
        const SizedBox(height: 24),
        
        _SectionHeader('Completed', EssTheme.success),
        _TodoItem('Finalize Project X Deliverables', 'Completed: March 15', isCompleted: true),
        _TodoItem('Upload Identity Documents', 'Completed: March 12', isCompleted: true),
      ],
    );
  }

  Widget _buildReviewsList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _SectionHeader('Pending Approvals', EssTheme.warning),
        _ReviewItem('Leave Request: David Wilson', 'April 10 - April 14 (Annual Leave)'),
        _ReviewItem('Expense Claim: Sara Patel', '₹ 4,500 (Client Dinner Allocation)'),
        const SizedBox(height: 24),
        
        _SectionHeader('Appraisal Reviews', EssTheme.slateBlue),
        _ReviewItem('Performance Review: Marcus Kim', 'Waiting for Manager Assessment'),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionHeader(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
        ],
      ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  final String title, subtitle;
  final bool isOverdue, isCompleted;

  const _TodoItem(this.title, this.subtitle, {this.isOverdue = false, this.isCompleted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: EssTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: EssTheme.border)),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle_rounded : (isOverdue ? Icons.error_rounded : Icons.radio_button_unchecked_rounded),
            color: isCompleted ? EssTheme.success : (isOverdue ? EssTheme.error : EssTheme.textMuted),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: isCompleted ? EssTheme.textMuted : EssTheme.textPrimary, decoration: isCompleted ? TextDecoration.lineThrough : null)),
                const SizedBox(height: 4),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: isOverdue ? EssTheme.error : EssTheme.textSecondary)),
              ],
            ),
          ),
          if (!isCompleted)
            OutlinedButton(
              onPressed: () {},
              child: const Text('Start'),
            ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String title, subtitle;

  const _ReviewItem(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: EssTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: EssTheme.border)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: EssTheme.warning.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.grading_rounded, color: EssTheme.warning, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: EssTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: EssTheme.textSecondary)),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {},
            child: const Text('Review'),
          ),
        ],
      ),
    );
  }
}
