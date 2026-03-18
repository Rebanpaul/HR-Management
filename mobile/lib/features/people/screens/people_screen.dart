import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/portal_header.dart';
import '../../../shared/widgets/section_header.dart';

class PeopleScreen extends ConsumerWidget {
  final VoidCallback? onOpenProfile;

  const PeopleScreen({
    super.key,
    this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          PortalHeader(onProfileTap: onOpenProfile),
          const SizedBox(height: 16),
          Text(
            'People',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Directory and org chart.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          SectionHeader(
            title: 'Directory',
            actionLabel: 'Search',
            onAction: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Directory API wiring coming soon.')),
              );
            },
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: CircleAvatar(child: Text('A')),
                  title: Text('Alex Johnson'),
                  subtitle: Text('Engineering'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: CircleAvatar(child: Text('S')),
                  title: Text('Sam Lee'),
                  subtitle: Text('Design'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SectionHeader(
            title: 'Org chart',
            actionLabel: 'View',
            onAction: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Org chart coming soon.')),
              );
            },
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Company',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• CEO\n  • HR\n  • Engineering\n  • Sales',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
