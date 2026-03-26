import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ess_theme.dart';

class EesAttendanceView extends StatelessWidget {
  const EesAttendanceView({super.key});

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
                Tab(text: 'Monthly View'),
                Tab(text: 'Regularization & Permissions'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildMonthlyGrid(context),
                _buildRegularizationTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyGrid(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text('March 2026', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
               Row(
                 children: [
                   IconButton(icon: const Icon(Icons.chevron_left_rounded), onPressed: () {}),
                   IconButton(icon: const Icon(Icons.chevron_right_rounded), onPressed: () {}),
                 ],
               ),
             ],
           ),
           const SizedBox(height: 24),
           LayoutBuilder(
             builder: (context, constraints) {
               final isMobile = constraints.maxWidth < 600;
               return GridView.builder(
                 shrinkWrap: true,
                 physics: const NeverScrollableScrollPhysics(),
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: isMobile ? 3 : 7,
                   childAspectRatio: 1.0,
                   crossAxisSpacing: 12,
                   mainAxisSpacing: 12,
                 ),
                 itemCount: 31,
                 itemBuilder: (context, index) {
                   final day = index + 1;
                   // Mock up some missing or weekend statuses
                   Color color = EssTheme.success;
                   String status = '9:00 - 18:00';
                   if (day == 7 || day == 8 || day == 14 || day == 15 || day == 21 || day == 22 || day == 28 || day == 29) {
                     color = EssTheme.textMuted;
                     status = 'Weekend';
                   } else if (day == 10 || day == 11) {
                     color = EssTheme.slateBlueLight;
                     status = 'Approved Leave';
                   } else if (day == 25) {
                     color = EssTheme.error;
                     status = 'Missing Swipe';
                   }

                   return Container(
                     padding: const EdgeInsets.all(8),
                     decoration: BoxDecoration(color: EssTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: EssTheme.border)),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text('$day', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: EssTheme.textPrimary)),
                         Container(
                           width: double.infinity,
                           padding: const EdgeInsets.symmetric(vertical: 4),
                           decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                           child: Text(status, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: color)),
                         ),
                       ],
                     ),
                   );
                 },
               );
             }
           ),
        ],
      ),
    );
  }

  Widget _buildRegularizationTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text('Pending Requests', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
             FilledButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening Attendance Regularization...'))), child: const Text('Apply Regularization')),
           ],
         ),
         const SizedBox(height: 16),
         Container(
           padding: const EdgeInsets.all(24),
           decoration: BoxDecoration(color: EssTheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: EssTheme.border)),
           child: Row(
             children: [
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: EssTheme.warning.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.update_rounded, color: EssTheme.warning)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('March 25, 2026', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
                      Text('Forgot to swipe out. Requested: 18:30', style: GoogleFonts.inter(fontSize: 13, color: EssTheme.textSecondary)),
                    ],
                  ),
                ),
                Text('Pending', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: EssTheme.warning)),
             ],
           ),
         ),
      ],
    );
  }
}
