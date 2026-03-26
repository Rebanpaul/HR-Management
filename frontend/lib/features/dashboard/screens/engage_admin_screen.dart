import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class EngageAdminScreen extends StatelessWidget {
  const EngageAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Employee Engagement', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.navyDeep, letterSpacing: -0.5)),
          Text('Polls, surveys, and company announcements', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray)),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Announcements', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('New Post'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _AnnouncementCard('Q1 All Hands Meeting', 'Join us next Friday at 10 AM for a company-wide update from the executive team.', 'March 22', Icons.campaign_outlined, AppColors.actionBlue),
                    _AnnouncementCard('New Health Insurance Policy', 'Please review the updated benefits document in your portal by EOW.', 'March 20', Icons.health_and_safety_outlined, AppColors.green),
                    
                    const SizedBox(height: 32),
                    
                    Row(
                      children: [
                        Text('Recent Polls', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('Create Poll'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Preferred Summer Activity?', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navyDeep)),
                          const SizedBox(height: 4),
                          Text('64 responses • Ends in 2 days', style: GoogleFonts.inter(fontSize: 11, color: AppColors.slateGray)),
                          const SizedBox(height: 16),
                          _PollOption('Company Retreat (Hill Station)', 45),
                          _PollOption('Team Dinner (Local)', 12),
                          _PollOption('Online Games Tournament', 7),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Upcoming Milestones', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _EventRow('Aisha Williams', 'Birthday', 'Tomorrow', AppColors.purple),
                          const Divider(height: 24, color: AppColors.border),
                          _EventRow('John Smith', '3 Year Work Anniversary', 'Next Week', AppColors.actionBlue),
                          const Divider(height: 24, color: AppColors.border),
                          _EventRow('David Wilson', 'Birthday', 'April 2', AppColors.purple),
                        ],
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

class _AnnouncementCard extends StatelessWidget {
  final String title, sub, date;
  final IconData icon;
  final Color color;
  const _AnnouncementCard(this.title, this.sub, this.date, this.icon, this.color);
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                  Text(date, style: GoogleFonts.inter(fontSize: 11, color: AppColors.slateGray)),
                ],
              ),
              const SizedBox(height: 6),
              Text(sub, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _PollOption extends StatelessWidget {
  final String label;
  final int count;
  const _PollOption(this.label, this.count);
  @override
  Widget build(BuildContext context) {
    final pct = count / 64.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.navyDeep)),
              Text('$count (${(pct*100).toInt()}%)', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.slateGray)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: pct, color: AppColors.actionBlue, backgroundColor: AppColors.border, minHeight: 8),
          ),
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  final String name, event, date;
  final Color color;
  const _EventRow(this.name, this.event, this.date, this.color);
  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(radius: 16, backgroundColor: color.withOpacity(0.1), child: Text(name[0], style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: color))),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyDeep)),
            Text(event, style: GoogleFonts.inter(fontSize: 11, color: AppColors.slateGray)),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: AppColors.borderSubtle, borderRadius: BorderRadius.circular(6)),
        child: Text(date, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.slateGray)),
      ),
    ],
  );
}
