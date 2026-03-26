import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ess_theme.dart';

class EesProfileView extends StatelessWidget {
  const EesProfileView({super.key});

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
                Tab(text: 'Personal Info'),
                Tab(text: 'Secure Vault'),
                Tab(text: 'Delegates'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildPersonalInfoTab(),
                _buildVaultTab(),
                _buildDelegatesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            CircleAvatar(radius: 40, backgroundColor: EssTheme.slateBlueLight.withValues(alpha: 0.2), child: Text('JS', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: EssTheme.slateBlue))),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('John Smith', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: EssTheme.textPrimary)),
                  Text('Senior Developer • Engineering', style: GoogleFonts.inter(fontSize: 14, color: EssTheme.textSecondary)),
                ],
              ),
            ),
            FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.edit_rounded, size: 16), label: const Text('Edit Profile')),
          ],
        ),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 32),
        
        Text('Contact Information', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
        const SizedBox(height: 16),
        _InfoRow('Email', 'john.smith@co.com'),
        _InfoRow('Phone', '+1 (555) 123-4567'),
        _InfoRow('Work Location', 'San Francisco HQ, Desk 4B'),
      ],
    );
  }

  Widget _buildVaultTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: EssTheme.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: EssTheme.info.withValues(alpha: 0.3))),
          child: Row(
            children: [
              const Icon(Icons.shield_rounded, color: EssTheme.info, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Secure Document Vault', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: EssTheme.info)),
                    const SizedBox(height: 4),
                    Text('Documents here (ID proofs, tax forms) are heavily encrypted.', style: GoogleFonts.inter(fontSize: 13, color: EssTheme.textSecondary)),
                  ],
                ),
              ),
              FilledButton(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: EssTheme.info), child: const Text('Upload')),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _DocCard('Passport Copy', 'Uploaded: Jan 15, 2024'),
        _DocCard('Tax Declaration Form (12BA)', 'Uploaded: Mar 10, 2026'),
      ],
    );
  }

  Widget _buildDelegatesTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Approval Delegation', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
        const SizedBox(height: 8),
        Text('Assign someone else to approve requests on your behalf while you are away.', style: GoogleFonts.inter(fontSize: 13, color: EssTheme.textSecondary)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: EssTheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: EssTheme.border)),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: EssTheme.warning.withValues(alpha: 0.2), child: Text('RB', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: EssTheme.warning))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rachel Brown (QA Lead)', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: EssTheme.textPrimary)),
                    Text('Active until: April 25, 2026', style: GoogleFonts.inter(fontSize: 12, color: EssTheme.textSecondary)),
                  ],
                ),
              ),
              OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: EssTheme.error), child: const Text('Revoke')),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: GoogleFonts.inter(fontSize: 14, color: EssTheme.textSecondary))),
          Expanded(child: Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: EssTheme.textPrimary))),
        ],
      ),
    );
  }
}

class _DocCard extends StatelessWidget {
  final String title, date;
  const _DocCard(this.title, this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: EssTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: EssTheme.border)),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf_rounded, color: EssTheme.error, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: EssTheme.textPrimary)),
                Text(date, style: GoogleFonts.inter(fontSize: 12, color: EssTheme.textSecondary)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.download_rounded, color: EssTheme.textSecondary), onPressed: () {}),
        ],
      ),
    );
  }
}
