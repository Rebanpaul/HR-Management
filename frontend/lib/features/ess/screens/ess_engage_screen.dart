import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ess_theme.dart';

class EssEngageScreen extends StatelessWidget {
  const EssEngageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          
          final content = [
            // Feed
            Expanded(
              flex: isMobile ? 0 : 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   // Post Composer
                   Container(
                     padding: const EdgeInsets.all(20),
                     decoration: BoxDecoration(color: EssTheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: EssTheme.border)),
                     child: Row(
                       children: [
                         CircleAvatar(backgroundColor: EssTheme.slateBlueLight.withValues(alpha: 0.2), child: Text('JS', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: EssTheme.slateBlue))),
                         const SizedBox(width: 16),
                         Expanded(
                           child: TextField(
                             decoration: InputDecoration(
                               hintText: "Share an update or give kudos...",
                               border: InputBorder.none,
                             ),
                           ),
                         ),
                         IconButton(icon: const Icon(Icons.image_outlined, color: EssTheme.slateBlue), onPressed: () {}),
                         FilledButton(onPressed: () {}, child: const Text('Post')),
                       ],
                     ),
                   ),
                   const SizedBox(height: 24),
                   
                   // Feed Items
                   const _FeedPost(
                     author: 'System Admin', 
                     time: '2 hours ago',
                     content: 'The new ESS Portal is officially live! Feel free to explore the new mobile-friendly features and provide feedback to the IT team.',
                     likes: 12,
                     comments: 3,
                     isOfficial: true,
                   ),
                   const SizedBox(height: 16),
                   const _FeedPost(
                     author: 'Aisha Williams', 
                     time: '5 hours ago',
                     content: 'Huge shoutout to the engineering team for delivering the Q1 release ahead of schedule! 🎉',
                     likes: 24,
                     comments: 8,
                   ),
                ],
              ),
            ),
            if (!isMobile) const SizedBox(width: 32),
            if (isMobile) const SizedBox(height: 32),
            
            // Celebration Cards
            Expanded(
              flex: isMobile ? 0 : 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Celebrations', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
                  const SizedBox(height: 16),
                  const _CelebrationCard('Marcus Kim', 'Birthday Today! 🎂', Icons.cake_rounded, EssTheme.warning),
                  const SizedBox(height: 16),
                  const _CelebrationCard('Sarah Patel', '3 Year Work Anniversary', Icons.workspace_premium_rounded, EssTheme.slateBlue),
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

class _FeedPost extends StatelessWidget {
  final String author, time, content;
  final int likes, comments;
  final bool isOfficial;

  const _FeedPost({
    required this.author,
    required this.time,
    required this.content,
    required this.likes,
    required this.comments,
    this.isOfficial = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: EssTheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: EssTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: isOfficial ? EssTheme.slateBlue : EssTheme.slateBlueLight.withValues(alpha: 0.2), child: isOfficial ? const Icon(Icons.campaign_rounded, color: Colors.white, size: 20) : Text(author[0], style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: EssTheme.slateBlue))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
                    Text(time, style: GoogleFonts.inter(fontSize: 11, color: EssTheme.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(content, style: GoogleFonts.inter(fontSize: 14, height: 1.5, color: EssTheme.textPrimary)),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.thumb_up_alt_outlined, size: 18, color: EssTheme.textSecondary),
              const SizedBox(width: 6),
              Text('$likes', style: GoogleFonts.inter(color: EssTheme.textSecondary, fontWeight: FontWeight.w500)),
              const SizedBox(width: 24),
              Icon(Icons.chat_bubble_outline_rounded, size: 18, color: EssTheme.textSecondary),
              const SizedBox(width: 6),
              Text('$comments', style: GoogleFonts.inter(color: EssTheme.textSecondary, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CelebrationCard extends StatelessWidget {
  final String name, event;
  final IconData icon;
  final Color color;

  const _CelebrationCard(this.name, this.event, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
                const SizedBox(height: 4),
                Text(name, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
