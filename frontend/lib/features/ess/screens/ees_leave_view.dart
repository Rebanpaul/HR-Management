import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ess_theme.dart';

class EesLeaveView extends StatelessWidget {
  const EesLeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;

          final content = [
            // Left: Leave Balances (Donut Charts)
            Expanded(
              flex: isMobile ? 0 : 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Leave Balances', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
                       FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening Leave Application...'))), icon: const Icon(Icons.add, size: 16), label: const Text('Apply')),
                     ],
                   ),
                   const SizedBox(height: 16),
                   _LeaveBalanceCard('Annual Leave', 12, 20, EssTheme.slateBlue),
                   const SizedBox(height: 16),
                   _LeaveBalanceCard('Sick Leave', 5, 8, EssTheme.warning),
                   const SizedBox(height: 16),
                   _LeaveBalanceCard('Optional Holiday', 1, 2, EssTheme.success),
                ],
              ),
            ),
            if (!isMobile) const SizedBox(width: 32),
            if (isMobile) const SizedBox(height: 32),

            // Right: Upcoming / History
            Expanded(
              flex: isMobile ? 0 : 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Leave History', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: EssTheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: EssTheme.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HistoryRow('Sick Leave', 'Mar 10 - Mar 11, 2026', 'Approved', EssTheme.success),
                        const Divider(height: 32),
                        _HistoryRow('Annual Leave', 'Feb 12 - Feb 14, 2026', 'Approved', EssTheme.success),
                        const Divider(height: 32),
                        _HistoryRow('Annual Leave', 'Dec 24 - Dec 31, 2025', 'Approved', EssTheme.success),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];

          if (isMobile) {
            return Column(children: content.whereType<Expanded>().map((e) => e.child).toList());
          } else {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: content);
          }
        },
      ),
    );
  }
}

class _LeaveBalanceCard extends StatelessWidget {
  final String title;
  final int remaining;
  final int total;
  final Color color;

  const _LeaveBalanceCard(this.title, this.remaining, this.total, this.color);

  @override
  Widget build(BuildContext context) {
    final double pct = remaining / total;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: EssTheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: EssTheme.border)),
      child: Row(
        children: [
          // Simulated Donut Chart
           SizedBox(
             width: 64, height: 64,
             child: Stack(
               fit: StackFit.expand,
               children: [
                 CircularProgressIndicator(value: 1.0, color: color.withValues(alpha: 0.1), strokeWidth: 8),
                 CircularProgressIndicator(value: pct, color: color, strokeWidth: 8, strokeCap: StrokeCap.round),
                 Center(child: Text('$remaining', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: EssTheme.textPrimary))),
               ],
             ),
           ),
           const SizedBox(width: 24),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
                 const SizedBox(height: 4),
                 Text('Remaining out of $total days', style: GoogleFonts.inter(fontSize: 12, color: EssTheme.textSecondary)),
               ],
             ),
           ),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final String type, date, status;
  final Color statusColor;

  const _HistoryRow(this.type, this.date, this.status, this.statusColor);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: EssTheme.textPrimary)),
            const SizedBox(height: 4),
            Text(date, style: GoogleFonts.inter(fontSize: 12, color: EssTheme.textSecondary)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Text(status, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor)),
        ),
      ],
    );
  }
}
