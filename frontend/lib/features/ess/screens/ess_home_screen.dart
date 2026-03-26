import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ess_theme.dart';

class EssHomeScreen extends StatefulWidget {
  const EssHomeScreen({super.key});

  @override
  State<EssHomeScreen> createState() => _EssHomeScreenState();
}

class _EssHomeScreenState extends State<EssHomeScreen> {
  bool _isSignedIn = false;
  String? _signInTime;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Welcome back, John!', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: EssTheme.textPrimary)),
              Text('Thursday, March 26', style: GoogleFonts.inter(fontSize: 14, color: EssTheme.textSecondary)),
            ],
          ),
          const SizedBox(height: 32),
          
          // ── Quick Actions ───────────────────────────────────
          Text('Quick Actions', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              int columns = constraints.maxWidth > 800 ? 4 : (constraints.maxWidth > 400 ? 2 : 1);
              final width = (constraints.maxWidth - ((columns - 1) * 16)) / columns;
              
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                   _QuickActionCard(
                     title: _isSignedIn ? 'Sign Out' : 'Sign In', 
                     subtitle: _isSignedIn ? 'Started at $_signInTime' : '9:00 AM Shift', 
                     icon: _isSignedIn ? Icons.logout_rounded : Icons.login_rounded, 
                     color: _isSignedIn ? EssTheme.error : EssTheme.success, 
                     width: width,
                     onTap: () {
                       setState(() {
                         _isSignedIn = !_isSignedIn;
                         if (_isSignedIn) {
                           final now = DateTime.now();
                           _signInTime = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
                         }
                       });
                     },
                   ),
                   _QuickActionCard(title: 'Apply Leave', subtitle: 'Balance: 12', icon: Icons.event_available_rounded, color: EssTheme.slateBlue, width: width, onTap: () {}),
                   _QuickActionCard(title: 'Reimbursement', subtitle: 'Submit expenses', icon: Icons.receipt_long_rounded, color: EssTheme.warning, width: width, onTap: () {}),
                   _QuickActionCard(title: 'Help Desk', subtitle: 'IT & Facilities', icon: Icons.support_agent_rounded, color: EssTheme.info, width: width, onTap: () {}),
                ],
              );
            }
          ),
          const SizedBox(height: 48),

          // ── Two Column Layout (Desktop) or Stack (Mobile) ────────
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 800;
              final content = [
                // Left Column: At a Glance Cards
                Expanded(
                  flex: isMobile ? 0 : 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('At a Glance', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
                      const SizedBox(height: 16),
                      _AtAGlanceCard(
                        title: 'Latest Payslip',
                        subtitle: 'March 2026',
                        value: '₹ 1,12,450',
                        actionText: 'View Details',
                        icon: Icons.account_balance_wallet_rounded,
                        color: EssTheme.slateBlue,
                      ),
                      const SizedBox(height: 16),
                      _AtAGlanceCard(
                        title: 'Performance Review',
                        subtitle: 'Q1 Appraisals',
                        value: 'Pending Self-Review',
                        actionText: 'Start Review',
                        icon: Icons.star_border_rounded,
                        color: EssTheme.warning,
                      ),
                    ],
                  ),
                ),
                if (!isMobile) const SizedBox(width: 32),
                if (isMobile) const SizedBox(height: 48),
                // Right Column: Mini Calendar
                Expanded(
                  flex: isMobile ? 0 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Upcoming Holidays', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: EssTheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: EssTheme.border),
                        ),
                        child: Column(
                          children: [
                            _HolidayRow('Good Friday', 'April 3', EssTheme.slateBlue),
                            const Divider(height: 24),
                            _HolidayRow('Labour Day', 'May 1', EssTheme.warning),
                            const Divider(height: 24),
                            _HolidayRow('Independence Day', 'August 15', EssTheme.success),
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
        ],
      ),
    );
  }
}

// ─── Sub-Components ────────────────────────────────────────────────────────

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double width;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: EssTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: EssTheme.border),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 20),
            Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
            const SizedBox(height: 4),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: EssTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _AtAGlanceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String actionText;
  final IconData icon;
  final Color color;

  const _AtAGlanceCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.actionText,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: EssTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EssTheme.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 13, color: EssTheme.textSecondary)),
                const SizedBox(height: 4),
                Text(value, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: EssTheme.textMuted)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: color),
            child: Text(actionText, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _HolidayRow extends StatelessWidget {
  final String name;
  final String date;
  final Color color;

  const _HolidayRow(this.name, this.date, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 24, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 12),
        Expanded(child: Text(name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: EssTheme.textPrimary))),
        Text(date, style: GoogleFonts.inter(fontSize: 13, color: EssTheme.textSecondary)),
      ],
    );
  }
}
